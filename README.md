# Cocoapods Dependency

[![Build Status](https://travis-ci.org/X140Yu/cocoapods-dependency.svg?branch=master)](https://travis-ci.org/X140Yu/cocoapods-dependency)
[![Coverage Status](https://coveralls.io/repos/github/X140Yu/cocoapods-dependency/badge.svg?branch=master)](https://coveralls.io/github/X140Yu/cocoapods-dependency?branch=master)


A ruby gem which analyzes the dependencies of any cocoapods projects. Subspecs are properly handled.

## Installation & Usage

Clone this repo,

And then execute:

    $ cd cocoapods-dependency
    $ bundle
    $ bin/analyze /path/to/podfile_dir

Note: the argument has to be a absolute path to the podfile directory.

You will get a result like this,

```ruby
{
  'Texture' => ['PINCache', 'PINOperation', 'PINRemoteImage'],
  'PINCache' => ['PINOperation'],
  'PINRemoteImage' => ['PINCache', 'PINOperation'],
  'PINOperation' => [],
}
```

## Why this gem?

Suppose you have a project with a simple dependency,

```ruby podfile
target 'Test' do
  pod 'Texture', '2.7'
end
```

It seems like this project has just a single dependency, but behind this pod, it may depend on several other pods and these other pods may also depend on some other pods as well 🤦🏻‍♂️, it's hard to determine what the exactly dependency situation of the project with just a glance of the podfile. So I wrote this it to do this thing.

- ✅ It can print all the dependencies
- ✅ Each dependecy's dependencies can also be printed
- ✅ Subspecs are properly handled, `pod 'Texture', '2.7'` and `pod 'Texture', '2.7', subspecs: %w[PINRemoteImage IGListKit Yoga]` will lead to different results

## TODO

- [ ] Pretty printed result
- [ ] Lift it to a cocoapods-plugin

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
