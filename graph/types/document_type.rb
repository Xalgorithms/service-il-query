require "graphql"

DocumentType = GraphQL::ObjectType.define do
  name "Document"
  description "A document"

  field :id, !types.ID, hash_key: 'id'
  field :title, !types.String, hash_key: 'title'
  field :body, !types.String, hash_key: 'body'
end