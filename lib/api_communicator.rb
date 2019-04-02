require 'rest-client'
require 'json'
require 'pry'

def get_character_data_from_api(character_name)
  url = "https://swapi.co/api/people/?search=#{character_name}"
  response_string = RestClient.get(url)
  response_hash = JSON.parse(response_string)
  response_hash
end

def get_film_urls(character_name)
  characters = get_character_data_from_api(character_name)
  return [] if characters['count'].zero?

  result = []
  characters['results'].each do |character|
    result << {
      name: character['name'],
      films: character['films']
    }
  end
  result
end

def get_film_title_from_api(film_url)
  film_string = RestClient.get(film_url)
  film_hash = JSON.parse(film_string)
  film_hash['title']
end

def convert_film_urls_to_titles(film_urls)
  film_titles = []
  film_urls.each do |film_url|
    film_titles << get_film_title_from_api(film_url)
  end
  film_titles
end

def get_film_titles(film_urls)
  result = []
  film_urls.each do |character_data|
    titles = convert_film_urls_to_titles(character_data[:films])
    result << {
      name: character_data[:name],
      titles: titles
    }
  end
  result
end

def get_character_movies_from_api(character_name)
  # make the web request
  film_urls = get_film_urls(character_name)
  if film_urls.length.zero?
    puts "\"#{character_name}\" has not appeared in any Star Wars film. Typo? :)"
  else
    get_film_titles(film_urls)
  end

  # iterate over the response hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `print_movies`
  #  and that method will do some nice presentation stuff like puts out a list
  #  of movies by title. Have a play around with the puts with other info about a given film.
end

def print_movies(characters_data)
  characters_data.each do |character_data|
    puts ''
    puts "Name:\t#{character_data[:name]}"
    puts 'Films:'
    character_data[:titles].each { |title| puts "\t#{title}" }
    puts ''
  end
  # some iteration magic and puts out the movies in a nice list
end

def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
