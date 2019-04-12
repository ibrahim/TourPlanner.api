class GuidesIndexer
  def self.index!
    client = Elasticsearch::Client.new host:'localhost:9200', log:true
    # client.indices.delete index: 'tourfax' rescue nil
    models = [Guides::Country, Guides::City, Guides::Attraction]
    models.each do |model|
      puts "Indexing #{model.to_s}"
      unless model.__elasticsearch__.index_exists?
        model.__elasticsearch__.create_index! force: true
        model.import
      end
      # client.bulk index: 'tourfax',
      #   type:     model.to_s.split(":").last.downcase,
      #   body:     model.all.map { |a| { index: { _id: a.id.to_s, data: {"name": a.name, "description": a.description } } } },
      #   refresh:  true
    end
  end
end
