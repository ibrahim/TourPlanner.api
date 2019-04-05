class Snippet::Info < Snippet::Base
  include Snippets
  DETAILS = [:icon]
  store :details, accessors: DETAILS, coder: JSON
end
