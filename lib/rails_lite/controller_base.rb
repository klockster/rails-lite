require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params)
    @req = req
    @res = res
  end

  def session
  end

  def already_rendered?
  end

  def redirect_to(url)
    @res.status = 302
    status = @res.status
    @res.set_redirect(status,url)
    @already_built_response = true
  end

  def render_content(content, type)
    @res.content_type = type
    @res.body = content
    @already_built_response = true
  end

  def render(template_name)
  end

  def invoke_action(name)
  end
end
