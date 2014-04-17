require 'json'

class Resource
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :data

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def self.from_response(response)
    data = JSON.load(response.body)
    Resource.new(data: data)
  end

  def self.link?(v)
    v.to_s.start_with? "http"
  end

  def children
    @children ||= data.map {|r| Resource.new(data: r) }
  end

  def collection?
    data.is_a? Array
  end

  def self.humanize_collection(collection)
    if collection.is_a?(Hash)
      if collection.keys.include?("name")
        return collection["name"]
      elsif collection.keys.include?("id")
        return collection["id"]
      end
    end

    "Collection"
  end

  def persisted?
    false
  end
end