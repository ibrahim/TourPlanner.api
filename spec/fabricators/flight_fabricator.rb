Fabricator(:flight, from: Event::Flight) do
  title "nice flight"
  price "300"
  infos(count: 1, fabricator: :info)
  places(count: 1, fabricator: :place)
end
