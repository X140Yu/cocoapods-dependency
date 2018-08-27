require 'cocoapods/dependency/version'
require 'cocoapods'
require 'pathname'
require 'pp'

module Cocoapods
  #
  # Analyze the project using cocoapods
  #
  class DependencyAnalyzer
    def self.analyze(podfile_dir_path)
      Dir.chdir(podfile_dir_path) do
        analyze_with_podfile(
          podfile_dir_path,
          Pod::Podfile.from_file(podfile_dir_path + 'Podfile'),
          Pod::Lockfile.from_file(Pathname.new(podfile_dir_path + 'Podfile.lock'))
        )
      end
    end

    def self.analyze_with_podfile(podfile_dir_path, podfile, lockfile = nil)
      analyzer = Pod::Installer::Analyzer.new(
        Pod::Sandbox.new(Dir.mktmpdir),
        podfile,
        lockfile
      )

      specifications = analyzer.analyze.specifications.map(&:root).uniq

      map = {}
      specifications.each do |s|
        map[s.name] = if s.default_subspecs.count > 0
                        subspecs_with_name(s, s.default_subspecs) + s.dependencies
                      else
                        s.subspecs + s.dependencies
                      end
        s.subspecs.each do |ss|
          map[ss.name] = ss.dependencies
        end
      end

      new_map = {}
      specifications.each do |s|
        new_map[s.name] = find_dependencies(s.name, map, [], specifications).uniq
      end

      new_map
    end

    def self.find_dependencies(name, map, res, specs)
      return unless map[name]
      map[name].each do |k|
        find_dependencies(k.name, map, res, specs)
        res.push k.name if specs.find { |s| s.name == k.name }
      end
      res
    end

    def self.subspecs_with_name(spec, subspecs_short_names)
      subspecs_short_names.map do |name|
        spec.subspecs.find { |ss| ss.name.include? name }
      end
    end
  end
end
