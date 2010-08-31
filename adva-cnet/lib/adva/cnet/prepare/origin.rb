module Adva
  class Cnet
    class Prepare
      class Origin
        attr_reader :source, :target, :pattern

        def initialize(source, target, options = {})
          @source  = source.respond_to?(:stat) ? source : Adva::Cnet.normalize_path(source)
          @target  = target
          @pattern = options[:pattern] || '**/*.txt'
        end

        def load
          extract_cnet_dump
          clear_data
          load_cnet_dump
        end
        
        protected
        
          def clear_data
            Adva.out.puts "clearing data from #{target.config[:database]}"
            target.clear!
          end

          def extract_cnet_dump
            FileUtils.rm_r(tmp_dir) if File.directory?(tmp_dir)
            FileUtils.mkdir_p(tmp_dir)
            `unzip #{source} -d #{tmp_dir}`
          end

          def load_cnet_dump
            Adva.out.puts "loading data from #{source}"
            target.with_encoding('LATIN1') do
              files.each { |file| load_cnet_file(file) }
            end
          end

          def load_cnet_file(file)
            return if file =~ /Catalog_Info/
            table_name = self.table_name(file)
            Adva.out.print "loading data to #{table_name} in #{target.config[:database]}: "
            target.execute "COPY #{table_name} FROM '#{file}'"
            Adva.out.puts "#{target.count(table_name)} records."
          rescue ActiveRecord::StatementInvalid => e
            puts "could not import #{file} because: #{e.message}"
          end

          def files
            Dir["#{tmp_dir}/#{pattern}"]
          end

          def table_name(file)
            name = "cds_#{File.basename(file, File.extname(file))}"
            name.downcase!
            name.gsub!('digital_content', 'digcontent')
            name.gsub!('language_links', 'lang_links')
            name.gsub!('languages', 'langs')
            name
          end

          def tmp_dir
            @tmp_dir ||= path = Pathname.new('/tmp/adva-cnet/data')
          end
      end
    end
  end
end