module Adva
  module Generators
    class Gemfile
      attr_reader :source, :target, :engines

      def initialize(target, options = {})
        self.engines = options[:engines]
        @target  = Pathname.new(target)
        @source  = options[:source] || raise('no source given') # TODO should bubble up to find the current Gemfile
        @engines = engines
      end
      
      def write
        File.open(target, 'w+') { |f| f.write(with_engines) }
      end
      
      protected
      
        def engines=(engines)
          engines = engine_names if engines.blank? || Array(engines).include?(:all)
          engines.unshift(:core) unless engines.include?(:core)
          @engines = engines.map(&:to_sym).uniq
        end
      
        def with_engines
          lines.join.sub(adva_gem_lines.join, engine_lines.join)
        end
      
        def engine_lines
          engines.map { |engine| adva_gem_template.gsub(/adva-\w+("|')/) { "adva-#{engine}#{$1}" } }
        end
      
        def engine_names
          Adva.engines.map { |engine| engine.name.demodulize.underscore.to_sym }
        end
      
        def adva_gem_template
          adva_gem_lines.first
        end
      
        def adva_gem_lines
          @adva_gem_lines ||= lines.select { |line| line =~ /gem ("|')adva-/ }
        end
      
        def lines
          @lines ||= File.readlines(source)
        end
    end
  end
end