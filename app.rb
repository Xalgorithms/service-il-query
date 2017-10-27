require 'sinatra'
require 'sinatra/json'

require_relative "./graph/app_schema"
require_relative "./utils/hash_utils"

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
