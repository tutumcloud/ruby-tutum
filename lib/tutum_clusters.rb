class TutumClusters < TutumApi
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

  def start_url(uuid)
    "/application/#{uuid}/start/"
  end

  def start(uuid)
    http_post(start_url(uuid))
  end

  def stop_url(uuid)
    "/application/#{uuid}/stop/"
  end

  def stop(uuid)
    http_post(stop_url(uuid))
  end

  def update_url(uuid)
    "/application/#{uuid}/"
  end
  
  def update(uuid, params)
    http_patch(update_url(uuid), params)
  end

  def redeploy_url(uuid)
    "/application/#{uuid}/redeploy/"
  end
  
  def redeploy(uuid, params)
    http_post(redeploy_url(uuid), params)
  end

  def delete_url(uuid)
    "/application/#{uuid}/"
  end

  def delete(uuid)
    http_delete(delete_url(uuid))
  end

end
