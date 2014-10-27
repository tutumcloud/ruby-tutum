class TutumNodeTypes < TutumApi
  def list_url
    "/node_type/"
  end

  def list(params)
    http_get(list_url, params)
  end

  def get_url(uuid)
    "/node_type/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end

end
