class TutumNodeClusters < TutumApi
  def list_url
    "/application/"
  end

  def list(params)
    http_get(list_url, params)
  end

  def create_url
    "/application/"
  end

  def create(params)
    http_post(create_url, params)
  end

  def get_url(uuid)
    "/application/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end

  def update_url(uuid)
    "/application/#{uuid}/"
  end
  
  def update(uuid, params)
    http_patch(update_url(uuid), params)
  end

  def deploy_url(uuid)
    "/application/#{uuid}/deploy/"
  end
  
  def deploy(uuid, params)
    http_post(deploy_url(uuid), params)
  end

  def terminate_url(uuid)
    "/application/#{uuid}/"
  end

  def terminate(uuid)
    http_delete(terminate_url(uuid))
  end

end
