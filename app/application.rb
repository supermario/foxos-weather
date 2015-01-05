require 'opal'
require 'native'
require 'browser'
require 'browser/http'
require 'react'

class React
  def this
    `this` # get this to be some meta object that compiles?
  end
  def self.react
    Native(`React`)
  end
  def self.createElement(elem_name, options, *contents)
    react.createElement(elem_name, options, *contents).to_n
  end
  def self.createClass(params)
    react = Native(`React`)
    react.createClass(params)
  end
  def self.render(element, target)
    react = Native(`React`)
    react.render(element, target)
  end
end



params = {
  render: -> {
    React.createElement("div", {className: "flex"},
      React.createElement(
        "h1", {className: "temp"},
        `this.state.current`, React.createElement("br", {}), `this.state.high`
      ),
      React.createElement(
        "h2", {className: `this.state.weather_class`},
        React.createElement("br", {}),
        React.createElement("span", {}, `this.state.text`)
      )
    )
  },
  getInitialState: -> {
    {
      high: 'h',
      current: 'c',
      weather_class: '..'
    }.to_n
  },
  componentDidMount: -> {
    response = Browser::HTTP.get! `this.props.source` do
      @headers = []
    end
    results = response.json['query']['results']['channel']['item']
    forecast = results['forecast'][0]
    current_temp = results['condition']['temp'];

    state = {
      weather_class: "klimato-" + forecast['code'],
      date: forecast['date'],
      day: forecast['day'],
      current: current_temp,
      high: forecast['high'],
      text: forecast['text'],
    }
    `debugger`
    `this.setState(#{state.to_n})`
  }
}

react_class = React.createClass(params)

source = "http://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast WHERE woeid=22720989 and u='c'&format=json"

React.render(
  React.createElement(react_class, {source: source}),
  $document['weather']
)
