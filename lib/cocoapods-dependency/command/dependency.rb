require 'cocoapods-dependency/analyze'
require 'pp'
module Pod
  class Command

    class Dependency < Command
      self.summary = 'Analyzes the dependencies of any cocoapods projects.'

      self.description = <<-DESC
      Analyzes the dependencies of any cocoapods projects. Subspecs are properly handled.
      DESC

      # self.arguments = 'NAME'

      def initialize(argv)
        @name = argv.shift_argument
        super
      end

      def validate!
        super
        verify_podfile_exists!
      end

      def run
        pp CocoapodsDependency::Analyzer.analyze_with_podfile(nil, config.podfile)
      end
    end
  end
end
