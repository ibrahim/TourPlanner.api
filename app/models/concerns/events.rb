# require 'active_support/concern'

module Events
  extend ActiveSupport::Concern

  included do
    self.table_name = "events"
    translates :title, :notes
    belongs_to :trip
    belongs_to :section
    has_many :snippets, as: :owner, class_name: "Snippet::Base"
    has_many :infos,    as: :owner, class_name: "Snippet::Info"
    has_many :places,   as: :owner, class_name: "Snippet::Place"
  end


  def section_uuid
    SimpleUUID::UUID.new( section_id ).to_guid.upcase
  end

  class_methods do
  end
  
end
