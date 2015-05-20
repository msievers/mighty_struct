# MightyStruct

MightyStruct is a Enumerable wrapper which gives deep method access to object properties using method notation (just like `OpenStruct`). It tries to combine several approaches from other projects

* easy creation from existing hashes/arrays
* deep method access
* transparent method passing to the underlaying datastructure

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

# get back the original hash ... look ma, it's still the some hash
mighty_struct.to_object.eql?(hash) # => true
```

Or play with it on your own. It's just one command (line) away.

```bash
git clone https://github.com/msievers/mighty_struct.git && cd mighty_struct && bundle && bin/console
```

## Another of this method invocation hashes? Really?!

Before I started coding this, I tried the following three alternatives

* `OpenStruct`
* `recursive-open-struct`
* `Hashie::Mash`

Neither of them provided everything I wanted.

`OpenStruct` does not provide recursive behavior out-of-the-box. Several gems try to fill the gap, but I had no luck with the one I tested.

`recursive-open-struct` struggled with some deep nested array/hash combinations.

`Hashie::Mash` came close, but it seems, the method accessors are handled via method_missing, which prevents tab completion when doing things in `pry`.

I thought it realy would be nice to jump through hashes like one would do on the console with tab completion aso.

Performance and easy retrival of the original objects was another consideration.

## Usage

```ruby


```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/msievers/mighty_struct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
