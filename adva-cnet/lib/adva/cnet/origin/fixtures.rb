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

          def load(source, target, options = {})
            Sql.load(source, target, options)
          end
        end
      end
    end
  end
end