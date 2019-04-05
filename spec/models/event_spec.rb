
require 'rails_helper'
def expected_event_details(fields, model)
  fields.each do |field|
    expect(model.send(field)).to eq(nil)
    model.send(:"#{field}=", "Some data")
    model.save
    expect(model.send(field)).to eq("Some data")
  end
end

RSpec.describe "Events", type: :model do
  let(:user){ Fabricate(:user){ trips(count: 1)}}
  context "Event can have many snippets" do
    EVENTS_TYPES.each do |event_type|
      SNIPPETS_TYPES.each do |snippet_type|
        it "#{event_type.to_s.singularize.capitalize} events can have many #{snippet_type} snippets" do
          model = user.trips.first.send(event_type).first
          expect(model).to have_many(snippet_type)
        end
      end
    end
  end

  context "Reading/Writing event details attributes" do
      EVENTS_TYPES.each do |type|
        it "for #{type}" do
          model = user.trips.first.send(type).first
          expected_event_details(model.class::DETAILS, model)
        end
      end
  end
end
