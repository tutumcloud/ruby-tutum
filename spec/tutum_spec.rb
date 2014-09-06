require_relative './spec_helper'

describe Tutum do
  it "has containers" do
    expect(subject.containers.class).to eq(TutumContainers)
  end
end
