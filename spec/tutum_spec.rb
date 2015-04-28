require_relative './spec_helper'

test_username = ENV['TUTUM_USERNAME']
test_api_key = ENV['TUTUM_API_KEY']

describe Tutum do
  subject do
    Tutum.new(test_username, test_api_key)
  end

  it "has a username and apikey" do
    expect(subject.username).to eq(test_username )
    expect(subject.api_key).to eq(test_api_key )
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

  it "#services services API" do
    expect(subject.services).to be_a TutumServices
  end
end
