module Repper
  # Service object for exe/repper. Formats Ruby code with Repper::Codemod.
  module Command
    module_function

    PARSE_ERROR_EXIT_STATUS = 1

    def call(argv)
      if argv.count == 0
        format_stdio
      else
        format_files(argv)
      end
    end

    def format_stdio
      input = STDIN.read
      output = format(input)
      print output
    end

    def format(string)
      Codemod.call(string)
    rescue Repper::Error => e
      warn "Parsing failed: #{e.class} - #{e.message}"
      exit PARSE_ERROR_EXIT_STATUS
    end

    def format_files(paths)
      paths.grep(/\.rb\z/).each { |path| format_file(path) }
    end

    def format_file(path)
      code = File.read(path)
      formatted_code = format(code)
      File.write(path, formatted_code)
    end
  end
end
