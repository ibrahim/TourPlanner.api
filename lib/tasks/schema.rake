require 'json'

namespace :graphql do
  namespace :dump do
    desc 'Dumps the IDL schema into ./app/graphql/schema.graphql'
    task idl: [:environment] do
      target = Rails.root.join("app/graphql/schema.graphql")
      schema = GraphQL::Schema::Printer.print_schema(ApiSchema)
      File.open(target, "w+") do |f|
        f.write(schema)
      end
      puts "Schema dumped into app/graph1l/schema.graphql"
    end

    desc 'Dumps the result of the introspection query into ./app/graphql/schema.json'
    task json: [:environment] do
      target = Rails.root.join("app/graphql/schema.json")
      result = ApiSchema.execute(GraphQL::Introspection::INTROSPECTION_QUERY)
      File.open(target, "w+") do |f|
        f.write(JSON.pretty_generate(result))
      end
      puts "Schema dumped into app/graph/schema.json"
    end
  end

  desc 'Dumps both the IDL and result of introspection query in app/graph'
  task dump: ["graphql:dump:idl", "graphql:dump:json"]
end
