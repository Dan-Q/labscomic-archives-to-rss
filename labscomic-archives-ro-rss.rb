#!ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'nokogiri'
end
require 'date'
require 'open-uri'

RSS_TITLE = "LABS Webcomic - Reading List"
RSS_DESCRIPTION = "Complete archive of Aaron Uglum's 'LABS' comic"
ARCHIVE_PAGES = 25
ARCHIVE_ROOT = 'http://www.aaronuglum.com/cartoons/LABS/index.php?page='
ITEM_LINK_ROOT = 'http://www.aaronuglum.com'

puts <<-RSS_HEADER
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:media="http://search.yahoo.com/mrss/">
  <channel>
    <title>#{RSS_TITLE}</title>
    <link>#{ARCHIVE_ROOT}</link>
    <description>#{RSS_DESCRIPTION}</description>
    <lastBuildDate>#{Date.today.rfc2822}</lastBuildDate>
RSS_HEADER

(1..ARCHIVE_PAGES).each do |page_number|
  doc = Nokogiri::HTML(open("#{ARCHIVE_ROOT}#{page_number}"))
  doc.css('.indexItemLink').each do |item|
    # item.href
    thumb = item.css('.indexThumb')[0]
    date = Date.parse(item.css('.indexDate')[0].content)
    title = item.css('.indexTitle')[0].content
    puts <<-RSS_ITEM
      <item>
        <title>#{title}</title>
        <link>#{ITEM_LINK_ROOT}#{item['href']}</link>
        <pubDate>#{date.rfc2822}</pubDate>
        <guid isPermaLink="true">#{ITEM_LINK_ROOT}#{item['href']}</guid>
        <media:content url="#{ITEM_LINK_ROOT}#{thumb['src']}" medium="image" />
      </item>
    RSS_ITEM
  end
end

puts <<-RSS_FOOTER
  </channel>
</rss>
RSS_FOOTER