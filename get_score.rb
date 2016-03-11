require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get_page url
  Nokogiri::HTML(open(url))
end

def get_live_score_div page
  page.css("div[id='live']")
end

def get_li_with_tournament_title title, div
  lis = div.css("li")
  lis.find do |li|
    heading = li.css("h3")
    heading.text.match(/#{title}/i)
  end
end

def get_scorelines li
  li.css("li[class='espni-livescores-scoreline']")
end

def get_scoreline_title scoreline
  part1 = scoreline.css("div[class='part-1']")
  part2 = scoreline.css("div[class='part-2']")

  "#{get_team_info_from_part part1} vs #{get_team_info_from_part part2}"
end

def get_team_info_from_part part
  "#{get_team_name_from_part part}: #{get_team_score_from_part part}"
end

def get_team_name_from_part part
  part.css("span[class='team-name']").text
end

def get_team_score_from_part part
  part.css("span[class='team-score']").text
end

def get_scoreline_start_time scoreline
  scoreline.css("span[class='start-time']").text.lstrip
end

def main
  page = get_page "http://www.espncricinfo.com"
  div = get_live_score_div page
  li = get_li_with_tournament_title "WORLD T20", div
  scorelines = get_scorelines li
  scorelines.each do |scoreline|
    puts get_scoreline_title scoreline
    start_time = get_scoreline_start_time scoreline
    puts "Start time: #{start_time}" if start_time.length > 0
    puts
  end
end

main if __FILE__ == $0
