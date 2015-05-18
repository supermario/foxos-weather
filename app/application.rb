require 'react'
require 'browser'
require 'browser/http'

class Speech
  def self.speak(text)
    w = Native(`window`)
    msg = Native(`new SpeechSynthesisUtterance()`)
    msg.voice = Native(`window.speechSynthesis.getVoices[3]`)
    msg.text = text
    msg.rate = 1
    w.speechSynthesis.speak(msg);
  end
end

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

    [:click, :touch].each do |event|
      $window.on(event) { load_weather }
    end
  end

  def load_weather
    Browser::HTTP.get(props.source) do |s|
      s.headers.clear
      s.on(:success) { |res| handle_json(res) }
    end
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

    set_state(state)

    Speech.speak("Todays forecast is #{forecast['text']}")
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
