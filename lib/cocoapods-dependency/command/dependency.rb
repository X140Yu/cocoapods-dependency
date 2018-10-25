require 'cocoapods-dependency/analyze'
require 'pp'
require 'cocoapods-dependency/visual_out'

module Pod
  class Command

    class Dependency < Command
      self.summary = 'Analyzes the dependencies of any cocoapods projects.'

      self.description = <<-DESC
      Analyzes the dependencies of any cocoapods projects. Subspecs are properly handled.
      DESC

      def initialize(argv)
        @using_visual_output = argv.flag?('visual', false)
        super
      end

      def self.options
        [
          ['--visual', 'Output the result using html'],
        ].concat(super)
      end

      def validate!
        super
        verify_podfile_exists!
      end

      def run
        analyze_result = CocoapodsDependency::Analyzer.analyze_with_podfile(nil, config.podfile)
        if @using_visual_output
          
        else
          pp result
        end
      end
    end
  end
end
