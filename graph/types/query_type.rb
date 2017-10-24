require_relative "./document_type"

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :allDocuments do
    type types[DocumentType]
    description "Find all Documents"
    resolve -> (obj, args, ctx) {
      return []
    }
  end
end