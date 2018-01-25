module LookML
  module Test
    class Assertion

      def assert(result)
        if result.errors
          err = result.errors.first
          return [false, "#{err.message}\n#{err.message_details}\n#{err.error_pos}"]
        end
        return true
      end

    end
  end
end
