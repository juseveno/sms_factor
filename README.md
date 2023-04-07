# SMS Factor

An easy way to use API SMS of http://www.smsfactor.com/ (http://www.smsfactor.com/api-sms/)

# Installation

You can install sms_factor by adding this line in your Gemfile :

```
gem 'sms_factor'
```

And then run :

```
bundle install
```

# Configuration

To use this gem, configure SmsFactor using your API information :

```ruby
SmsFactor::Init.configure do |config|
  # config.api_url = 'http://api.smsfactor.com'
  # config.verify_ssl = false
  config.api_default_from = '<a default sender name>'

  # Authentications
  # 1. API key (recommended)
  config.api_key = '<your API key>'

  # 2. email / password (legacy)
  # config.api_login = '<your_email@your_company.com>'
  # config.api_password = '<your_password>'
end
```

# Usage

To send a SMS :

```ruby
r = SmsFactor.sms('Hello World', '336++++++++') # to a single recipient
r = SmsFactor.sms('Hello World', ['336++++++++', '336++++++++', '336++++++++']) # to multiple recipients
r = SmsFactor.sms('Hello World', '336++++++++', 'Toto') # to override default from
```

To retrieve your credit after the sms was sent :

```ruby
r.credit
```

# Development

In the case you have [Docker](https://www.docker.com/) on you machine, you can
use the [Earthly](https://earthly.dev/) tool in order to build a Docker image
with all the dependencies for this project and run the test suite:

```
earthly --allow-privileged +rspec
```
_This command will build the image the first time, and then run the unit testing
frameworr Rspec._

Earthly reduces the differences between your machine and your CI by isolating
Docker in Docker. Running the tests in Earthly on your machine will run the same
as running on your CI. The only differences remaining are CPU and Internet
speed.

While developing, you will prefer using `docker-compose` to run in a quicker
manner your commands:

```
docker-compose run --rm gem rubocop
```
_The Docker ENTRYPOINT being `bundle exec` all the passed commands are prefixed
and make rspec, rubocop and the other Ruby commands available without writing
`bundle exec`._

# Copyright

Copyright (c) 2015 Julien Séveno
