require 'yaml'
require 'json'
require 'rest_client'

class Project
  @@projects = {}
  attr_accessor :id, :name, :root_url, :basic, :oauth2, :errors, :oauth2_access_token, :url_placeholder_pattern

  def initialize(filename, args={})
    self.id = filename[0..-5].to_sym
    self.name = args['name'] || id
    self.root_url = args['root_url']
    self.basic = args['basic'] || {}
    self.oauth2 = args['oauth2'] || {}
    self.url_placeholder_pattern = args['url_placeholder_pattern']
    self.errors = []
  end

  def self.all
    return @@projects unless @@projects.empty?
    
    Dir["#{Rails.root}/config/projects/*.yml"].each do|file|
      data = YAML.load_file(file)
      filename = File.basename(file)
      project = Project.new(filename, data)
      @@projects[project.id] = project
    end

    @@projects
  end

  def self.find(id)
    all[id.to_sym]
  end

  def url_placeholders?(url)
    Regexp.new(url_placeholder_pattern).match(url).present?
  end

  def get(url)
    response = authenticated_client.get(url)

    case response
    when Net::HTTPSuccess
      Resource.from_response(self, response)
    else
      raise "resource get failed: #{response.code} #{response.message}"
    end
  end

  def client_id
    Rails.application.secrets.send("#{id}_client_id")
  end

  def client_secret
    Rails.application.secrets.send("#{id}_client_secret")
  end

  def authorize_url
    redirect_url = Rails.application.routes.url_helpers.auth_callback_url(self, host: 'localhost:3000')
    url =  url.parse(oauth2['authorize_url'])
    query_params = url.decode_www_form(url.query.to_s)
    query_params << ["client_id", client_id]
    query_params << ["redirect_url", redirect_url]
    query_params << ["scope", oauth2['scope']]
    url.query = url.encode_www_form(query_params)
    url.to_s
  end

  def get_access_token(code)
    headers = { accept: 'application/json' }
    params = {
      client_id: client_id,
      client_secret: client_secret,
      code: code
    }

    response = client.post(oauth2['token_url'], params, headers)

    case response
    when Net::HTTPSuccess
      data = JSON.parse(response.body)
      data['access_token']
    else
      raise "failed to get access token, code probably expired"
    end
  end

  def client
    @client ||= RestClient.new
  end

  def authenticated_client
    @authenticated_client ||= RestClient.new

    if basic.present?
      # args[:user] = basic['username']
      # args[:password] = basic['password']
    end

    if oauth2_access_token.present?
      @authenticated_client.default_headers['Authorization'] = "token #{oauth2_access_token}"
    end

    @authenticated_client
  end

  def to_param
    id
  end
end
