Yet Another Immutable Struct Implementation

## Usage

First, add this to your Gemfile:

```ruby
gem 'ruby-immutable-struct'
```

Then use it like this:

```ruby
Person = RubyImmutableStruct.new(:name, :email) do
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

# When two immutable structs have the same values, they are equal
person3 = person2.merge(email: 'adam@adamhooper.com')
person == person3    # true
person.eql?(person3) # true
# And that means you can use them in a hash
hash = { person => 'yay' }
hash[person3] # 'yay'
```

Here's a bit of a hack for when you want to run calculations just once:

```ruby
Person = RubyImmutableStruct.new(:name, :email) do
  def after_initialize
    if @email.nil?
      @email = "#{name.gsub(/[^a-zA-Z0-9]+/, '-')}@gmail.com"
    end
  end
end
```

## Similar projects

Here are projects that are slightly different:

* [atomicobject/hamsterdam](https://github.com/atomicobject/hamsterdam) - is based on an immutable hash, which is indirection
* [iconara/immutable_struct](https://github.com/iconara/immutable_struct) - is defined using `Struct.new`, which is slow
* [stitchfix/immutable-struct](https://github.com/stitchfix/immutable-struct) - defines a `to_h` that is complicated

## License

MIT
