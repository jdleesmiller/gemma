# frozen_string_literal: true
module Gemma
  module Utility
    #
    # If the usage information for a script is documented in a comment block at
    # the top of the file, this method prints it out. If there is a shebang
    # (#!) on the first line, it is not printed.
    #
    def self.print_usage_from_file_comment(file, comment_char='#', io=$stdout)
      lines = File.readlines(file)
      lines.shift if lines.first =~ /^#!/ # ignore shebang
      for line in lines
        line.strip!
        break unless line =~ /^#{comment_char}(.*)/
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
    def self.rgrep(tag, path, io=$stdout)
      Dir.chdir path do
        (Dir['**/*'] + Dir['**/.*']).select {|f| File.file? f}.sort.each do |f|
          File.readlines(f).each_with_index do |line, i|
            io.puts "#{f}:#{i}: #{line}" if line =~ tag
          end
        end
      end
      nil
    end
  end
end
