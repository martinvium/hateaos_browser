class RestClient
  attr_accessor :default_headers

  def initialize
    self.default_headers = {}
  end

  def get(url, headers={})
    execute(:get, url, headers)
  end

  def post(url, body, headers={})
    execute(:post, url, headers, body)
  end

  def execute(method, url, headers={}, body=nil)
    uri = URI(url)
    
    request = net_http_request_class(method).new(url)

    default_headers.merge(headers).each do|k,v| 
      request[k.to_s] = v.to_s
    end

    if body.is_a? Hash
      request.set_form_data(body)
    else
      request.body = body
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.request(request)
  end

  def net_http_request_class(method)
    Net::HTTP.const_get(method.to_s.capitalize)
  end
end