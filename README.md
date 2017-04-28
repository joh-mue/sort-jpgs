# SortJpgs ![build status](https://api.travis-ci.org/joh-mue/sort-jpgs.svg?branch=master)

This is a little gem to sort through unnamed and unsorted jpgs and organize them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sort_jpgs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sort_jpgs

## Usage

```
Usage:sort_jpgs [-mh] [-t THRESHOLD] [-s SOURCE_PATH] -o OUTPUT_PATH

  -s, --source-path DIR            Set the directory that contains files to be sorted. Default is PWD
  -o, --output-path DIR            Set the directory that the files will be written to.
  -m, --move                       Move files instead of copying them.
  -t, --threshold VALUE            Set the minimum size that a picture has to be in kB.
  -h, --help                       Display this screen.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sort_jpgs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

