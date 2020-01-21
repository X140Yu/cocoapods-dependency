require 'cocoapods'
require 'pathname'

module CocoapodsDependency
  #
  # Analyze the project using cocoapods
  #
  class Analyzer
    def self.analyze(podfile_dir_path)
      path = Pathname.new(podfile_dir_path)
      raise 'absolute path is needed' unless path.absolute?

      Dir.chdir(podfile_dir_path) do
        analyze_with_podfile(
          path,
          Pod::Podfile.from_file(path + 'Podfile'),
          Pod::Lockfile.from_file(path + 'Podfile.lock')
        )
      end
    end

    def self.podfile_dependencies(podfile)
      res = []
      podfile.root_target_definitions.each do |td|
        children_definitions = td.recursive_children
        children_definitions.each do |cd|
          dependencies_hash_array = cd.send(:get_hash_value, 'dependencies')
          next if dependencies_hash_array.nil? || dependencies_hash_array.count.zero?

          dependencies_hash_array.each do |item|
            next if item.class.name != 'Hash'

            item.each do |name, _|
              res.push name
            end
          end
        end
      end
      res
    end

    def self.analyze_with_podfile(_podfile_dir_path, podfile, lockfile = nil)
      if _podfile_dir_path
        sandbox = Dir.mktmpdir
      else
        sandbox = Dir.pwd + '/Pods'
      end
      analyzer = Pod::Installer::Analyzer.new(
        Pod::Sandbox.new(sandbox),
        podfile,
        lockfile
      )

      specifications = analyzer.analyze.specifications.map(&:root).uniq

      podfile_dependencies = podfile_dependencies(podfile)

      map = {}
      specifications.each do |s|
        map[s.name] = if s.default_subspecs.count > 0
                        subspecs_with_name(s, s.default_subspecs) + s.dependencies
                      else
                        s.subspecs + s.dependencies
                      end
        subspecs_in_podfile = podfile_dependencies.select { |pd| pd.split('/')[0] == s.name }
        sp = subspecs_in_podfile.map { |sip| s.subspecs.find { |ss| ss.name == sip } }.compact
        map[s.name] = sp if sp.count != 0
        s.subspecs.each do |ss|
          map[ss.name] = ss.dependencies
        end
      end

      # for performance
      dependencies_map = {}
      specifications.each do |s|
        dependencies_map[s.name] = s
      end

      new_map = {}
      specifications.each do |s|
        new_map[s.name] = find_dependencies(s.name, map, [], dependencies_map, s.name).uniq.sort
      end

      new_map
    end

    def self.find_dependencies(name, map, res, dependencies_map, root_name)
      return unless map[name]

      map[name].each do |k|
        find_dependencies(k.name, map, res, dependencies_map, root_name)
        dependency = dependencies_map[k.name.split('/')[0]]
        res.push dependency.name if dependency && dependency.name != root_name
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
