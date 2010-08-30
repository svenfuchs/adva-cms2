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

postgres  = ActiveRecord::Base.establish_connection(postgres_config).connection
databases = postgres.select_values('SELECT datname FROM pg_database')

%w(cnet_origin cnet_import cnet_tmp).each do |name|
  config = default_config.merge(:database => name)
  ActiveRecord::Base.configurations[name] = config
  # postgres.drop_database(name)
  postgres.create_database(name, config) unless databases.include?(name)
end

out, Adva.out = Adva.out, $stdout
origin = Adva::Cnet::Connections.origin
origin.load('origin.schema.postgres.sql') if origin.tables.empty?
origin.prepare('origin.full.zip') unless origin.count('cds_prod') > 0
Adva.out = out