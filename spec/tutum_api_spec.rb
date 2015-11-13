require_relative './spec_helper'
require 'webmock/rspec'

describe TutumApi do

  describe 'When given JSON options' do

    subject(:tutum_api) { TutumApi.new({}, {:symbolize_names => true}) }

    SERVICES = {
        :uuid => "097f4ec3-d70a-441e-9b4f-df70a102cbd1",
        :image_name => "trunk/hello-world:v1",
        :name => "hello-world",
        :linked_from_service => [
            {
                :name => "lb",
            }
        ]
    }
    SERVICES_JSON = JSON.generate(SERVICES)

    it 'should symbolize names for get response' do
      # given
      stub_request(:get, "#{tutum_api.url("/test")}").to_return(:status => 200, :body => SERVICES_JSON)

      # when
      service = tutum_api.http_get("/test")

      # then
      expect(service).to eq(SERVICES)
      expect(service[:linked_from_service][0][:name]).to eq("lb")
    end

    it 'should symbolize names for post response' do
      # given
      stub_request(:post, "#{tutum_api.url("/test")}").to_return(:status => 200, :body => SERVICES_JSON)

      # when
      service = tutum_api.http_post("/test", content = {})

      # then
      expect(service).to eq(SERVICES)
      expect(service[:linked_from_service][0][:name]).to eq("lb")
    end

    it 'should symbolize names for patch response' do
      # given
      stub_request(:patch, "#{tutum_api.url("/test")}").to_return(:status => 200, :body => SERVICES_JSON)

      # when
      service = tutum_api.http_patch("/test")

      # then
      expect(service).to eq(SERVICES)
      expect(service[:linked_from_service][0][:name]).to eq("lb")
    end

    it 'should symbolize names for delete response' do
      # given
      stub_request(:delete, "#{tutum_api.url("/test")}").to_return(:status => 200, :body => SERVICES_JSON)

      # when
      service = tutum_api.http_delete("/test")

      # then
      expect(service).to eq(SERVICES)
      expect(service[:linked_from_service][0][:name]).to eq("lb")
    end
  end

end