require 'react'
require 'browser'
require 'browser/http'
require 'browser/interval'

class Weather < ReactClass
  def render
    React.create_element(
      'div', { className: 'flex' },
      React.create_element(
        'h1', { className: 'temp' },
        state.current, React.create_element('br', {}), state.high
      ),
      React.create_element(
        'h2', className: state.weather_class
      )
    )
  end

  def initial_state
    {
      high:          '..',
      current:       '..',
      weather_class: '..'
    }
  end

  def component_did_mount
    load_weather
    every(props.poll_interval) { load_weather }
  end

  def load_weather
    Browser::HTTP.get(props.source) do |s|
      s.headers.clear
      s.on(:success) { |res| handle_json(res) }
    end
    puts 'nice'
  end

  def handle_json(res)
    results      = res.json['query']['results']['channel']['item']
    forecast     = results['forecast'][0]
    current_temp = results['condition']['temp']

    state = {
      weather_class: 'klimato-' + forecast['code'],
      date:          forecast['date'],
      day:           forecast['day'],
      current:       current_temp,
      high:          forecast['high'],
      text:          forecast['text']
    }

    this.setState(state)
  end
end

source = "http://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid=22720989 and u='c'&format=json"

React.render(
  React.create_element(
    Weather.new,
    source: source, poll_interval: 60 * 10
  ),
  $document['weather']
)
