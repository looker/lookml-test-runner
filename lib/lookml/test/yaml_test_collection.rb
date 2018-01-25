module LookML
  module Test
    class YAMLTestCollection

      attr_reader :contents

      def initialize(dir: Dir.pwd)
        @contents = Dir.glob(File.join(dir, "*.test.yml")).map do |path|
          yaml = YAML.safe_load(File.read(path))
          if yaml.is_a?(Array)
            yaml.map do |entry|
              YAMLTest.new(entry, group: File.basename(path))
            end
          end
        end.flatten
      end

      def groups
        @contents.group_by{|test| test.group }
      end

    end
  end
end
