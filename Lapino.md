# Lapino

A sinatra-based app that redirects data received via HTTP to an AMPQ message broker.

## Setup

Configure the following options in `config.ru` to run Lapino::Server.

```ruby

Lapino::Config.amqp_url    = 'amqp://guest:guest@localhost/'
Lapino::Config.exchange    = 'amq.direct'
Lapino::Config.routing_key = 'giraffi.nagios'
Lapino::Config.logging     = true if ENV['RACK_ENV'] == 'development'
Lapino.options.debug       = true if ENV['RACK_ENV'] == 'development'
Lapino.options.quiet       = false

```

## Usage

Start Lapino::Server using [puma](https://github.com/puma/puma/) as web server just like below. 

```bash
$ puma config.ru
```

And `CTRL+C` to stop the server.