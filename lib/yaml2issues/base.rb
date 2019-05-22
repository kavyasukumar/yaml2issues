require 'io/console'
require 'yaml'
require 'octokit'
require 'active_support/json'
require 'thor'

module Yaml2Issues
  # Base API client object
  class Base < Thor
    class_option :account,
                  aliases: '-a',
                  type: :string,
                  desc: 'Github organization or account name'
    class_option :project,
                  aliases: '-p',
                  type: :string,
                  desc: 'Github project slug'
    class_option :issues_file,
                  aliases: '-i', type: :string,
                  desc: 'YAML file containing issues to upload'


    desc 'add_issues', 'Add or update issues on github'
    def add_issues
      authenticate_with_github
      setup_github_issues
    end

    private

    def init(account: nil, project: nil, issues_file: nil , console_output: nil)
      @account = account
      raise ConfigError, 'Github account or organization was not provided' if @account.nil?

      @project = project
      raise ConfigError, 'Github project was not provided' if @project.nil?

      @issues_file = issues_file || DEFAULT_ISSUES_FILENAME

      @github_client = setup_github_api
      raise ConfigError, 'Could not conect to github' if @github_client.nil?

      @console_output = console_output || $stdout
      @github_client
    end


    def generate_github_token
      # Prompt for username and password
      username = ask('Enter your github username:')
      password = ask('Enter your github password:', echo: false)
      mfa = ask('If you use 2FA, enter your 2FA code. Else hit enter:')

      headers = {}
      headers = { 'X-GitHub-OTP' => mfa } if mfa.present?

      github_client = Octokit::Client.new login: username, password: password
      github_client.create_authorization(
        scopes: %w[user repo],
        note: "Yaml2Issues #{Random.new(9999999999)}",
        headers: headers
      ).token
    end

    def setup_github_api
      token_file = File.expand_path('~/.yaml2issues_github_oauth.txt')
      token = File.exist?(token_file) ? File.read(token_file) : ENV['GITHUB_TOKEN']

      unless token
        token = generate_github_token

        # Save token for reuse
        File.write(token_file, token)
      end

      # Connect to github
      github_client = Octokit::Client.new(access_token: token)
      github_client.user.login
      github_client
    end

    def load_config_file(name)
      YAML.load_file(name).freeze
    end

    def save_config_file(name, content)
      File.open(name, 'w') {|f| f.write content.to_yaml }
    end

    def setup_github_milestones(issues)
      say "Processing milestones..."
      milestones_in_gh = @github_client.list_milestones(repo)
      gh_milestone_titles = milestones_in_gh.map(&:title)

      file_milestone_titles = issues.map { |t| t['milestone'] }

      new_milestones = file_milestone_titles - gh_milestone_titles

      new_milestones.each do |m|
        milestone = issues.find {|t| t['milestone'] == m }

        options = {}
        options[:description] = milestone['desc'] if milestone['desc'].present?
        options[:due_on] = DateTime.strptime(milestone['due'], '%m/%d/%Y').to_s if milestone['due'].present?

        say "Creating milestone #{m}"
        @github_client.create_milestone(repo, m, options)
      end

      milestones_in_gh = @github_client.list_milestones(repo)
      milestones_in_gh.map {|m| [m[:title], m[:number]] }.to_h
    end

    def setup_github_issues
      # Load issues
      tasks = load_config_file @issues_file
      milestones = setup_github_milestones(tasks)

      # Create issues
      say "Creating issues..."
      tasks.each_with_index do |task, i|
        milestone_number = milestones[task['milestone']]

        task['issues'].each_with_index do |issue, j|
          if issue['id'].present?
            gh_issue = @github_client.issue(repo, issue['id'])
            options = {
              :milestone => milestone_number.to_i,
              :assignee => issue['assign_to']
            }
            options[:lables] = issue['labels'].split(',').map(&:strip) if issue['labels'].present?

            say "Updating issue #{gh_issue[:number]} - #{issue['title']}"
            gh_issue = @github_client.update_issue(repo, issue['id'], issue['title'], issue['body'], options)
          else
            say "Creating issue #{issue['title']}"
            gh_issue = @github_client.create_issue(repo, issue['title'], issue['body'], { :milestone => milestone_number.to_i, :assignee => issue['assign_to'], :labels => issue['labels']})
          end

          tasks[i]['issues'][j]['id'] = gh_issue[:number]
        end
      end
      save_config_file(@issues_file, tasks)
    end

    def repo
      "#{@account}/#{@project}"
    end

    def repo_url
      "https://github.com/#{repo}.git"
    end

    def yes?(text)
      super(set_color(text, :blue, :bold) + ' [y/n] (n)')
    end

    def no?(text)
      super(set_color(text, :blue, :bold) + ' [y/n] (y)')
    end

    def ask(text, **opts)
      super(set_color(text, :blue, :bold), **opts)
    end

    def say_error(text)
      say("#{text}\n", :red)
    end

    def say_success(text)
      say("#{text}\n", :green)
    end

    def exit_with_error(text)
      raise Thor::Error, text
    end

    def handle_api_errors(ignore_not_found: false)
      yield
    rescue NotFound => ex
      raise if ignore_not_found
      exit_with_error "Not found: #{ex.path}"
    rescue NotAllowed => ex
      exit_with_error "Not allowed: #{ex.path}"
    rescue Error, SystemCallError => ex
      exit_with_error ex.message
    end

    def authenticate_with_github
      return @github_client if @github_client
      opts = options || {}
      popts = parent_options || {}
      init(
        account: opts[:account] || ENV['GITHUB_ACCOUNT'],
        project: opts[:project],
        issues_file: opts[:issues_file],
        console_output: $stderr
      )
    rescue ConfigError
      say_error 'You must provide github account and projects name'
      help
      exit 1
    end
  end
end
