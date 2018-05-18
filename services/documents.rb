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
require 'mongo'

require_relative '../libs/local_env'

module Services
  class Documents
    LOCAL_ENV = LocalEnv.new(
      'MONGO', {
        url: { type: :string, default: 'mongodb://127.0.0.1:27017/xadf' },
      })
    
    def initialize()
      url = LOCAL_ENV.get(:url)
      
      puts "> connecting to Mongo (url=#{url})"
      @cl = Mongo::Client.new(url)
      puts "< connected"
    end

    def object_id val
      begin
        BSON::ObjectId.from_string(val)
      rescue BSON::ObjectId::Invalid
        nil
      end
    end

    def find_all_documents()
      collection = @cl[:documents]
      collection.find().to_a.to_json
    end

    def find_document_by_id id
      collection = @cl[:documents]
      id = object_id(id) if String === id

      if id.nil?
        {}.to_json
      else
        document = collection.find(:_id => id).to_a.first
        (document || {}).to_json
      end
    end

    def find_document_revisions id
      collection = @cl[:revision]

      if id.nil?
        {}.to_json
      else
        collection.find(:doc_id => id).to_a.to_json
      end
    end

    def find_document_revision_by_id document_id, revision_id
      collection = @cl[:revision]
      revision_id = object_id(revision_id) if String === revision_id

      if revision_id.nil?
        {}.to_json
      else
        collection.find(:_id => revision_id, :doc_id => document_id).to_a.to_json
      end
    end
  end
end
