class TutumActions < TutumApi
  def list_url
    "/action/"
  end

  def list(params)
    http_get(list_url, params)
  end

  def get_url(uuid)
    "/action/#{stripped_id(uuid)}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end
end
