require_relative './spec_helper'

describe TutumContainers do
  subject do
    TutumContainers.new({})
  end
  it "can list" do
    expect(subject.list_url()).to eq("/container/")
  end
  it "can create" do
    expect(subject.create_url()).to eq("/container/")
  end
  it "can get" do
    expect(subject.get_url("TEST")).to eq("/container/TEST/")
  end
  it "can start" do
    expect(subject.start_url("TEST")).to eq("/container/TEST/start/")
  end
  it "can stop" do
    expect(subject.stop_url("TEST")).to eq("/container/TEST/stop/")
  end
  it "can get logs" do
    expect(subject.logs_url("TEST")).to eq("/container/TEST/logs/")
  end
  it "can redeploy" do
    expect(subject.redeploy_url("TEST")).to eq("/container/TEST/redeploy/")
  end
  it "can delete" do
    expect(subject.delete_url("TEST")).to eq("/container/TEST/")
  end
end
