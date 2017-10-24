require_relative "./types/query_type"

ApplicationSchema = GraphQL::Schema.define(
  query: QueryType
)