require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
   doc= Nokogiri::HTML(open('https://learn-co-curriculum.github.io/student-scraper-test-page/'))

    student_info = doc.css(".student-card")
    info =[]
    student_info.each do |student|
    info<< {
      name: "#{student.css('.card-text-container h4').text}",
      location: "#{student.css('.card-text-container p').text}",
      profile_url: "#{student.css('a').attr('href').value}"
    } 
    end
    info 
  #   html =doc.css(".student-card")[1].css('a').attr('href').value
  #   name = doc.css(".student-card")[1].css('.card-text-container h4').text
  #   location = doc.css(".student-card")[1].css('.card-text-container p').text
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    links = doc.css(".social-icon-container a").map do|item | item.attr('href') end
    quote = doc.css(".profile-quote").text
    bio = doc.css(".description-holder p").text
    twitter = links.detect {|link| link.split("/").include?("twitter.com")}
    linkedin = links.detect {|link| link.split("/").include?("www.linkedin.com")}
    github = links.detect {|link| link.split("/").include?("github.com")}
    blog = links.reject{|link| link == twitter || link ==linkedin || link == github}
    # binding.pry

    new_hash = {
      twitter: twitter,
      linkedin: linkedin ,
      github: github,
      blog: blog[0],
      profile_quote: quote,
      bio: bio}

    new_hash.select{|k, v| v!=nil}


  end

end