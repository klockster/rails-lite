require 'json'
require 'webrick'

class Session
  def initialize(req)
    main_cookie = req.cookies.select{|c| c.name == '_rails_lite_app'}
    if main_cookie.empty?
      @cookie = {}
    else
      @cookie = JSON.parse(main_cookie.first.value)
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cookie.to_json)
  end
end

class Flash < Session
  def initialize(req)
    @cookie = {}
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_flash', @cookie.to_json)
  end

end
