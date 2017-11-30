require 'sinatra'
require 'sinatra/json'
require 'sinatra/config_file'
require 'cassandra'

require_relative "./graph/app_schema"
require_relative "./utils/hash_utils"

config_file 'config.yml'
cluster = Cassandra.cluster(
  hosts: settings.db_hosts,
  port: settings.db_port
)
$session  = cluster.connect(settings.db_keyspace)

# Used by Marathon healthcheck
get "/status" do
  json(status: :live)
end

get "/" do
  content_type :html
  erb :graphiql
end

post "/graphql" do
  params = JSON.parse(request.body.read)
  query_string = params["query"]
  query_variables = ensure_hash(params["variables"])
  result = ApplicationSchema.execute(
    query_string,
    variables: query_variables,
    context: {}
  )
  result.to_json
end
