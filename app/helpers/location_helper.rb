# encoding: utf-8
# Helper methods defined here can be accessed in any controller or view in the application
require 'addressable/template'

HasBeen.helpers do
  def format_travellers(travellers)
    links = travellers.collect do |traveller|
      template = Addressable::Template.new(HasBeen.url_template)
      link_to(
        traveller.name,
        template.expand({:traveller => traveller.username})
      )
    end

    links.to_sentence(:last_word_connector => " and ")
  end

  def format_locations(locations)
    links = locations.collect do |location|
      location = escape_html(location)
      link_to(location, url_for(:index, :location => location))
    end

    if links.length == 0
      "no locations yet"
    else
      links.to_sentence(:last_word_connector => " and ")
    end
  end

  def username
    sub = request.host.match(/([A-z0-9]+)\.(?:(dev|test)\.)?hasbeen\.in$/)
    sub[1].downcase if defined? sub[1]
  end

  # We ♥ our users
  def preposition
    if username == 'phrawzty'
      'to'
    else
      'in'
    end
  end

  private

  def parsed_uri
    Addressable::URI.parse( request.url )
  end

  def current_hometown_blurb
    if @traveller.current_hometown
      current_hometown = escape_html(@traveller.current_hometown)
      "<p class='lead'>#{@traveller.name}'s current hometown is #{link_to(current_hometown, url_for(:index, :location => current_hometown))}.</p>"
    end
  end

  def this_is_hometown
    if @traveller.current_hometown == @location
      "This is #{@traveller.name}'s current hometown."
    end
  end

  def join_us_link
    '<p class="mini muted pull-right"><small>Join hasbeen.in at <a href="https://github.com/findoutwho/hasbeen.in">GitHub</a>!</small></p>'
  end

  def home_link
    uri = parsed_uri()
    uri.host.sub!(/[A-z0-9]+\./, 'www.')
    '<p class="mini muted pull-left"><small><a href="'+uri.to_s+'">« Others</a></small></p>'
  end

  def descriptive_title
    suffix = if username == 'www'
      "Places we have been."
    else
      "Places #{username} has been."
    end
    "hasbeen.in · #{suffix}"
  end
end
