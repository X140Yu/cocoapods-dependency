require 'json'
require 'yaml'
require 'cocoapods'
module CocoapodsDependency
  class VisualOutHelper
    def initialize(dependency_map)
      @dependency_map = dependency_map
    end

    def to_d3js_json
      json = {}
      links = []
      @dependency_map.each do |node, v|
        v.each do |dependency|
          links.push(
            {
              'source': node,
              'dest': dependency,
            }
          )
        end
      end

      json['links'] = links

      JSON.pretty_generate(json)
    end

    def write_json_to_file(path)
      links = []
      json = {}
      @dependency_map.each do |node, v|
        links.push(
          {
            'source': node,
            'dependencies': v,
          }
        )
      end
      json['links'] = links
      json_result = JSON.pretty_generate(json)
      File.write(path, json_result)
    end

    def write_d3js_to_file(path)
      json = 'var dependencies = ' + to_d3js_json
      File.write(path, json)
    end
  end
end
