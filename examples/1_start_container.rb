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

tutum.containers.start(uuid)

# Check until status == running
state = nil
while(state != "Running") do
  sleep 5
  puts "Checking container state"
  state = tutum.containers.get(uuid)["state"]
  puts state
end

# Destroy the container
tutum.containers.delete(uuid)
