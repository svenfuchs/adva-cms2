module Adva
  class Cnet
    class Origin
      module Fixtures
        autoload :Extraction,  'adva/cnet/origin/fixtures/extraction'
        autoload :Preparation, 'adva/cnet/origin/fixtures/preparation'

        class << self
          def dump(source, target)
            source ||= Adva::Cnet.root.join('db/dump/origin.fixtures.sqlite3')
            target ||= Adva::Cnet.root.join('db/dump/origin.fixtures.sql')

            `sqlite3 #{source} .dump > #{target}`
          end
          
          def load(source, target)
            source ||= Adva::Cnet.root.join('db/dump/origin.fixtures.sql')
            target ||= Adva::Cnet.root.join('db/dump/origin.test.sqlite3')

            `rm -f #{target}; sqlite3 #{target} < #{source}`
          end
        end
      end
    end
  end
end