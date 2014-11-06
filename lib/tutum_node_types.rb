class TutumNodeTypes < TutumApi
  def list_url
    "/nodetype/"
  end

  def list(params={})
    http_get(list_url, params)
  end

  def get_url(uuid)
    "/nodetype/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end
end
