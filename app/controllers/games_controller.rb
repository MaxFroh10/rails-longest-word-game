require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    letters = JSON.parse(params[:letters])
    valid = valid?(params[:word], letters)
    api = api?(params[:word])
    @result = result(valid, api)
  end

  def valid?(answer, grid)
    answer.upcase.chars.all? do |letter|
      grid.include?(letter)
      index = grid.find_index(letter)
      grid.delete_at(index) if index
    end
  end

  def api?(answer)
    url_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{answer}").read
    url = JSON.parse(url_serialized)
    url["found"] == true
  end

  def result(valid, api)
    if valid == false
      "Sorry but #{params[:word]} can't be built out of #{@letters}."
    elsif api == false
      "Sorry but #{params[:word]} does not seem to be a valid English word..."
    else
      "Congratulations! #{params[:word]} is a valid English word!"
    end
  end

end
