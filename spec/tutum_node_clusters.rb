require_relative './spec_helper'

describe TutumNodeClusters do
  subject do
    TutumNodeClusters.new({})
  end

  it "can list" do
    expect(subject.list_url()).to eq("/nodecluster/")
  end

  it "can create" do
    expect(subject.create_url()).to eq("/nodecluster/")
  end

  it "can get" do
    expect(subject.get_url("TEST")).to eq("/nodecluster/TEST/")
  end

  it "can update" do
    expect(subject.update_url("TEST")).to eq("/nodecluster/TEST/")
  end

  it "can deploy" do
    expect(subject.deploy_url("TEST")).to eq("/nodecluster/TEST/deploy/")
  end

  it "can terminate" do
    expect(subject.terminate_url("TEST")).to eq("/nodecluster/TEST/")
  end
end
