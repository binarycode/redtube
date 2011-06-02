module Redtube
  class Video
    attr_accessor :id, :duration, :views, :id, :rating, :ratings, :title, :url, :thumb

    def self.find(id)
      video = get("data=redtube.Videos.getVideoById&video_id=#{id}").first
      new.tap do |object|
        object.id = video["video_id"]
        %w(duration views rating ratings title url thumb).each { |name| object.send "#{name}=", video[name] }
      end
    end

    def self.search(term)
      get("data=redtube.Videos.searchVideos&search=#{term}").map do |video|
        new
      end
    end

    private

    def self.get(query)
      Nokogiri::XML(open("http://api.redtube.com/?output=xml&#{query}").read).css("video")
    end
  end
end