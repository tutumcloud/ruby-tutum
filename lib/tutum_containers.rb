class TutumContainers < TutumApi
  def list_url
    "/container/"
  end

  def list(params)
    get(list_url, params)
  end

  def create_url
    "/container/"
  end

  def create(params)
    post(create_url, params)
  end

  def get_url(uuid)
    "/container/#{uuid}/"
  end

  def get(uuid)
    get(get_url(uuid))
  end

  def start_url(uuid)
    "/container/#{uuid}/start/"
  end

  def start(uuid)
    post(start_url(uuid))
  end

  def stop_url(uuid)
    "/container/#{uuid}/stop/"
  end

  def stop(uuid)
    post(stop_url(uuid))
  end

  def logs_url(uuid)
    "/container/#{uuid}/logs/"
  end

  def logs(uuid)
    get(logs_url(uuid))
  end

  def redeploy_url(uuid)
    "/container/#{uuid}/redeploy/"
  end
  
  def redeploy(uuid, params)
    post(redeploy_url(uuid), params)
  end

  def delete_url(uuid)
    "/container/#{uuid}/"
  end

  def delete(uuid)
    delete(delete_url(uuid))
  end
end
