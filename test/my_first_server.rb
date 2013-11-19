root = "/"
server = WEBrick::HTTPServer.new :Port => 8080, :DocumentRoot => root
trap('INT') { server.shutdown }

server.mount_proc root do |req, res|
  res.body = req.path
  res.content_type = "text/text"
end