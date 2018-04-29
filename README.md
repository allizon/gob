# Gob (Generic OBject) for Ruby
`gob` provides a generic object for Ruby with lots and lots of yummy syntactic sugar, great for storing settings or options and the like. I'm sure there are other fantastic uses for it, too! There have to be, right?

### Installation
`gem install gob`

Or add it to your Gemfile. It's really that simple. I mean, I hope it is. Let me know if it's not!

### Example
```ruby
config = Gob.new(debug: true, outfile: '/tmp/outfile.txt')
do_this_thing if config.debug?
write_file(config.outfile) if config.outfile? # (or config.has?(:outfile))

config.set(print: true)
print_output if config.true_any?(:debug, :print)
```

### Usage
Create a new generic object and access each of the provided hash keys as object methods:
```ruby
gob = Gob.new(a: 1, b: 2, c: 3)
gob.a => 1
gob.b => 2
gob.c => 3
```

OK, well, that's not enough, you say? You're right, it's not. You can also:

Set additional key-value pairs or set values directly on your object!
```ruby
gob.set(d, 4)
gob.d => 4

gob.e = 5
gob.e => 5
```

Check for the truthiness of any given key or any of a list of keys!
```ruby
gob.a? => true # Shortcut for checking any key
gob.true?(:a) => true # A little more explicit
gob.false?(:a) => false

gob.f = false
gob.f? => false
gob.false?(:f) => false

gob.true_any?(:a, :f) => true
gob.false_any?(:a, :f) => true

# Undefined keys return false
gob.not_here? => false
gob.true?(:not_here) => false
gob.false?(:not_here) => true
```

Check to see if a given key -- or one of a list of keys -- exists!
```ruby
gob.has?(:a) => true
gob.has?(:z) => false

gob.has_any?(:a, :z) => true
gob.has_any?(:y, :z) => false
```

Use `fetch` to provide a default value if the key is missing or empty:
```ruby
gob.fetch(:z, 'default') => 'default'
```

Use `to_a` to get an array of values or `to_h` to return the underlying hash:
```ruby
gob = Gob.new(a: 1, b: 2, c: 3)
gob.to_a => [1, 2, 3]
gob.to_h => { a: 1, b: 2, c: 3 }
```

### FAQ
**Do you pronounce it "johb" like "Gob Bluth" or "gahb" like "gob of bubblegum"?**

Doesn't much matter to me! I was thinking of the former, but the latter works, too. I'm not getting into a pronounciation-of-GIF-style flamewar over this thing. :)

### Contributing
I'm more than happy to take pull requests -- I'm sure there's a ton more that could be done to this thing

### License
MIT.
