# MightyStruct

[![Build Status](https://travis-ci.org/msievers/mighty_struct.svg)](https://travis-ci.org/msievers/mighty_struct)
[![Test Coverage](https://codeclimate.com/github/msievers/mighty_struct/badges/coverage.svg)](https://codeclimate.com/github/msievers/mighty_struct/coverage)
[![Code Climate](https://codeclimate.com/github/msievers/mighty_struct/badges/gpa.svg)](https://codeclimate.com/github/msievers/mighty_struct)
[![Dependency Status](https://gemnasium.com/msievers/mighty_struct.svg)](https://gemnasium.com/msievers/mighty_struct)

`MightyStruct` is an object wrapper which gives deep method access to properties. It combines beneficial features from functionally related projects like `OpenStruct` and `Hashie::Mash` into an non-inversive, transparant decorator like object wrapper.

## Key features

* wraps any object that is an `Enumerable` (e.g `Array` or `Hash`)
* creates method accessors for any object that additionally responds to `:keys` (e.g. `Hash`)
* deep method access to object properties
* property accessors are implemented via methods, not `method_missing`
  * as a result tab completion in pry works
* dispite property accessors, the namespace of wrapped objects isn't touched
* all method calls which don't hit a property accessor are dispatched to the wrapped object
  * results are again wrapped to instances of MightyStruct if possible
* the wrapped object can be retrieved at any time using `MightyStruct.to_object(obj)`

## Example

```ruby
require "mighty_struct"

hash = {
  a: [
    { b: 1 },
    { b: 2 },
  ],
}

# create it from some hash or array
mighty_struct = MightyStruct.new(hash)

# access deeply nested properties 
mighty_struct.a[0].b # => 1

# call methods transparently on the wrapped objects
mighty_struct.a.last.b # => 2

# get back the original object ... look ma', it's still the same hash
MightyStruct.to_object(mighty_struct).eql?(hash) # => true
```

Or play with it on your own. It's just one command (line) away.

```bash
git clone https://github.com/msievers/mighty_struct.git && cd mighty_struct && bundle && bin/console
```

## Another of this "method invocation hashes", really?!

Before I started coding this, I tried the following three alternatives

* `OpenStruct`
* `recursive-open-struct`
* `Hashie::Mash`

But neither of them provided everything I wanted.

                   | MightyStruct | OpenStruct | recursive-open-struct | Hashie::Mash
---                | :----------: | :--------: | :-------------------: | :----------:
deep method access | :heavy_check_mark: | :heavy_multiplication_x: | (:heavy_check_mark:) | :heavy_check_mark:
real method accessors | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_multiplication_x:
works without object dupping | :heavy_check_mark: | :heavy_multiplication_x: | :heavy_multiplication_x: | :heavy_multiplication_x:
transparent method dispatching | :heavy_check_mark: | :heavy_multiplication_x: | :heavy_multiplication_x: | :heavy_multiplication_x:
original object retrieval | :heavy_check_mark: | :heavy_multiplication_x: | :heavy_multiplication_x: | :heavy_multiplication_x:

## Why are real methods as property accessors cool?

Method accessors for object properties can either be implemented via `method_missing` or by defining (singleton) methods. The benefit of real methods is, that if you are using a debugger (e.g. `pry`), you can use tab completion to discover methods defined on a object. This does not work for `method_missing` based accessors.

With real method accessors in place, playing with a `mighty_struct` within `pry` just feels like working within a shell.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/msievers/mighty_struct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
