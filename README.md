[![Build Status](https://travis-ci.org/tutumcloud/ruby-tutum.svg)](https://travis-ci.org/tutumcloud/ruby-tutum)
[![Gem Version](https://badge.fury.io/rb/tutum.svg)](http://badge.fury.io/rb/tutum)

## Introduction

This library implements [Tutum's API](https://docs.tutum.co/v2/api/). Tutum is a docker host PaaS.  See the tutum documentation for a full list of parameters for each method call.

##Installation

```
$ gem install tutum
```

## Authentication

To make requests, you must secure your username and [API key](https://dashboard.tutum.co/account/).

```ruby
  require 'tutum'
  session = Tutum.new(username: username, api_key: api_key)
```

or by using [API Roles](https://support.tutum.co/support/solutions/articles/5000524639).

```ruby
  require 'tutum'
  session = Tutum.new(tutum_auth: tutum_auth)
```

you can specify extra json options, such as such switching on `:symbolize_name` for all response hashes.

```ruby
  session = Tutum.new(username: username, api_key: api_key, json_opts: {:symbolize_names => true}
```

## Containers

### Create a new container

```ruby
  tutum.containers.create({
    :image_name => "tutum/hello-world", 
    :name => "my-awesome-app", 
    :container_size => "XS", 
    :web_public_dns => "awesome-app.example.com"
  })
```

### List all containers

```ruby
  tutum.containers.list({})
```

### Get container details

```ruby
  container_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"
  tutum.containers.get(container_uuid)
```

### Start a container

```ruby
  container_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"
  tutum.containers.start(container_uuid)
```

### Stop a container

```ruby
  container_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"
  tutum.containers.stop(container_uuid)
```

### Get the logs of a container

```ruby
  container_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"
  tutum.containers.logs(container_uuid)
```

### Redeploy a container

```ruby
  container_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"
  tutum.containers.redeploy(container_uuid, {})
```

### Terminate a container

```ruby
  container_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"
  tutum.containers.delete(container_uuid)
```

## Actions

### List all actions

```
  tutum.actions.list({})
```

### Get an action by UUID

```
  action = tutum.actions.get(ACTION_UUID)
```


## Providers

### List all providers

```
  tutum.providers.list({})
```

### Get a provider

```
  tutum.providers.get(PROVIDER_NAME)
```

## Regions

### List all regions

```
  tutum.regions.list({})
```

### Get an individual region

```
  tutum.regions.get(REGION_NAME)
```

## Availability Zones

TODO: Not implemented on tutum yet

## Node Types

### List all node types

```
  tutum.node_types.list({})
```

### Get an individual node type
```
  node_type = tutum.node_types.get("digitalocean/1gb")
```

## Node Clusters

### List all node clusters

```
  node_clusters = tutum.node_clusters.list({})
```

### Create a node cluster

```
  region = tutum.regions.get("digitalocean/lon1")
  node_type = tutum.node_types.get("digitalocean/1gb")
  number_of_nodes = 1
  node_cluster = tutum.node_cluster.create( "my_cluster", node_type, region, number_of_nodes)
```

### Get a node cluster

```
  service = tutum.node_clusters.get(NODE_CLUSTER_UUID)
```

### Deploy a node cluster

```
  tutum.node_clusters.deploy(NODE_CLUSTER_UUID)
```

### Update an existing node cluster
```
  tutum.node_clusters.update(NODE_CLUSTER_UUID, :target_num_nodes => 3)
```

### Terminate a node cluster
```
  tutum.node_clusters.delete!(NODE_CLUSTER_UUID)
```

## Nodes

### List all nodes

```
tutum.nodes.list({})
```

### Get an existing node

```
tutum.nodes.get(NODE_UUID)
```

### Deploy a node

```
tutum.nodes.deploy(NODE_UUID)
```

### Terminate a node

```
tutum.nodes.terminate(NODE_UUID)
```

## Services

### List all services
```
tutum.services.list({})
```

### Create a new service

```
service = tutum.services.create(:image => "tutum.co/tutum/hello-world", :name => "my-new-app", :target_num_containers => 1)
```

### Get an existing service

```
service_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

service = tutum.services.get(service_uuid)
```

### Get the logs of a service

```
service_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.services.logs(service_uuid)
```

### Update an existing service

```
service_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.services.update(service_uuid, :target_num_containers => 3)
```

### Start a service

```
service_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.services.start(service_uuid)
```

### Stop a service
```
service_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.services.stop(service_uuid)
```


### Redeploy a service
```
service_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.services.redeploy(service_uuid)
```

### Terminate a service
```
service_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.services.terminate(service_uuid)
```

## Stacks

### List all stacks
```
tutum.stacks.list({})
```

### Create a new stack

```
stack = tutum.stacks.create(name: "my-new-stack",
  services: [
    {
      name: "hello-word",
      image: "tutum/hello-world",
      target_num_containers: 2,
      linked_to_service: [
        {
          to_service: "database",
          name: "DB"
        }
      ]
    },
    {
      name: "database",
      image: "tutum/mysql"
    }
  ]
})
```

### Get an existing stack

```
stack_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

stack = tutum.stacks.get(stack_uuid)
```

### Export an existing stack

```
stack_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.stacks.export(stack_uuid)
```

### Update an existing stack

```
stack_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.stacks.update(stack_uuid, services: [
    {
      name: "hello-word",
      image: "tutum/hello-world",
      target_num_containers: 2,
      linked_to_service: [
        {
          to_service: "database",
          name: "DB"
        }
      ]
    },
    {
      name: "database",
      image: "tutum/mysql"
    }
  ]
})
```

### Start a stack

```
stack_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.stacks.start(stack_uuid)
```

### Stop a stack
```
stack_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.stacks.stop(stack_uuid)
```

### Redeploy a stack
```
stack_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.stacks.redeploy(stack_uuid)
```

### Terminate a stack
```
stack_uuid = "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce"

tutum.stacks.terminate(stack_uuid)
```

##Testing

To test locally, you must set two environmental variables.

```
$ export TUTUM_USERNAME=<your_username>
$ export TUTUM_API_KEY=<your_api_key>
```

Then, bundle and run the tests.

```
$ bundle
$ rake
```

### About

The ruby tutum API is provided by 255 BITS LLC.  Please star it if you like it.

### License

MIT

### Changelog

v0.2.7 Stacks api and api role support
v0.2.6 Bug fixes
v0.2.0 Support for tutum 2.0 + new example
v0.1.1 Fix runtime dependency
v0.1.0 Initial release
