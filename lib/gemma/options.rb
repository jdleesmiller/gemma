module Gemma
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
    # @example
    #   Gemma::Options.extract(%w(-a), %w(-a foo bar.txt))
    #   #=> #<struct Gemma::Options::ExtractResult argument="foo",
    #   #     remaining_options=["bar.txt"]>
    #
    # @param [Array<String>] names one or more names for the option to extract
    # (`['--file','-f']`, for example)
    #
    # @param [Array<String>] options to extract from; you should ensure that
    # there isn't leading/trailing whitespace (strip), because this method
    # doesn't detect it
    #
    # @return [ExtractResult] contains the argument for the given option and the
    # rest of the options
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

=begin
older version using getoptlong, but it's not really sound, because it will look for abbreviations of the arguments passed in, so unless getoptlong knows about all of the arguments, it may make mistakes. Also, it doesn't support a 'pass through' option to leave unrecognized arguments alone (probably because it's not really sound).
module Gemma
  module Utility
    #
    # Process a given array of options using `Getoptlong`.
    #
    # Unfortunately, Ruby's built-in `getoptlong` option parser only works on
    # ARGV -- you can't specify your own input options. This method works around
    # this by replacing ARGV with input and then putting the original ARGV back.
    #
    # Options not specified in `options` are ignored.
    #
    # @example Extract the "--main" argument:
    #   Utility.with_getoptlong %w(--main README.rdoc --diagram),
    #     ['--main',GetoptLong::OPTIONAL_ARGUMENT] do |opt, arg|
    #     puts "#{opt} = #{arg}"
    #   end
    #
    def self.with_getoptlong input, *options, &block
      # Put input into ARGV.
      old_args = ARGV.clone
      ARGV.replace input

      # Process input options.
      begin
        opts = GetoptLong.new(*options)
        opts.quiet = TRUE
        opts.each(&block)
      rescue GetoptLong::InvalidOption
        # The unrecognized argument has already been removed from ARGV at this
        # point, so we can retry. It appears that we have to create a new option
        # parser object in order to continue.
        retry
      end

      # Restore original ARGV.
      ARGV.replace old_args

      nil
    end

    #
    # Get the argument for an option in an array of options and arguments.
    #
    # @param [Array<String>] names one or more names for the option to extract
    # (`['--file','-f']`, for example)
    #
    # @param [Array<String>] options to extract from
    #
    # @return [String, nil] nil if the given option doesn't have an argument in
    # the array of options
    #
    def self.get_option names, options
      with_getoptlong options,
        names + [GetoptLong::OPTIONAL_ARGUMENT] do |opt, arg|
        return arg
      end
      nil 
    end
  end
end 
=end
