require_relative "../lib/tutum"


if(ENV["TUTUM_USER"].nil?)
  raise "Set your TUTUM_USER and TUTUM_APIKEY environment variables to run this example."
end

tutum = Tutum.new(ENV["TUTUM_USER"], ENV["TUTUM_APIKEY"])

# Create the containers

container = tutum.containers.create({
    :image => "tutum/wordpress", 
    :name => "wordpress-test", 
    :container_size => "XS", 
    :web_public_dns => "wordpress-test.255bits.com"
})

# Launch the container

uuid = container.parsed_response['uuid']

puts container.parsed_response.inspect
start = tutum.containers.start(uuid)
puts start.inspect

# Check until status == running
state = nil
while(state != "Running") do
  sleep 5
  puts "Checking container state"
  get_response = tutum.containers.get(uuid)
  state = get_response["state"]
  puts get_response.inspect

  puts state
end

# Destroy the container
tutum.containers.delete(uuid)
