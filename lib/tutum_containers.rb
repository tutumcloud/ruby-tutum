class TutumContainers < TutumApi
  def list_url
  end

  def list
    get(list_url, list_params)
  end

end
