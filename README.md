# Lapino

[![Build Status](https://secure.travis-ci.org/giraffi/lapino.png?branch=master)](http://travis-ci.org/giraffi/lapino)

A sinatra-based app that redirects data received via HTTP to an AMQP message broker.

## Installation

To use with bundler, drop in your Gemfile.

```ruby
gem "lapino", :git => "git://github.com/giraffi/lapino.git"
```

## Setup

Create `config.ru` in the root folder of your app.

```ruby
require 'lapino'

Lapino::Config.amqp_url    = 'amqp://guest:guest@localhost/'
Lapino::Config.exchange    = 'amq.direct'
Lapino::Config.routing_key = 'giraffi.nagios'
Lapino::Config.logging     = true if ENV['RACK_ENV'] == 'development'
Lapino.options.debug       = true if ENV['RACK_ENV'] == 'development'
Lapino.options.quiet       = false

run Lapino::Server
```

## Usage

Just do the following to start `Lapino::Server` using [puma](https://github.com/puma/puma/) for the web server.

```bash
$ puma config.ru
```

`CTRL+C` to stop the server.
