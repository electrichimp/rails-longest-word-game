require 'open-uri'
require 'json'

def check_grid(word, grid)
  result = true
  word_grid = grid.join
  word.chars.each do |letter|
    word_grid.include?(letter.upcase) ? word_grid = word_grid.sub(letter.upcase, '') : result = false
  end
  result
end

class GamesController < ApplicationController
  def new
    @letters = (0...40).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @word = params[:word]
    word_check = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read)
    @letters = params[:letters].split("")
    if word_check["found"] && check_grid(@word, @letters)
      @result = { score: (word_check['length']**2), message: 'Bien ahi!' }
    elsif !word_check['found'] && check_grid(@word, @letters)
      @result = { score: 0, message: 'No es una palabra en inglés!' }
    elsif word_check['found'] && !check_grid(@word, @letters)
      @result = { score: 0, message: 'No estan todas las letras!' }
    else
      @result = { score: 0, message: 'Todo mal!' }
    end
    session[:score] += @result[:score]
  end
end
