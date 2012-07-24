# Lapino

A sinatra-based app that redirects data received via HTTP to an AMQP message broker.

## Installation

```bash
$ gem install lapino
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
