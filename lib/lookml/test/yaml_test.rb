module LookML
  module Test
    class YAMLTest

      attr_reader :group
      attr_reader :title

      def initialize(hash, group: nil)
        @group = group
        @title = hash["test"]
        @query = hash["query"]
        @assertions = [hash["assert"]].flatten.map do |definition|
          if definition == "success"
            Assertion.new
          else
            raise "Unknown assertion #{definition}"
          end
        end

        if @assertions.length == 0
          raise "'assert' not defined for #{@title}"
        end
      end

      def run!(runner)
        begin
          result = runner.sdk.run_inline_query("json_detail", @query)
        rescue LookerSDK::NotFound
          return [false, "Looker returned a 404 error for this query. Are the model and explore name correct?"]
        end
        @assertions.each do |assertion|
          (success, msg) = assertion.assert(result)
          return [success, msg] unless success
        end
        return [true, nil]
      end

    end
  end
end
