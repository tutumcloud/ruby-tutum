class TutumActions < TutumApi
  def list_url
    "/action/"
  end

  def list
    http_get(list_url)
  end

  def get_url(uuid)
    "/action/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end
end
