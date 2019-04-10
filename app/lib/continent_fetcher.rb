class ContinentFetcher < GuideFetcher

  def initialize(continent)
    @continent = continent
  end
  
  def fetch
    continent = @continent
    Wombat.crawl do
      base_url "https://www.arrivalguides.com"
      path "/en/Travelguides/#{continent}"
      title css: ".continent-text h1"
      countries "css=.main-container .tile-group article", :iterator do
        name  css: "a .tileOverlay .tileContentHolder h2"
        full_url({ xpath: "./a/@href" })
      end
    end
  end


end
