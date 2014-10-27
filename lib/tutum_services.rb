class TutumServices < TutumApi
  def list_url
    "/service/"
  end

  def list(params)
    http_get(list_url, params)
  end

  def create_url
    "/service/"
  end

  def create(params)
    http_post(create_url, params)
  end

  def get_url(uuid)
    "/service/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end

  def logs_url(uuid)
    "/service/#{uuid}/"
  end

  def logs(uuid)
    http_get(get_url(uuid))
  end

  def update_url(uuid)
    "/service/#{uuid}/"
  end
  
  def update(uuid, params)
    http_patch(update_url(uuid), params)
  end

  def start_url(uuid)
    "/service/#{uuid}/start/"
  end
  
  def start(uuid, params)
    http_post(start_url(uuid), params)
  end

  def stop_url(uuid)
    "/service/#{uuid}/stop/"
  end
  
  def stop(uuid, params)
    http_post(stop_url(uuid), params)
  end

 
  def redeploy_url(uuid)
    "/service/#{uuid}/redeploy/"
  end
  
  def redeploy(uuid, params)
    http_post(redeploy_url(uuid), params)
  end

  def terminate_url(uuid)
    "/service/#{uuid}/"
  end

  def terminate(uuid)
    http_delete(terminate_url(uuid))
  end

end
