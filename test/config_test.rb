# encoding: utf-8
require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  context 'AMQP URL parsing' do
    setup do
      Lapino::Config.amqp_url = 'amqp://guest:guest@localhost:5671/my-vhost'
    end

    should 'handle all options properly' do
      assert_equal Lapino::Config.amqp_config[:user], 'guest'
      assert_equal Lapino::Config.amqp_config[:pass], 'guest'
      assert_equal Lapino::Config.amqp_config[:host], 'localhost'
      assert_equal Lapino::Config.amqp_config[:port], 5671
      assert_equal Lapino::Config.amqp_config[:vhost], '/my-vhost'
      assert_equal Lapino::Config.amqp_config[:logging], false
    end

    should 'set routing routing to * when x-routing-key is not set' do
      Lapino::Config.routing_key = nil
      assert_equal "*", Lapino::Config.routing_key
    end
  end
end
