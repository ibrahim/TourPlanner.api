Fabricator(:dining, from: Event::Dining) do
  title "nice dining"
  price "25"
  infos(count: 1, fabricator: :info)
  places(count: 1, fabricator: :place)
end
