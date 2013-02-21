# encoding: utf-8
require 'test_helper'
require 'mocha'

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Lapin::Server.new
  end

  context "POST /publish.json" do
    setup do
      @payload = "{\"data\": \"sample\"}"
      Lapin::Config.amqp_url = 'amqp://guest:guest@localhost/'
    end

    teardown do
      @payload = nil
    end

    should "return 204 with an appropriate request" do
      m = mock()
      Bunny.expects(:new).with(Lapin::Config.amqp_config).returns(m)
      m.expects(:start)
      e = mock("exchange")
      m.stubs(:exchange).with(Lapin::Config.exchange, {:type => 'direct'}).returns(e)
      e.stubs(:publish).with(@payload, {:key => 'giraffi.nagios'})

      post "/publish.json", @payload, {"CONTENT_TYPE" => "application/json", "HTTP_X_ROUTING_KEY" => "giraffi.nagios"}
      assert_equal last_request.body.string, @payload
      assert_equal last_response.status, 204
    end

    should "return 400 with a malformed request body" do
      post "/publish.json", "malformed_body", {"CONTENT_TYPE" => "text/plain"}
      assert_equal last_response.status, 400
    end
  end

  context "Error handling" do
    setup do
      Lapin.options.quiet = true
    end

    should "return 412 when the sinatra.error is catched" do
      m = mock()
      Bunny.expects(:new).with(Lapin::Config.amqp_config).returns(m)
      m.stubs(:start).raises(Exception.new)

      post "/publish.json", @payload, {"CONTENT_TYPE" => "application/json"}
      assert_equal last_response.status, 412
    end

    should "return 502 when the connection is reset by peer" do
      m = mock()
      Bunny.expects(:new).with(Lapin::Config.amqp_config).returns(m)
      m.stubs(:start).raises(Errno::ECONNRESET.new)

      post "/publish.json", @payload, {"CONTENT_TYPE" => "application/json"}
      assert_equal last_response.status, 502
    end

    should "return 502 when the no connection and no socket are found" do
      m = mock()
      Bunny.expects(:new).with(Lapin::Config.amqp_config).returns(m)
      m.stubs(:start).raises(Bunny::ConnectionError.new)

      post "/publish.json", @payload, {"CONTENT_TYPE" => "application/json"}
      assert_equal last_response.status, 502
    end

    should "return 502 when the broken pipe is catched" do
      m = mock()
      Bunny.expects(:new).with(Lapin::Config.amqp_config).returns(m)
      m.stubs(:start).raises(Bunny::ServerDownError.new)

      post "/publish.json", @payload, {"CONTENT_TYPE" => "application/json"}
      assert_equal last_response.status, 502
    end

  end
end
