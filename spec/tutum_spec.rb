require_relative './spec_helper'
require 'base64'

test_username = ENV['TUTUM_USERNAME'] || "tutum_username"
test_api_key = ENV['TUTUM_API_KEY'] || "tutum_api_key"
test_tutum_auth = ENV['TUTUM_AUTH'] || "Basic #{Base64.strict_encode64(test_username + ':' + test_api_key)}"
json_opts = {}

describe Tutum do

  describe "Existing initialize api" do

    subject do
      Tutum.new(test_username, test_api_key)
    end

    it "has a username and apikey" do
      expect(subject.username).to eq(test_username)
      expect(subject.api_key).to eq(test_api_key)
      expect(subject.json_opts).to be_nil
    end

  end

  describe "Existing initialize api with json_opts" do

    subject do
      Tutum.new(test_username, test_api_key, json_opts)
    end

    it "has a username and apikey" do
      expect(subject.username).to eq(test_username)
      expect(subject.api_key).to eq(test_api_key)
      expect(subject.json_opts).to eq(json_opts)
    end

  end

  describe "New initialize api" do

    subject do
      Tutum.new(username: test_username, api_key: test_api_key)
    end

    it "has a username and apikey" do
      expect(subject.username).to eq(test_username)
      expect(subject.api_key).to eq(test_api_key)
      expect(subject.json_opts).to be_nil
    end
  end

  describe "New initialize api with json_opts" do

    subject do
      Tutum.new(username: test_username, api_key: test_api_key, json_opts: json_opts)
    end

    it "has a username and apikey" do
      expect(subject.username).to eq(test_username)
      expect(subject.api_key).to eq(test_api_key)
      expect(subject.json_opts).to eq(json_opts)
    end

    it "uses basic auth from username and apikey" do
      expect(subject.headers["Authorization"]).to eq(test_tutum_auth)
    end
  end

  describe "New initialize api with tutum_auth" do

    subject do
      Tutum.new(tutum_auth: test_tutum_auth, json_opts: json_opts)
    end

    it "has a tutum_auth" do
      expect(subject.tutum_auth).to eq(test_tutum_auth)
      expect(subject.json_opts).to eq(json_opts)
    end

    it "compiles headers" do
      expect(subject.headers["Authorization"]).to eq(test_tutum_auth)
    end

  end

  describe "Calls to api" do

    subject do
      Tutum.new(username: test_username, api_key: test_api_key)
    end

    it "compiles headers" do
      expect(subject.headers["Authorization"].length).to be > 1
      expect(subject.headers["Accept"]).to eq("application/json")
    end

    it "#actions calls the actions API" do
      expect(subject.actions).to be_a TutumActions
    end

    it "#containers calls the containers API" do
      expect(subject.containers).to be_a TutumContainers
    end

    it "#node_clusters class the node clusters API" do
      expect(subject.node_clusters).to be_a TutumNodeClusters
    end

    it "#node_types calls the node types API" do
      expect(subject.node_types).to be_a TutumNodeTypes
    end

    it "#nodes the nodes API" do
      expect(subject.nodes).to be_a TutumNodes
    end

    it "#providers calls the providers API" do
      expect(subject.providers).to be_a TutumProviders
    end

    it "#regions calls the regions API" do
      expect(subject.regions).to be_a TutumRegions
    end

    it "#services calls the services API" do
      expect(subject.services).to be_a TutumServices
    end
  
    it "#stacks calls the stacks API" do
      expect(subject.stacks).to be_a TutumStacks
    end
  end
end
