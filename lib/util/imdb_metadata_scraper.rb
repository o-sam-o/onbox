require 'rubygems'
require "hpricot"
require "open-uri"
require 'uri'

class ImdbMetadataScraper 
  IMDB_BASE_URL = 'http://www.imdb.com/'
  IMDB_SEARCH_URL = IMDB_BASE_URL + 'find?s=tt&q='
  IMDB_MOVIE_URL = IMDB_BASE_URL + 'title/tt'

  def self.search_for_imdb_id(name, year)
    doc = Hpricot(open(IMDB_SEARCH_URL + URI.escape(name)))
    doc.search("//td").each do |td| 
      td.search("//a") do |link|  
        href = link.attributes['href']
        current_name = link.inner_text
        if href =~ /^\/title\/tt(\d+)/ and not link.inner_text.empty?
          imdb_id = $1
          current_year = $1.gsub(/\(\)/, '').to_i if td.inner_text =~ /\((\d{4})\)/

          return imdb_id if not year or current_year == year
        end
      end
    end
    return nil
  end
  
  def self.scrap_movie_info(imdb_id)
    info_hash = {}
    
    doc = Hpricot(open(IMDB_MOVIE_URL + imdb_id))
    title_text = doc.search("//meta[@name='title']").first.attributes['content']
    if title_text =~ /(.*) \((\d{4}).*\)/
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
      key = div.search("//h5").first.inner_text.sub(':', '')
      value = div.search("//div[@class = 'info-content']").first.inner_text.gsub(/(\s{2,}|\n|more$)/, '')
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

end