require_relative './tutum_containers'

class Tutum
  def containers
    @containers ||= TutumContainers.new
  end
end
