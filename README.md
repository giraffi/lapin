# Lapin

[![Build Status](https://secure.travis-ci.org/giraffi/lapin.png?branch=master)](http://travis-ci.org/giraffi/lapin)&nbsp;[![Code Climate](https://codeclimate.com/github/giraffi/lapin.png)](https://codeclimate.com/github/giraffi/lapin)

A sinatra-based app that provides a JSON endpoint over HTTP for interacting with an AMQP message broker.

## Requirements

* [RabbitMQ](http://www.rabbitmq.com/) server

## Installation

```bash
$ gem install lapin
```

To use with bundler, drop in your Gemfile.

```ruby
gem "lapin", :git => "git://github.com/giraffi/lapin.git"
```

## Setup

Create `config.ru` in the root folder of your app.

```ruby
require 'lapin'

Lapin::Config.amqp_url = 'amqp://guest:guest@localhost/vhost'
Lapin::Config.exchange = 'amq.direct'
Lapin::Config.logging  = true if ENV['RACK_ENV'] == 'development'
Lapin.options.quiet    = false

run Lapin::Server
```

## Usage

Just do the following to start `Lapin::Server` using [thin](https://github.com/macournoyer/thin/) for the web server.

```bash
$ thin start -R config.ru
```

Or, rackup with [puma](http://puma.io/),

```bash
$ rackup config.ru -s puma
```

To handle a POST request like below, you need a running RabbitMQ server according to the `Lapin::Config.amqp_url` option beforehand.

```bash
$ curl -v \
> -H "Accept: application/json" -H "Content-type: application/json" -H "X-ROUTING-KEY: amqp.giraffi" \
> -X POST -d '{"user":{"name":"foo", "email":"hoge@example.com"}}'  \
> http://localhost:3000/publish.json
```
