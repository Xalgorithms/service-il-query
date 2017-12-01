require "graphql"
require_relative "./revision_type"

DocumentType = GraphQL::ObjectType.define do
  name "Document"
  description "A document"

  field :id, !types.ID, hash_key: 'id'
  field :totals, types.String, hash_key: 'totals'
  field :body, types.String, hash_key: 'body'
  field :revisions do
    type types[RevisionType]
    description "All revisions"
    resolve -> (obj, args, ctx) {
      id = obj["id"]
      statement = $session.prepare('SELECT id FROM revisions WHERE id=?;')

      $session.execute(statement, arguments: [id])
    }
  end
end