require "graphql"

RevisionType = GraphQL::ObjectType.define do
  name "Revision"
  description "A revision"

  field :id, !types.ID, hash_key: 'id'
end