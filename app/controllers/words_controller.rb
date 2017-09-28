require 'open-uri'
require 'json'

class WordsController < ApplicationController

  def game
    @new_grid = Array.new(10) { ('A'..'Z').to_a.sample }
    @grid_string= @new_grid.join(',')
    @start_time = Time.now.to_formatted_s(:long)
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def score
    @query = params[:query]
    @grid = params[:grid]
    @start_time = params[:starttime]
    @end_time = Time.now
    @total_time = @end_time - @start_time.to_time
    if @query.chars.all? { |letter| @query.downcase.count(letter) <= @grid.downcase.split(',').count(letter) }
      if english_word?(@query)
        if @total_time > 60.0
          @score = 0
        else
          @score = @query.size * (1.0 - @total_time / 60.0)
        end
      else
        @score = "It's not an english word"
      end
    else
      @score = "You didn't use letters from the grid"
    end
  end
end
