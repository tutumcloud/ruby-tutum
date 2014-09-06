require_relative './spec_helper'

describe TutumClusters do
  subject do
    TutumClusters.new({})
  end
  it "can list" do
    expect(subject.list_url()).to eq("/application/")
  end
  it "can create" do
    expect(subject.create_url()).to eq("/application/")
  end
  it "can get" do
    expect(subject.get_url("TEST")).to eq("/application/TEST/")
  end
  it "can update" do
    expect(subject.update_url("TEST")).to eq("/application/TEST/")
  end
  it "can start" do
    expect(subject.start_url("TEST")).to eq("/application/TEST/start/")
  end
  it "can stop" do
    expect(subject.stop_url("TEST")).to eq("/application/TEST/stop/")
  end
  it "can redeploy" do
    expect(subject.redeploy_url("TEST")).to eq("/application/TEST/redeploy/")
  end
  it "can terminate" do
    expect(subject.delete_url("TEST")).to eq("/application/TEST/")
  end
end
