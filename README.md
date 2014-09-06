## Introduction

Ruby API for the [https://docs.tutum.co/reference/api/](tutum) HTTP API.  Tutum is a docker host PaaS.  See the tutum documentation for a full list of parameters for each method call.

## Authentication

```ruby
  require 'tutum'
  tutum = Tutum.new(TUTUM_USERNAME, API_KEY)
```

## Containers

### Create a new container

```ruby
  tutum.containers.create({
    :image => "tutum/hello-world", 
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
  tutum.containers.get(CONTAINER_UUID)
```

### Start a container

```ruby
  tutum.containers.start(CONTAINER_UUID)
```

### Stop a container

```ruby
  tutum.containers.stop(CONTAINER_UUID)
```

### Get logs for a container

```ruby
  tutum.containers.logs(CONTAINER_UUID)
```

### Redeploy a container

```ruby
  tutum.containers.redeploy(CONTAINER_UUID, {})
```

### Terminate a container

```ruby
  tutum.containers.delete(CONTAINER_UUID)
```

## Clusters

### List all clusters

```ruby
  tutum.clusters.list({})
```

### Get cluster details

```ruby
  tutum.clusters.get(CLUSTER_UUID)
```
### Create a new cluster

```ruby
  tutum.clusters.create(
    {
        "image": "tutum/hello-world",
        "name": "my-awesome-app",
        "target_num_containers": 2,
        "container_size": "XS",
        "web_public_dns": "awesome-app.example.com"
    }
  )
```
### Update a cluster

```ruby
  tutum.clusters.update(CLUSTER_UUID, :target_num_containers => 3)
```
### Start a cluster

```ruby
  tutum.clusters.start(CLUSTER_UUID)
```
### Stop a cluster

```ruby
  tutum.clusters.stop(CLUSTER_UUID)
```
### Redeploy a cluster

```ruby
  tutum.clusters.redeploy(CLUSTER_UUID, {})
```
### Terminate a cluster

```ruby
  tutum.clusters.terminate(CLUSTER_UUID)
```

## Images

### List all images

```ruby
  tutum.images.list({})
```

### Get image details

```ruby
  tutum.images.get("tutum/lamp")
```

### Add a new private image

```ruby
  tutum.images.add(
    "quay.io/user/my-private-image",
    {
        "username": "user+read",
        "password": "SHJW0SAOQ2BFBZVEVQH98SOL6V7UPQ0PH2VNKRVMMXR6T8Q43AHR88242FRPPTPG"
    }
  )
```

### Update a private image

```ruby
  tutum.images.update( 
    "quay.io/user/my-private-image", 
    {
        "description": "Awesome web application, containerized"
    }
  )
```

### Delete a private image

```ruby
  tutum.images.delete("quay.io/user/my-private-image")
```

### About

The ruby tutum API is provided by 255 BITS LLC.  Please star it if you like it.

### License

MIT

### Changelog

v0.1.0 Initial release
