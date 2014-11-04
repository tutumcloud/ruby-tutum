require_relative './spec_helper'

test_username = ENV['TUTUM_USERNAME']
test_api_key = ENV['TUTUM_API_KEY']

describe Tutum do
  subject do
    Tutum.new(test_username, test_api_key)
  end

  it "has a username and apikey" do
    expect(subject.username).to eq(test_username )
    expect(subject.api_key).to eq(test_api_key )
  end

  it "compiles headers" do
    expect(subject.headers["Authorization"].length).to be > 1
    expect(subject.headers["Accept"]).to eq("application/json")
  end
end
