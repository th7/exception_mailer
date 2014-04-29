# Exception Mailer

Send an email in response to uncaught exceptions

## Installation

Add this line to your application's Gemfile:

    gem 'exception_mailer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exception_mailer

## Usage
Uses http://www.ruby-doc.org/stdlib-2.1.1/libdoc/net/smtp/rdoc/Net/SMTP.html
```
ExceptionMailer.mail_exceptions do
  # code that may raise an exception
end
```
```
include ExceptionMailer

mail_exceptions do
  # code that may raise an exception
end
```
Oops, don't forget config!
```
ExceptionMailer.configure do |c|
  c.server = 'your.smtp.server' # defaults to 'localhost'
  c.port = 25 # defaults to this value
  c.host = 'your.hostname'
  c.account = 'your@smtp.account'
  c.password = ENV['SMTP_PASSWORD'] # or load it from a file -- hardcoded passwords are bad, mmkay?
  c.auth_method = :plain # or :login or :cram_md5

  c.from = 'from' # defaults to 'ExceptionMailer'
  c.to = [ 'one@destination.address', 'another@to.address' ] # or a single string
  c.subject = 'your subject line' # defaults to 'Exception Occurred'
end
```
All of the above options can be overridden for a specific block
```
mail_exceptions(to: 'mom@msn.net', subject: 'Hi Mom!') do
  # code that raises exceptions your mom wants to see
end
```
The message body will look kind of like this:
```
RuntimeError: hi
(irb):6:in `block in irb_binding'
/Users/tyler.hartland/dev/exception_mailer/lib/exception_mailer.rb:12:in `mail_exceptions'
(irb):6:in `irb_binding'
/Users/tyler.hartland/.rvm/rubies/ruby-2.1.1/lib/ruby/2.1.0/irb/workspace.rb:86:in `eval'
...
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/exception_mailer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
