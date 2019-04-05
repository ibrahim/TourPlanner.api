Fabricator(:activity, from: Event::Activity) do
  title "nice activity"
  price "120"
  infos(count: 1, fabricator: :info)
  places(count: 1, fabricator: :place)
end
