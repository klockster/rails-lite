require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params={})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  # def flash[]=(key,value)
#     @flash ||= Flash.new(@req)
#   end

  def already_rendered?
    !!@already_built_response
  end

  def redirect_to(url)
    @res.status = 302
    @res["Host"]=(url)
    @res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect,url)
    @already_built_response = true
    session.store_session(@res)
    flash.store_session(@res)
  end

  def render_content(content, type)
    @res.content_type = type
    @res.body = content
    @already_built_response = true
    session.store_session(@res)
    flash.store_session(@res)
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    file_name = "views/#{controller_name}/#{template_name}.html.erb"
    instance_vars = self.instance_variables
    form_authenticity_token = SecureRandom.urlsafe_base64(16)
    binding
    file = File.open(file_name, "r")
    template = ERB.new(file.read)
    file.close
    content = template.result(binding)
    type = "text/html"

    render_content(content, type)
  end

  def invoke_action(name)
    self.send(name)
    unless @already_built_response
      render(name)
    end
  end
end
