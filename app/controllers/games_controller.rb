require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    generate_letters
  end

def score
  @word = params[:word].to_s.upcase
  @letters = params[:letters] || []

  if !can_be_built?(@word, @letters)
    @result = "Sorry, but #{@word} can't be built out of #{@letters.join(', ')}"
  elsif !english_word?(@word)
    @result = "Sorry, but #{@word} does not seem to be a valid English word."
  else
    @result = "Congratulations! #{@word} is a valid English word!"
  end
end

  private

  def generate_letters
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def can_be_built?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
