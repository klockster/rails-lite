require 'uri'

class Params
  def initialize(req, route_params)
    @params = {}
    @params = parse_www_encoded_form(route_params) if !!(route_params)
    @params = parse_www_encoded_form(req.body) if !!req.body
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    arr = URI.decode_www_form(www_encoded_form)
    arr.each do |sub_arr|
      keys_arr = parse_key(sub_arr.first)
      h = parse_arr_to_hash(keys_arr << sub_arr.last)
      k = h.keys.first
      v = h.values.first
      if @params[k].nil?
        @params[k] = v
      else
        @params[k] = @params[k].merge(v)
      end

      # a = [k]
#       until @params[k].nil?
#         k = v.keys.first
#         v = v[k]
#         a << k
#       end
#       if a.length > 1
#         build_str = "@params"
#         a.each do |key|
#           build_str << "[#{key}]"
#         end
#
#         instance_variable_set(build_str, v)
#         #@params[a.first][a[1]] = v
#       else
#         @params[k] = v
#       end

    end

    @params
  end

  def parse_arr_to_hash(arr)
    a = arr
    ret_hash = {}
    key = a.shift
    if a.length == 1
      ret_hash[key] = a.last
      return ret_hash
    end
    ret_hash[key] = parse_arr_to_hash(a)

    ret_hash
  end

  def parse_key(key)
    keys_arr = key.split(/\]\[|\[|\]/)
  end
end
