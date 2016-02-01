Yet Another Immutable Struct Implementation

## Usage

First, add this to your Gemfile:

```ruby
gem 'ruby-immutable-struct'
```

```ruby
Person = RubyImmutableStruct.new('Person', :name, :email) do
  def rfc5322_email
    "\"#{name}\" <#{email}>"
  end
end

# Constructor accepts ordered arguments
person = Person.new('Adam Hooper', 'adam@adamhooper.com')

# Constructor also accepts a Hash. This produces the same thing (though it's
# a few microseconds slower):
person = Person.new(name: 'Adam Hooper', email: 'adam@adamhooper.com')

# However it's constructed, Methods work as you'd expect
person.name # 'Adam Hooper'
person.email # 'adam@adamhooper.com
person.rfc5322_email # '"Adam Hooper" <adam@adamhooper.com>

# You'll get a few free helpers:
person.to_h    # { name: 'Adam Hooper', email: 'adam@adamhooper.com' }
person.to_a    # [ 'Adam Hooper', 'adam@adamhooper.com' ]
person.inspect # '#<Person:"Adam Hooper","adam@adamhooper.com")'

# Instances are immutable. That means you can't write code like
# person.email = 'adam+nospam@adamhooper.com'
# You never change an instance; you only create a new one, like this:
person2 = person.merge(email: 'adam+nospam@adamhooper.com')
```

## Similar projects

Here are projects that are slightly different:

* [atomicobject/hamsterdam](https://github.com/atomicobject/hamsterdam) - is based on an immutable hash, which is indirection
* [iconara/immutable_struct](https://github.com/iconara/immutable_struct) - is defined using `Struct.new`, which is slow
* [stitchfix/immutable-struct](https://github.com/stitchfix/immutable-struct) - defines a `to_h` that is complicated

## License

MIT