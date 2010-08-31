ActiveRecord::Migration.verbose = false

class Attributable < ActiveRecord::Base
  has_many_attributes
end

ActiveRecord::Schema.define(:version => 1) do
  create_table "attributables", :force => true do |t|
    t.string :name
  end
end unless Attributable.table_exists?