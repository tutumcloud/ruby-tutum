class TutumImages < TutumApi
  def list_url
    "/image/"
  end

  def list
    http_get(list_url)
  end

  def add_url
    "/image/"
  end

  def add(name, params)
    http_post(add_url, params.merge({:name => name}))
  end

  def get_url(name)
    "/image/#{name}/"
  end

  def get(name)
    http_get(get_url(name))
  end

  def update_url(name)
    "/image/#{name}/"
  end
  
  def update(name, params)
    http_patch(update_url(name), params)
  end

  def delete_url(name)
    "/image/#{name}/"
  end

  def delete(name)
    http_delete(delete_url(name))
  end


end
