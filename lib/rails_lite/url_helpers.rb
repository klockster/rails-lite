module UrlHelper

  def link_to(title, ulr)
    "<a href=#{url}>#{title}</a>"#.html_safe
  end

  def button_to(title, url, options = {method: :post})
    a = <<-HTML
    <form action=#{url} method="POST">
      <input type="hidden" name="_method" value="#{options[method]}">
      <input type="hidden" name="authenticity_token" value="form_authenticity_token">
      <input type="submit" value="#{title}">
    </form>
    HTML

    a#.html_safe
  end

  def method_missing(method_name, *args)
    raise NoMethodError unless (/_url$/).match(method_name)
    body = method_name.to_s.split("_url").join("")
    keys = body.split("_")

    build_url(keys, args.to_a)
  end

  def build_url(keys, args)
    url_string = ""
    if keys.include?("edit")
      url_string = "edit"
      keys.delete("edit")
    elsif keys.include?("new")
      url_string = "new"
      keys.delete("new")
    end

    keys.reverse.each do |key|
      if key.pluralize == key
        url_string = key.to_s << "/" << url_string
      else
        argument = args.pop unless url_string == "new"
        if argument.is_a?(Fixnum)
          url_string = key.pluralize << "/" << argument.to_s << "/" << url_string
        elsif url_string != "new"
          if argument.methods.include?(:id)
            id = argument.id
          else
            ivars = argument.instance_variables.select{|x| !!(/id/).match(x)}
            id = argument.send(ivars.first.to_s.delete("@").to_sym)
          end

          url_string = key.pluralize << "/" << id.to_s << "/" << url_string
        else
          url_string = key.pluralize << "/" << url_string
        end

      end
    end

    url_string
  end
end