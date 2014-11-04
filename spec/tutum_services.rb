require_relative './spec_helper'

describe TutumServices do
  subject do
    TutumServices.new({})
  end

  it "can list" do
    expect(subject.list_url()).to eq("/service/")
  end

  it "can create" do
    expect(subject.create_url()).to eq("/service/")
  end

  it "can get" do
    expect(subject.get_url("TEST")).to eq("/service/TEST/")
  end

  it "can update" do
    expect(subject.update_url("TEST")).to eq("/service/TEST/")
  end

  it "can redeploy" do
    expect(subject.redeploy_url("TEST")).to eq("/service/TEST/redeploy/")
  end

  it "can start" do
    expect(subject.start_url("TEST")).to eq("/service/TEST/start/")
  end

  it "can stop" do
    expect(subject.stop_url("TEST")).to eq("/service/TEST/stop/")
  end

  it "can terminate" do
    expect(subject.terminate_url("TEST")).to eq("/service/TEST/")
  end
end
