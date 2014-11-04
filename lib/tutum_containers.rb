class TutumContainers < TutumApi
  def list_url
    "/container/"
  end

  def list
    http_get(list_url)
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

  def terminate_url(uuid)
    "/container/#{uuid}/"
  end

  def terminate(uuid)
    http_terminate(terminate_url(uuid))
  end
end
