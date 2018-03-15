require 'sinatra'
require 'sinatra/json'
require 'sinatra/config_file'

require_relative "./services/documents"

client = Services::Documents.new

# Used by Marathon healthcheck
get "/status" do
  json(status: :live)
end

get "/documents" do
  content_type :json
  client.find_all_documents()
end

get "/documents/:id" do
  content_type :json
  client.find_document_by_id(params[:id])
end

get "/documents/:id/revisions" do
  content_type :json
  client.find_document_revisions(params[:id])
end

get "/documents/:doc_id/revisions/:rev_id" do
  content_type :json
  client.find_document_revision_by_id(params[:doc_id], params[:rev_id])
end
