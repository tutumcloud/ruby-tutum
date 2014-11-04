require_relative './spec_helper'

describe TutumProviders do
  subject do
    TutumProviders.new({})
  end
  
  it "can list" do
    expect(subject.list_url()).to eq("/provider/")
  end

  it "can get" do
    expect(subject.get_url("TEST")).to eq("/provider/TEST/")
  end
end
