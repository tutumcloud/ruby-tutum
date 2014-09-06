class TutumImages < TutumApi
  def list_url
    "/image/"
  end

  def list(params)
    get(list_url, params)
  end

  def add_url
    "/image/"
  end

  def add(name, params)
    post(add_url, params.merge({:name => name}))
  end

  def get_url(name)
    "/image/#{name}/"
  end

  def get(name)
    get(get_url(name))
  end

  def update_url(name)
    "/image/#{name}/"
  end
  
  def update(name, params)
    patch(update_url(name), params)
  end

  def delete_url(name)
    "/image/#{name}/"
  end

  def delete(name)
    delete(delete_url(name))
  end


end
