# Yaml2issues

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/yaml2issues`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yaml2issues'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaml2issues

## Usage

This gem provides an executable `yaml2issues`.

```sh
yaml2issues add_issues -a <github-account-name> -p <project-slug> -i <yaml file containing issues>
```

example:

```sh
yaml2issues add_issues -a kavyasukumar -p yaml2issues -i ~/issues.yaml
```

The issues file should be a valid YAML file and formatted as follows

```yaml
- milestone: Required. Name of milestone
  due: Optional. Date in mm/dd/yyyy format
  desc: Optional. Description of the milestone
  issues:
  - title: Required. Title of the issue
    body: Optional. Body text
    labels: optional. comma-separated list of labels
    assign_to: optional. github username
  - title:  Required. Title of the issue 2
```

Example

```yaml
- milestone: MVP
  due: 05/31/2019
  desc: Very minimal. Very viable. Very product
  issues:
  - title: Add sort to the table
    body: Table should be sortable by header
    labels: UI/UX
    assign_to: kavyasukumar
  - title: App crashes when table has more than 1000 rows
    labels: bug, investigate

- milestone: Backlog
  issues:
  - title: Table must transform into spaceship
  - title: Table must make TARDIS sounds on load
```

When an issue is created, the gem will add an `id` field to the issue. Any changes made to the issue with an id will then update the issue with that id on Github.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yaml2issues. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Yaml2issues project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yaml2issues/blob/master/CODE_OF_CONDUCT.md).
