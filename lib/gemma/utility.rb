# frozen_string_literal: true

module Gemma
  #
  # Utility functions.
  #
  module Utility
    #
    # If the usage information for a script is documented in a comment block at
    # the top of the file, this method prints it out. If there is a shebang
    # (#!) on the first line, it is not printed.
    #
    def self.print_usage_from_file_comment(
      file, comment_char = '#', io = $stdout
    )
      lines = File.readlines(file)
      # ignore shebang and magic comments
      lines.shift if lines.first =~ /^#!/
      lines.shift if lines.first =~ /^#\s*frozen_string_literal/
      lines.each do |line|
        line.strip!
        break unless line.empty? || line =~ /^#{comment_char}(.*)/

        io.puts Regexp.last_match(1)
      end
    end

    #
    # A very simple recursive grep.
    #
    # @param [Regexp] tag
    #
    # @param [String] path
    #
    # @param [IO] io
    #
    # @return [nil]
    #
    def self.rgrep(tag, path, io = $stdout)
      Dir.chdir path do
        globs = Dir['**/*'] + Dir['**/.*']
        globs.select { |f| File.file?(f) }.sort.each do |f|
          File.readlines(f).each_with_index do |line, i|
            io.puts "#{f}:#{i}: #{line}" if line =~ tag
          end
        end
      end
      nil
    end
  end
end
