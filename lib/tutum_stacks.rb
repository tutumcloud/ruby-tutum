class TutumStacks < TutumApi
  def list_url
    "/stack/"
  end

  def list(params={})
    http_get(list_url, params)
  end

  def get_url(uuid)
    "/stack/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end

  def create_url
    "/stack/"
  end

  def create(params)
    http_post(create_url, params)
  end

  def export_url(uuid)
    "/stack/#{uuid}/export/"
  end

  def export(uuid)
    http_get(export_url(uuid))
  end

  def update_url(uuid)
    "/stack/#{uuid}/"
  end

  def update(uuid, params)
    http_patch(update_url(uuid), params)
  end

  def stop_url(uuid)
    "/stack/#{uuid}/stop/"
  end

  def stop(uuid)
    http_post(stop_url(uuid))
  end

  def start_url(uuid)
    "/stack/#{uuid}/start/"
  end

  def start(uuid)
    http_post(start_url(uuid))
  end

  def redeploy_url(uuid)
    "/stack/#{uuid}/redeploy/"
  end

  def redeploy(uuid)
    http_post(redeploy_url(uuid))
  end

  def terminate_url(uuid)
    "/stack/#{uuid}/"
  end

  def terminate(uuid)
    http_delete(terminate_url(uuid))
  end
end
