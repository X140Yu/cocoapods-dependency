require 'cocoapods-dependency/analyze'
require 'pp'
require 'cocoapods-dependency/visual_out'
require 'tmpdir'

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
          helper = CocoapodsDependency::VisualOutHelper.new(analyze_result)
          final_path = Dir.tmpdir
          helper.write_json_to_file("#{final_path}/index.json")
          html_path = File.expand_path("../resources/index.html", __dir__)
          system "cp #{html_path} #{final_path}"
          final_html_path = "#{final_path}/index.html"
          puts "[CocoapodsDependency] ✅ html file generated at path #{final_html_path}"
          system "open #{final_html_path}"
        else
          pp analyze_result
        end
      end
    end
  end
end
