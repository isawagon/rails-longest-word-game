require 'open-uri'
require 'json'
class GamesController < ApplicationController

  def new
    @grid = []
    alphabet = ("A"..."Z").to_a
    (0..9).each {@grid << alphabet.sample}
  end

  def score
    @result = {}
    @grid = params[:grid].split
    @word = params[:word]
    grid1 = params[:grid].split
    check_grid(@word, grid1, @result)
    if @result[:message] === "not in the grid"
      @result[:message] = "Sorry but #{@word.upcase} can't be built out of #{@grid}"
    else
      check_dictionnary(@word, @result)
    end
  end

  def check_grid(word, grid, result)
    word.chars.each do |letter|
      if grid.index(letter.upcase).nil?
        result[:message] = "not in the grid"
        result[:score] = 0
      else
        grid.delete_at(grid.index(letter.upcase))
      end
    end
  end

  def check_dictionnary(word, result)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    word1 = JSON.parse(word_serialized)
    if word1["found"]
      result[:score] = (100 * word.length)
      result[:message] = "Well Done!"
    else
      result[:message] = "Sorry but #{word} is not an english word"
      result[:score] = 0
    end
  end
end
