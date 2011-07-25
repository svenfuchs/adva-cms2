module Adva
  class Static
    class Import
      autoload :Format,  'adva/static/import/format'
      autoload :Model,   'adva/static/import/model'
      autoload :Request, 'adva/static/import/request'
      autoload :Source,  'adva/static/import/source'

      attr_reader :root

      def initialize(options = {})
        @root = Source::Path.new(File.expand_path(options[:source] || 'import'))
      end

      def run
        Adva.out.puts "importing from #{root}"
        Account.all.each(&:destroy)
        Model::Site.new(root).update!
      end

      def import(path)
        model = recognize(path)
        model.update! if model
      end

      def request_for(path)
        model = recognize(path)
        Request.new(model.source, model.record, model.attributes)
      end

      protected

        def source(path)
          Source.new(path, root)
        end

        def recognize(path)
          Model.build(Source.recognize([normalize_path(path)]).first)
        end

        def normalize_path(path)
          path.gsub!(root.to_s, '')
          path.gsub!(/^\//, '')
          root.join(path)
        end
    end
  end
end
