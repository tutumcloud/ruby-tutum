require_relative './spec_helper'

describe TutumImages do
  subject do
    TutumImages.new({})
  end

  it "can list" do
    expect(subject.list_url()).to eq("/image/")
  end

  it "can add" do
    expect(subject.add_url()).to eq("/image/")
  end

  it "can get" do
    expect(subject.get_url("TEST")).to eq("/image/TEST/")
  end

  it "can update" do
    expect(subject.update_url("TEST")).to eq("/image/TEST/")
  end
  
  it "can delete" do
    expect(subject.delete_url("TEST")).to eq("/image/TEST/")
  end
end
