require_relative './spec_helper'

describe TutumStacks do
  subject do
    TutumStacks.new({})
  end

  it "can list" do
    expect(subject.list_url()).to eq("/stack/")
  end

  it "can get" do
    expect(subject.get_url("TEST")).to eq("/stack/TEST/")
  end

  it "can create" do
    expect(subject.create_url()).to eq("/stack/")
  end

  it "can export" do
    expect(subject.export_url("TEST")).to eq("/stack/TEST/export/")
  end

  it "can start" do
    expect(subject.start_url("TEST")).to eq("/stack/TEST/start/")
  end

  it "can stop" do
    expect(subject.stop_url("TEST")).to eq("/stack/TEST/stop/")
  end

  it "can update" do
    expect(subject.update_url("TEST")).to eq("/stack/TEST/")
  end

  it "can redeploy" do
    expect(subject.redeploy_url("TEST")).to eq("/stack/TEST/redeploy/")
  end

  it "can terminate" do
    expect(subject.terminate_url("TEST")).to eq("/stack/TEST/")
  end
end
