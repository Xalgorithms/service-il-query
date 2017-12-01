require_relative "./document_type"
require_relative "./revision_type"

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :allDocuments do
    type types[DocumentType]
    description "Find all Documents"
    resolve -> (obj, args, ctx) {
      $session.execute('SELECT id, totals FROM invoices;')
    }
  end

  field :document do
    type DocumentType
    argument :id, !types.ID
    description "Find a Document by ID"
    resolve -> (obj, args, ctx) {
      id = Cassandra::Uuid.new(args["id"])
      statement = $session.prepare('SELECT id FROM invoices WHERE id=? LIMIT 1;')

      $session.execute(statement, arguments: [id]).first
    }
  end

  field :allRevisions do
    type types[RevisionType]
    argument :document_id, !types.ID
    description "Find all revisions of a document"
    resolve -> (obj, args, ctx) {
      id = Cassandra::Uuid.new(args["document_id"])
      statement = $session.prepare('SELECT id FROM revisions WHERE id=?;')

      $session.execute(statement, arguments: [id])
    }
  end

  field :revision do
    type RevisionType
    argument :document_id, !types.ID
    argument :revision_id, !types.ID
    description "Find all revisions of a document"
    resolve -> (obj, args, ctx) {
      id = Cassandra::Uuid.new(args["revision_id"])
      statement = $session.prepare('SELECT id FROM revisions WHERE id=?;')

      $session.execute(statement, arguments: [id]).first
    }
  end
end