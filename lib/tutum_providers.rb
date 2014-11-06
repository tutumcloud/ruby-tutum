class TutumProviders < TutumApi
  def list_url
    "/provider/"
  end

  def list(params)
    http_get(list_url, params)
  end

  def get_url(uuid)
    "/provider/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end
end
