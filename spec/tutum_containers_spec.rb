require_relative './spec_helper'

describe TutumContainers do
  it "calls list" do
    subject.list_url.should eq("/container/")
  end
end
