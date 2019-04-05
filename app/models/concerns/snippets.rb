# require 'active_support/concern'

module Snippets
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, polymorphic: true
  end

  class_methods do
  end
  
  def snippet_type
    self[:type].split("::").last
  end
end
