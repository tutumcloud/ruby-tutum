require_relative './spec_helper'

describe TutumNodeTypes do
  subject do
    TutumNodeTypes.new({})
  end

  it "can list" do
    expect(subject.list_url()).to eq("/nodetype/")
  end

  it "can get" do
    expect(subject.get_url("TEST")).to eq("/nodetype/TEST/")
  end
end
