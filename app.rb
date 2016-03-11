require 'sinatra/base'
require 'json'
require 'securerandom'
require_relative "./get_score.rb"

module ChatDemo
  class App < Sinatra::Base
    post "/support" do
      data = JSON.parse(request.body.read.to_s)
      values = data['text'].split(':')
      user = values[0]
      text = values[1]

      result = nil
      if data['text'] =~ /cricket score(.*)/
      page = get_page "http://www.espncricinfo.com"
      div = get_live_score_div page
      li = get_li_with_tournament_title "WORLD T20", div
      scorelines = get_scorelines li
      scorelines.each do |scoreline|
        result = "#{get_scoreline_title scoreline}"
	start_time = get_scoreline_start_time scoreline
	result = "#{result}\nStart time: #{start_time}" if start_time.length > 0
      end
      end


      { :text => result}.to_json unless result.nil?
    end
  end
end
