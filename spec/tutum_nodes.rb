require_relative './spec_helper'

describe TutumNodes do
  subject do
    TutumNodes.new({})
  end

  it "can list" do
    expect(subject.list_url()).to eq("/node/")
  end

  it "can get" do
    expect(subject.get_url("TEST")).to eq("/node/TEST/")
  end

  it "can deploy" do
    expect(subject.deploy_url("TEST")).to eq("/node/TEST/deploy/")
  end

  it "can terminate" do
    expect(subject.terminate_url("TEST")).to eq("/node/TEST/")
  end
end
