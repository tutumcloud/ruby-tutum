class TutumProviders < TutumApi
  def list_url
    "/provider/"
  end

  def list
    http_get(list_url)
  end

  def get_url(uuid)
    "/provider/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end
end
