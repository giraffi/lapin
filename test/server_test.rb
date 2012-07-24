# encoding: utf-8
require 'test_helper'

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  context "POST /publish" do

    def app
      Lapino::Server.new
    end

    setup do
      @app = Lapino::Server
      @body = "{\"data\": \"sample\"}"
    end

    should 'return 204 with an appropriate request' do
      post("/publish.json", @body, {"CONTENT_TYPE" => "application/json"})
      assert_equal last_request.body.string, @body

      # why route is not found?
      assert_equal last_response.status, 204
    end

    #should 'return 400 with a malformed request body' do
    #  post "/publish.json"
    #  assert true
    #end
  end
end
