# frozen_string_literal: true
require 'erb'
require 'fileutils'
require 'yaml'

module Gemma
  #
  # Configurable gem skeleton from a template.
  #
  class GemFromTemplate
    #
    # Location of built-in templates.
    #
    TEMPLATE_ROOT = File.join(File.dirname(__FILE__), '..', '..', 'template')

    #
    # Built-in template names (not full paths). Order may be significant if
    # there are files that occur in multiple templates (files in earlier
    # templates are overwritten by those in later templates, at present).
    #
    BUILTIN_TEMPLATES = %w(base executable minitest)

    def initialize
      @gem_name = nil
      @module_name = nil
      @dir_name = nil
    end

    #
    # The gem name to be used in the gemspec; it also gives defaults for the
    # directory name and the gem's module name.
    #
    # @return [String]
    #
    attr_accessor :gem_name

    #
    # Gem name is consistent with naming conventions.
    #
    # @return [Boolean]
    #
    def good_gem_name?
      Conventions.good_gem_name? self.gem_name
    end

    #
    # Guess main module (or class) name from gem name (e.g. MyNewGem from
    # my_new_gem). The gem contents should be contained in this module / class.
    #
    # @return [String]
    #
    def module_name
      @module_name || Conventions.gem_name_to_module_name(self.gem_name)
    end

    #
    # Override default module name; set to nil to get back to default.
    #
    attr_writer :module_name

    #
    # Name of the root directory of the gem to be created.
    #
    # @return [String]
    #
    def dir_name
      @dir_name || @gem_name
    end

    #
    # Override default directory name; set to nil to get back to default.
    #
    attr_writer :dir_name

    #
    # Full path of root of the gem to be created. 
    #
    def destination_path
      File.expand_path(File.join('.',self.dir_name))
    end

    #
    # Copy given templates to +destination_path+ and run erb where needed.
    #
    # @param [Array<String>] template_paths absolute paths of the template
    #        directories to copy
    #
    def create_gem(template_paths, destination_path=self.destination_path)
      raise "destination #{destination_path} exists" if File.exists?(
        destination_path)

      # Copy templates in.
      FileUtils.mkdir_p destination_path
      for path in template_paths
        FileUtils.cp_r File.join(path,'.'), destination_path
      end

      Dir.chdir destination_path do
        dirs = Dir['**/*'].select { |f| File.directory? f }.sort
        dirs.grep(/gem_name/).each do |file|
          FileUtils.mv file, file.gsub(/gem_name/, gem_name)
        end

        files = (Dir['**/*'] + Dir['**/.*']).select { |f| File.file? f }.sort
        FileUtils.chmod 0644, files
        FileUtils.chmod 0755, files.select{|f| File.dirname(f) == 'bin'}
        files.each do |file|
          # Rename files with names that depend on the gem name.
          if file =~ /gem_name/
            new_file = file.sub(/gem_name/, gem_name)
            FileUtils.mv file, new_file
            file = new_file
          end

          # Run erb to customize each file.
          if File.extname(file) == '.erb'
            erb_file = File.read file
            File.open file, 'w' do |f|
              erb = ERB.new(erb_file)
              erb.filename = file
              f.puts erb.result(binding)
            end
            FileUtils.mv file, file.sub(/\.erb$/, '')
          end
        end
      end
    end
  end
end
