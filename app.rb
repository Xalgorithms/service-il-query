# Copyright (C) 2018 Don Kelly <karfai@gmail.com>
# Copyright (C) 2018 Hayk Pilosyan <hayk.pilos@gmail.com>

# This file is part of Interlibr, a functional component of an
# Internet of Rules (IoR).

# ACKNOWLEDGEMENTS
# Funds: Xalgorithms Foundation
# Collaborators: Don Kelly, Joseph Potvin and Bill Olders.

# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public
# License along with this program. If not, see
# <http://www.gnu.org/licenses/>.
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
