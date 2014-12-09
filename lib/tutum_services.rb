class TutumServices < TutumApi
  def list_url
    "/service/"
  end

  def list(params={})
    http_get(list_url, params)
  end

  def create_url
    "/service/"
  end

  def create(params)
    http_post(create_url, params)
  end

  def get_url(uuid)
    "/service/#{stripped_id(uuid)}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end

  def logs_url(uuid)
    "/service/#{stripped_id(uuid)}/"
  end

  def logs(uuid)
    http_get(get_url(uuid))
  end

  def update_url(uuid)
    "/service/#{stripped_id(uuid)}/"
  end

  def update(uuid, params)
    http_patch(update_url(uuid), params)
  end

  def start_url(uuid)
    "/service/#{stripped_id(uuid)}/start/"
  end

  def start(uuid)
    http_post(start_url(uuid))
  end

  def stop_url(uuid)
    "/service/#{stripped_id(uuid)}/stop/"
  end

  def stop(uuid)
    http_post(stop_url(uuid))
  end

  def redeploy_url(uuid)
    "/service/#{stripped_id(uuid)}/redeploy/"
  end

  def redeploy(uuid)
    http_post(redeploy_url(uuid))
  end

  def terminate_url(uuid)
    "/service/#{stripped_id(uuid)}/"
  end

  def terminate(uuid)
    http_delete(terminate_url(uuid))
  end
end
