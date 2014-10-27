class TutumRegions < TutumApi
  def list_url
    "/region/"
  end

  def list(params)
    http_get(list_url, params)
  end

  def get_url(uuid)
    "/region/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end

end
