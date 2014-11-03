require_relative "../lib/tutum"

if(ENV["TUTUM_USER"].nil?)
  raise "Set your TUTUM_USER and TUTUM_APIKEY environment variables to run this example."
end

tutum = Tutum.new(ENV["TUTUM_USER"], ENV["TUTUM_APIKEY"])

node_types = tutum.node_types.list

puts "Available node types: "
objects = node_types.parsed_response["objects"]
objects.each do |type|
  if(type["available"])
    puts "#{type["resource_uri"]} - cpu #{type["cpu"]}, memory #{type["memory"]}}"
  else
    puts "#{type["resource_uri"]} not available"
  end
end

region = "/api/v1/region/aws/us-east-1/"
type = "/api/v1/nodetype/aws/m3.medium/"
name = "ruby-tutum-example-node-cluster"
puts "-----","Creating cluster '#{name}' with  #{region} and type #{type}", "------", "WARNING - this takes a while"

create_response = tutum.node_clusters.create({ name: name, node_type: type, region: region, target_num_nodes: 1})

uuid = create_response.parsed_response["uuid"]
deploy_response = tutum.node_clusters.deploy(uuid)

puts "Created node cluster #{uuid}"
started = false

while(!started) do
  node_cluster = tutum.node_clusters.get(uuid)
  state = node_cluster.parsed_response["state"]
  puts "Node cluster state #{state}"
  sleep 5
  started = (state == "Deployed")
end

tutum.node_clusters.terminate(uuid)
puts "Node cluster #{uuid} terminated."

