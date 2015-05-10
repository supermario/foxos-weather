# require 'opal'
require 'react'
require 'browser'
require 'browser/http'

class Weather < ReactClass
  def render
    React.createElement('div', {className: 'flex'},
      React.createElement(
        'h1', {className: 'temp'},
        this.state.current, React.createElement('br', {}), this.state.high
      ),
      React.createElement(
        'h2', {className: this.state.weather_class}
      )
    )
  end
  def getInitialState
    {
      high:          '..',
      current:       '..',
      weather_class: '..'
    }
  end
  def componentDidMount
    Browser::HTTP.get(this.props.source) do |s|
      s.headers.clear
      s.on(:success) { |res| handleJSON(res) }
    end
  end
  def handleJSON(res)
    results      = res.json['query']['results']['channel']['item']
    forecast     = results['forecast'][0]
    current_temp = results['condition']['temp'];

    state = {
      weather_class: "klimato-" + forecast['code'],
      date:          forecast['date'],
      day:           forecast['day'],
      current:       current_temp,
      high:          forecast['high'],
      text:          forecast['text'],
    }

    this.setState(state)
  end
end

source = "http://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid=22720989 and u='c'&format=json"

React.render(
  React.createElement(Weather.new, {source: source}),
  $document['weather']
)
