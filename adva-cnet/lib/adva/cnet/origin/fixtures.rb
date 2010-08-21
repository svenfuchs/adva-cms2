module Adva
  class Cnet
    class Origin
      module Fixtures
        autoload :Extract, 'adva/cnet/origin/fixtures/extract'

        class << self
          def dump(source, target)
            source ||= Adva::Cnet.root.join('db/cnet/origin.fixtures.sqlite3')
            target ||= Adva::Cnet.root.join('db/cnet/origin.fixtures.sql')

            `sqlite3 #{source} .dump > #{target}`
          end
          
          def load(source, target)
            source ||= Adva::Cnet.root.join('db/cnet/origin.fixtures.sql')
            target ||= Adva::Cnet.root.join('db/cnet/origin.test.sqlite3')
            # `rm -f #{target}; sqlite3 #{target} < #{source}`
            
            fixtures = File.read(source).split("\n")
            fixtures.each { |line| target.execute(line) }
          end
        end
      end
    end
  end
end