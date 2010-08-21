module Adva
  class Cnet
    class Origin
      class Prepare
        attr_reader :source, :target
        
        def initialize(source, target)
          source ||= Adva::Cnet.root.join('db/cnet/origin.full.zip')
          target ||= Adva::Cnet.root.join('db/cnet/origin.full.sqlite3')

          @source = source
          @target = target
        end
        
        def run
          extract_cnet_dump
          load_cnet_dump
        end

        def extract_cnet_dump
          FileUtils.rm_r(tmp_dir) if File.directory?(tmp_dir)
          FileUtils.mkdir_p(tmp_dir)
          `unzip #{source} -d #{tmp_dir}`
        end
        
        def load_cnet_dump
          Schema.load!(connection)
          Origin::Source.load!(tmp_dir, target)
        end
        
        def connection
          Database.new(target).connection
        end
        
        def tmp_dir
          @tmp_dir ||= path = Pathname.new('/tmp/adva-cnet/data')
        end
      end
    end
  end
end