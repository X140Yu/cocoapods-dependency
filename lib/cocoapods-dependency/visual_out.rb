require 'json'
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

      json.to_json
    end
  end
end