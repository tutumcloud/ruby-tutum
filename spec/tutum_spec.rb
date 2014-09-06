require_relative './spec_helper'

TEST_USERNAME="255 BITS LLC"
TEST_API_KEY="Is the greatest"

describe Tutum do
  subject do
    Tutum.new(TEST_USERNAME, TEST_API_KEY)
  end
  it "has containers" do
    expect(subject.containers.class).to eq(TutumContainers)
  end
  it "has images" do
    expect(subject.images.class).to eq(TutumImages)
  end
  it "has clusters" do
    expect(subject.clusters.class).to eq(TutumClusters)
  end
  it "has a username and apikey" do
    expect(subject.username).to eq(TEST_USERNAME)
    expect(subject.api_key).to eq(TEST_API_KEY)
  end

  it "compiles headers" do
    expect(subject.headers["Authorization"].length).to be >(1)
    expect(subject.headers["Accept"]).to eq("application/json")
  end
end
