###############################################################################
#
#

class ParseCMakeDocCommandsApplication
  def initialize(args)
    @args = args
    @commands_to_options = {}
    @current_command = nil
    @current_options = []
  end

  def run
    File.open(@args[0], "r") do |fh|
      fh.each_line do |line|
        if (md = /<a name=\"command:([a-zA-Z0-9_]+)\">/.match(line))
          command_done
          @current_command = md[1]
        elsif line == "\
<h2><a name=\"section_Properties\"></a>Properties</h2>\n"
          command_done
        elsif line == "\
<h2><a name=\"section_StandardCMakeModules\"></a>Standard CMake Modules</h2>\n"
          command_done
        elsif line.match("Valid expressions are:")
          command_done
        elsif line.match("in which the following variables have been defined")
          command_done
        elsif line.match("For example") && @current_command != "install"
          # Avoid picking up upper case identifiers found in examples.
          command_done
        elsif line.match("variable such as:")
          # For set()
          command_done
        else
          if @current_command
            if ["remove_definitions", "if", "while", "endif", "endwhile",
                "elseif", "endif", "else"].include?(@current_command)
              next
            end

            if (md = /<pre>(.*)<\/pre>/.match(line))
              content0 = md[1]

              # Fix for command "separate_arguments", which use the
              # syntax <XXX,YYY>_ZZZ.
              content0.gsub!("&lt;UNIX|WINDOWS&gt;_COMMAND",
                             "UNIX_COMMAND WINDOWS_COMMAND")

              unless content0.match("Example")
                content1 = content0.gsub(/[^@a-zA-Z0-9_]/, " ")

                words = content1.split
                words.each do |word|
                  case word
                  when "COMMAND1";              next
                  when "COMMAND2";              next
                  when "DFOO";                  next # add- and
                  when "DBAR";                  next #  remove_definitions()
                  when "ON";                    next # set()
                  when "OFF";                   next # if() and set()
                  when "VAR";                   next # All over the place...
                  when /_VAR$/;                 next # Ditto
                  when "GUI";                   next # set()
                  when "CMAKE_MATCH_";          next # string()
                  when "CMAKE_LOADED_COMMAND_"; next # load_command()
                  when "CVS";                   next # install
                  when "OWNER_EXECUTE", "OWNER_WRITE", "OWNER_READ",
                    "GROUP_EXECUTE", "GROUP_READ"; next
                  when "ARGS"
                    # The following use ARGS to demonstrate a typical body.
                    if ["if", "when", "foreach", "function", "macro"].include?(
                                                              @current_command)
                      next
                    end
                  when "PATH"
                    if @current_command == "set"
                      next
                    end
                  when "VALUE"
                    if @current_command == "remove"
                      next
                    end
                  when "VARIABLE"
                    if @current_command == "separate_arguments"
                      next
                    end
                  end

                  # Only pick upper-case words.
                  if word == word.upcase && word.downcase != word.upcase
                    unless @current_options.include?(word)
                      @current_options << word
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    puts "(defvar andersl-cmake-font-lock-function-keywords-alist"
    print "  '("

    first = true

    longest_function_name = 0

    @commands_to_options.each_key do |x|
      longest_function_name = [longest_function_name, x.length].max
    end

    @commands_to_options.sort.each do |x,y|

      if y.empty?
        next
      end

      # Note: "target_link_libraries" use LOWER-CASE keywords. Sigh!!!
      if x == "target_link_libraries"
        y += ["debug", "optimized", "general"]
      end

      unless first
        print "\n    "
      end

      first = false

      print "(\"#{x}\" "

      print " " * (longest_function_name - x.length)
      print ". ("

      list_string = []

      for opt in y.sort
        list_string << "\"#{opt}\""
      end

      print list_string.join("\n" + (" " * (11 + longest_function_name)))
      print "))"
    end
    puts "))"
  end

  def command_done
    if @current_command
      @commands_to_options[@current_command] = @current_options
      @current_command = nil
      @current_options = []
    end
  end
end

ParseCMakeDocCommandsApplication.new(ARGV).run
