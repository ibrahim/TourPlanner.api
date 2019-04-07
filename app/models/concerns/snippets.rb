# require 'active_support/concern'

module Snippets
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, polymorphic: true
  end

  class_methods do
  end
  
end
