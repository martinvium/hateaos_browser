require 'yaml'
require 'json'
require 'rest_client'

class Project
  @@projects = {}
  attr_accessor :id, :name, :url, :basic, :oauth2, :errors, :oauth2_access_token

  def initialize(filename, args={})
    self.id = filename[0..-5].to_sym
    self.name = args['name'] || id
    self.url = args['url']
    self.basic = args['basic'] || {}
    self.oauth2 = args['oauth2'] || {}
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

  def get(url)
    response = client.get(url)

    case response
    when Net::HTTPSuccess
      Resource.from_response(response)
    else
      raise "failed to get resource" # todo more info needed
    end
  end

  def authorize_url
    redirect_uri = Rails.application.routes.url_helpers.auth_callback_url(self, host: 'localhost:3000')
    uri =  URI.parse(oauth2['authorize_url'])
    query_params = URI.decode_www_form(uri.query.to_s)
    query_params << ["client_id", oauth2['client_id']]
    query_params << ["redirect_uri", redirect_uri]
    query_params << ["scope", oauth2['scope']]
    uri.query = URI.encode_www_form(query_params)
    uri.to_s
  end

  def get_access_token(code)
    response = client.post(oauth2['token_url'], {
      client_id: oauth2['client_id'],
      client_secret: oauth2['client_secret'],
      code: code,
      client_id: oauth2['client_id'],
    }, { accept: 'application/json' })

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

    if oauth2_access_token
      @authenticated_client.default_headers['authorization'] = "token #{oauth2_access_token}"
    end

    @authenticated_client
  end

  def to_param
    id
  end
end
