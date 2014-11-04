class TutumRegions < TutumApi
  def list_url
    "/region/"
  end

  def list
    http_get(list_url)
  end

  def get_url(uuid)
    "/region/#{uuid}/"
  end

  def get(uuid)
    http_get(get_url(uuid))
  end
end
