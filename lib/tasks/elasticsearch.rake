
require 'elasticsearch/rails/tasks/import'

# client = Elasticsearch::Client.new host:'localhost:9200', log:true
#
# client.indices.delete index: 'articles' rescue nil
# client.bulk index: 'articles',
#             type:  'article',
#             body:  Article.all.map { |a| { index: { _id: a.id, data: a.attributes } } },
#             refresh: true
