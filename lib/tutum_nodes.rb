class TutumNodes < TutumApi
  def list_url
    "/node/"
  end

  def list
    http_get(list_url)
  end

  def get_url(uuid)
    "/node/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end

  def deploy_url(uuid)
    "/node/#{uuid}/deploy/"
  end

  def deploy(uuid)
    http_post(deploy_url(uuid))
  end

  def terminate_url(uuid)
    "/node/#{uuid}/"
  end

  def terminate(uuid)
    http_delete(terminate_url(uuid))
  end
end
