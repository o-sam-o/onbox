class ImdbMetadataScraper 
  IMDB_BASE_URL = 'http://www.imdb.com/'
  IMDB_SEARCH_URL = IMDB_BASE_URL + 'find?s=tt&q='
  IMDB_MOVIE_URL = IMDB_BASE_URL + 'title/tt'

  STRIP_WHITESPACE = /(\s{2,}|\n|\|)/

  def self.search_for_imdb_id(name, year)
    doc = Hpricot(open(IMDB_SEARCH_URL + URI.escape(name)))
    doc.search("//td").each do |td| 
      td.search("//a") do |link|  
        href = link.attributes['href']
        current_name = link.inner_text
        if href =~ /^\/title\/tt(\d+)/ && link.inner_text.present?
          imdb_id = $1
          current_year = $1.gsub(/\(\)/, '').to_i if td.inner_text =~ /\((\d{4}\/?\w*)\)/

          return imdb_id if not year || current_year == year
        end
      end
    end
    return nil
  end
  
  def self.scrap_movie_info(imdb_id)
    info_hash = {}
    
    doc = ImdbMetadataScraper.get_movie_page(imdb_id)
    title_text = doc.search("//meta[@name='title']").first.attributes['content']
    # Matches 'Movie Name (2010)' or 'Movie Name (2010/I)'
    if title_text =~ /(.*) \((\d{4})\/?\w*\)/
      info_hash['title'] = $1
      info_hash['year'] = $2
    else
      #If we cant get title and year something is wrong
      raise "Unable to find title or year for imdb id #{imdb_id}"
    end
    
    found_info_divs = false
    doc.search("//div[@class='info']") do |div|
      next if div.search("//h5").empty?
      found_info_divs = true
      key = div.search("//h5").first.inner_text.sub(':', '').downcase
      value_search = "//div[@class = 'info-content']"
      value = div.search(value_search).first.children.select{|e| e.text?}.join.gsub(STRIP_WHITESPACE, '')
      if value.empty?
        value = div.search(value_search).first.inner_text.gsub(STRIP_WHITESPACE, '')
      end
      if key == 'release date'
        value = Date.strptime(value, '%d %B %Y')
      elsif key == 'runtime'
        if value =~ /(\d+)\smin/
          value = $1.to_i
        else
          logger.error "Unexpected runtime format #{value} for movie #{imdb_id}"
        end
      elsif key == 'genre'
        value = value.sub(/more$/, '')
      end
      info_hash[key.downcase] = value
    end
    
    if not found_info_divs
          #If we don't find any info divs assume parsing failed
      raise "No info divs found for imdb id #{imdb_id}"
    end
    
    
    #scrap poster image urls
    thumb = doc.search("//div[@class = 'photo']/a/img")
    if thumb
      thumbnail_url = thumb.first.attributes['src']
      if not thumbnail_url =~ /addposter.jpg$/ 
        info_hash['small_image'] = thumbnail_url
        
        #Try to scrap a larger version of the image url
        large_img_page = doc.search("//div[@class = 'photo']/a").first.attributes['href']
        large_img_doc = Hpricot(open('http://www.imdb.com' + large_img_page))
        large_img_url = large_img_doc.search("//table[@id = 'principal']").search('//img').first.attributes['src']
        info_hash['large_image'] = large_img_url
      end
    end
    
    return info_hash 
  end

  private
    def self.get_movie_page(imdb_id)
      require 'open-uri'
      require 'hpricot'
      return Hpricot(open(IMDB_MOVIE_URL + imdb_id))
    end

end