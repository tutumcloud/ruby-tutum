require_relative './spec_helper'

describe TutumNodeTypes do
  subject do
    TutumNodeTypes.new({})
  end
  it "can list" do
    expect(subject.list_url()).to eq("/node_type/")
  end
  it "can get" do
    expect(subject.get_url("TEST")).to eq("/node_type/TEST/")
  end
end
