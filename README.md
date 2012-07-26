# Lapino

[![Build Status](https://secure.travis-ci.org/giraffi/lapino.png?branch=master)](http://travis-ci.org/giraffi/lapino)&nbsp;[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/giraffi/lapino)

A sinatra-based app that redirects data received via HTTP to an AMQP message broker.

## Installation

```bash
$ gem install lapino
```

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
Lapino.options.quiet       = false

run Lapino::Server
```

## Usage

Just do the following to start `Lapino::Server` using [thin](https://github.com/macournoyer/thin/) for the web server.

```bash
$ thin start -R config.ru
```

Or, for [passenger](http://www.modrails.com/) (standalone version),

```bash
$ passenger start -R config.ru
```