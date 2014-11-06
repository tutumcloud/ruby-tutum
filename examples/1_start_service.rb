require_relative "../lib/tutum"

if(ENV["TUTUM_USER"].nil?)
  raise "Set your TUTUM_USER and TUTUM_APIKEY environment variables to run this example."
end

tutum = Tutum.new(ENV["TUTUM_USER"], ENV["TUTUM_APIKEY"])

# Create the containers

service = tutum.services.create({
    :image => "tutum/wordpress", 
    :name => "wordpress-test"
})

# Launch the container
uuid = service['uuid']

start = tutum.services.start(uuid)

# Check until status == running
state = nil
while(state != "Running") do
  sleep 5
  puts "Checking container state"
  get_response = tutum.services.get(uuid)
  state = get_response["state"]

  puts state
end

# Destroy the container
puts "Ran successfully, terminating"
tutum.services.terminate(uuid)
