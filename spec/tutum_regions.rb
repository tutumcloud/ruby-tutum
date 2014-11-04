require_relative './spec_helper'

describe TutumRegions do
  subject do
    TutumRegions.new({})
  end
  
  it "can list" do
    expect(subject.list_url()).to eq("/region/")
  end

  it "can get" do
    expect(subject.get_url("TEST")).to eq("/region/TEST/")
  end
end
