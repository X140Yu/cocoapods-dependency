require 'cocoapods-dependency/analyze'
require 'pp'
require 'cocoapods-dependency/visual_out'
require 'tmpdir'
require 'json'
require 'erb'

module Pod
  class Command

    class Dependency < Command
      self.summary = 'Analyzes the dependencies of any cocoapods projects.'

      self.description = <<-DESC
      Analyzes the dependencies of any cocoapods projects. Subspecs are properly handled.
      DESC

      def initialize(argv)
        @using_visual_output = argv.flag?('visual', false)
        @to_output_json = argv.flag?('json', false)
        super
      end

      def self.options
        [
          ['--visual', 'Output the result using html'],
          ['--json', 'Output in JSON format']
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
          path = final_path
          render_template(JSON.generate(helper.dependency_hash), path)
          system "open #{path}"
        else
          if @to_output_json
            puts JSON.pretty_generate(analyze_result)
          else
            pp analyze_result
          end
        end
      end

      private

      def final_path
        d = File.join(Dir.tmpdir, 'pod')
        if not Dir.exist?(d)
          Dir.mkdir(d)
        end
        "#{Dir.tmpdir}/pod/index.html"
      end

      def render_template(result, final_path)
        File.open(final_path, 'w') do |f|
          f.puts(template_content(result))
        end
      end

      def template_content(result)
        f = File.open(template_path)
        template = ERB.new(f.read)
        f.close
        return template.result(binding)
      end

      def template_path
        File.expand_path("../resources/index.html.erb", __dir__)
      end

    end
  end
end
