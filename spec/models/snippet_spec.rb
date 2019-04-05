require 'rails_helper'

def expected_details(field, model)
    expect(model.send(field)).to eq(nil)
    model.send(:"#{field}=", "Some data")
    model.save
    expect(model.send(field)).to eq("Some data")
end

RSpec.describe "Snippets", type: :model do
  let(:user){ Fabricate(:user){ trips(count: 1)} }
  context "Snippets can have attributes in json field" do
    SNIPPETS_TYPES.each do |snippet_type|
      model = ("Snippet::" + snippet_type.to_s.singularize.capitalize).constantize 
      model::DETAILS.each do |field|
        it "#{snippet_type.capitalize} can read/write attribute '#{field}'" do
          snippet = user.trips.first.informations.first.send(snippet_type).first
          expected_details(field, snippet)
        end
      end
    end
  end
end
