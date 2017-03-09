# frozen_string_literal: true
module Gemma
  #
  # Helpers for processing command line arguments.
  #
  module Options
    #
    # @attr [String, nil] argument
    # @attr [Array<String>] remaining_options
    #
    ExtractResult = Struct.new(:argument, :remaining_options)

    #
    # Extract the last option with one of the given `names` from `input`.
    #
    # Long form options of the form `--foo`, `--foo bar` and `--foo=bar` are
    # supported (where `--foo` is the option name and `bar` is the argument in
    # the last two forms).
    #
    # Short form options of the form `-f`, `-fbar` and `-f bar` are supported
    # (where `-f` is the option name and `bar` is the argument in the last two
    # forms). However concatenated short forms are not supported; that is, the
    # option `-fg` is interpreted as `-f g` (option `f` with argument `g`)
    # rather than `-f -g` (options `f` and `g` with no arguments).
    #
    # Abbreviated long form options (e.g. `--ex` for `--example`) are not
    # supported, because this method doesn't know the full set of acceptable
    # options, so it can't resolve ambiguities.
    #
    # If an option appears more than once, the argument for the last one is
    # returned, and the previous matching options and arguments are deleted
    # (i.e. not returned in {ExtractResult#remaining_options}).
    #
    # Matching options that appear after a `--` terminator are not extracted;
    # they remain in the {ExtractResult#remaining_options} list.
    #
    # The +options+ parameter takes an array of arguments; to split a string
    # into the appropriate form, you can use the +Shellwords+ module in the ruby
    # standard library.  
    #
    # @example
    #   Gemma::Options.extract(%w(-a), %w(-a foo bar.txt))
    #   #=> #<struct Gemma::Options::ExtractResult argument="foo",
    #   #     remaining_options=["bar.txt"]>
    #
    # @param [Array<String>] names one or more names for the option to extract
    #        (`['--file','-f']`, for example)
    #
    # @param [Array<String>] options to extract from; you should ensure that
    #        there isn't leading/trailing whitespace (strip), because this
    #        method doesn't detect it
    #
    # @return [ExtractResult] contains the argument for the given option and the
    #         rest of the options
    #
    def self.extract names, options
      options = options.dup
      result = nil
      done = []

      until options.empty?
        x = options.shift
        if x == '--' then
          # Stop at the '--' terminator.
          done << x
          break
        elsif x =~ /^(--[^=]+)/ then
          if names.member?($1) then
            # Found a long style option; look for its argument (if any).
            if x =~ /=(.*)$/ then
              result = $1
            elsif !options.empty? && options.first !~ /^-./
              result = options.shift
            else
              result = ''
            end
          else
            done << x
          end
        elsif x =~ /^(-(.))(.*)/ then
          # Found a short style option; this may actually represent several
          # options; look for matching short options.
          name, letter, rest = $1, $2, $3
          if names.member?(name)
            if rest.length > 0
              result = rest
            elsif !options.empty? && options.first !~ /^-./
              result = options.shift
            else
              result = ''
            end
          else
            done << x
          end
        else
          # Not an option; just let it pass through.
          done << x
        end
      end

      ExtractResult.new(result, done + options)
    end
  end
end
