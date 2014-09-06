class TutumContainers < TutumApi
  def list_url
    "/container/"
  end

  def list(params)
    http_get(list_url, params)
  end

  def create_url
    "/container/"
  end

  def create(params)
    http_post(create_url, params)
  end

  def get_url(uuid)
    "/container/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end

  def start_url(uuid)
    "/container/#{uuid}/start/"
  end

  def start(uuid)
    http_post(start_url(uuid))
  end

  def stop_url(uuid)
    "/container/#{uuid}/stop/"
  end

  def stop(uuid)
    http_post(stop_url(uuid))
  end

  def logs_url(uuid)
    "/container/#{uuid}/logs/"
  end

  def logs(uuid)
    http_get(logs_url(uuid))
  end

  def redeploy_url(uuid)
    "/container/#{uuid}/redeploy/"
  end
  
  def redeploy(uuid, params)
    http_post(redeploy_url(uuid), params)
  end

  def delete_url(uuid)
    "/container/#{uuid}/"
  end

  def delete(uuid)
    http_delete(delete_url(uuid))
  end
end
