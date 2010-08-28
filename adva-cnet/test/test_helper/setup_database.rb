default_config = {
  :adapter      => 'postgresql',
  :host         => 'localhost',
  :port         => '5432',
  :username     => 'sven',
  :encoding     => 'utf8',
  :min_messages => 'warning'
}
postgres_config = default_config.merge(
  :database           => 'postgres',
  :schema_search_path => 'public'
)

%w(cnet_origin cnet_import).each do |name|
  config = default_config.merge(:database => name)
  ActiveRecord::Base.configurations[name] = config
  postgres = ActiveRecord::Base.establish_connection(postgres_config).connection
  postgres.drop_database(name) rescue ActiveRecord::StatementInvalid
  postgres.create_database(name, config) # rescue ActiveRecord::StatementInvalid
end

Adva::Cnet::Sql.load('origin.schema.postgres.sql', Adva::Cnet::Connections.origin)
Adva::Cnet::Sql.load('origin.schema.postgres.sql', Adva::Cnet::Connections.import)