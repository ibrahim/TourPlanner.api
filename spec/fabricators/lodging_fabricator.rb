Fabricator(:lodging, from: Event::Lodging) do
  title "nice hotel"
  price "125"
  infos(count: 1, fabricator: :info)
  places(count: 1, fabricator: :place)
end
