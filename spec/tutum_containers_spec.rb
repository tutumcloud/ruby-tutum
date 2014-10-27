require_relative './spec_helper'

describe TutumContainers do
  subject do
    TutumContainers.new({})
  end
  it "can list" do
    expect(subject.list_url()).to eq("/container/")
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
  it "can terminate" do
    expect(subject.terminate_url("TEST")).to eq("/container/TEST/")
  end
end
