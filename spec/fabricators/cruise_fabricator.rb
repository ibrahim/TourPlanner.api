Fabricator(:cruise, from: Event::Cruise) do
  title "nice cruise"
  price "20"
  infos(count: 1, fabricator: :info)
  places(count: 1, fabricator: :place)
end
