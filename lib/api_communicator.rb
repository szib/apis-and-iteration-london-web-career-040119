require 'rest-client'
require 'json'
require 'pry'

def get_film_urls(character_name)
  url = "https://swapi.co/api/people/?search=#{character_name}"
  response_string = RestClient.get(url)
  response_hash = JSON.parse(response_string)
  return [] if response_hash['count'].zero?

  response_hash['results'][0]['films']
end

def get_film_titles(film_urls)
  films = []
  film_urls.each do |film_url|
    film_string = RestClient.get(film_url)
    film_hash = JSON.parse(film_string)
    films.push(film_hash['title'])
  end
  films
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

def print_movies(films)
  puts films
  # some iteration magic and puts out the movies in a nice list
end

def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
