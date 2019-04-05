Fabricator(:transportation, from: Event::Transportation) do
  title "nice transportation"
  price "20"
  infos(count: 1, fabricator: :info)
  places(count: 1, fabricator: :place)
end
