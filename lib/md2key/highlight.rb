module Md2key
  class Highlight
    DEFAULT_EXTENSION = "txt"
    class << self
      def pbcopy_highlighted_code(code)
        ensure_highlight_availability

        extension = code.extension || DEFAULT_EXTENSION

        file = Tempfile.new(["code", ".#{extension}"])
        file.write(code.source)
        file.close

        IO.popen(['highlight', '-O', 'rtf', '-K', '28', '-s', 'rdark', '-k', 'Monaco', file.path], 'r+') do |highlight|
          IO.popen('pbcopy', 'w+') do |pbcopy|
            pbcopy.write(highlight.read)
          end
        end
      ensure
        file.delete
      end

      private

      def ensure_highlight_availability
        return if system('which -s highlight')

        abort "`highlight` is not available. Try `brew install highlight`."
      end
    end
  end
end
