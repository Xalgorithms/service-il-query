def ensure_hash(query_variables)
  if query_variables.nil? || query_variables.empty? || query_variables == "null"
    {}
  elsif query_variables.is_a?(String)
    JSON.parse(query_variables)
  else
    query_variables
  end
end