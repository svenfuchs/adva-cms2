module Adva
  class Static
    class Import
      autoload :Format,  'adva/static/import/format'
      autoload :Model,   'adva/static/import/model'
      autoload :Request, 'adva/static/import/request'
      autoload :Source,  'adva/static/import/source'

      attr_reader :root

      def initialize(options = {})
        @root = Pathname.new(File.expand_path(options[:source] || 'import'))
      end

      def run
        Adva.out.puts "importing from #{root}"
        Account.all.each(&:destroy)
        Model::Site.new(root).updated_record.save!
      end

      def import(path)
        model = recognize(path).first
        model.updated_record.save! if model
      end

      def request_for(path)
        model = recognize(path).first
        Request.new(model.record, model.attributes)
      end

      protected

        def source(path)
          Source.new(path, root)
        end

        def recognize(path)
          Model.recognize([source(path)])
        end
    end
  end
end
