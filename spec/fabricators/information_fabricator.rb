Fabricator(:information, from: Event::Information) do
  title "nice information"
  price nil
  infos(count: 1, fabricator: :info)
  places(count: 1, fabricator: :place)
end
