require 'opal'
require 'opal-jquery'
require 'native'
require 'json'

@React = Native(`React`)

params = {
  render: -> {
    @React.createElement("div", {className: "flex"},
      @React.createElement(
        "h1", {className: "temp"},
        `this.state.current`, @React.createElement("br", {}).to_n, `this.state.high`
      ).to_n,
      @React.createElement(
        "h2", {className: `this.state.weather_class`},
        @React.createElement("br", {}).to_n,
        @React.createElement("span", {}, `this.state.text`).to_n
      ).to_n
    ).to_n
  },
  getInitialState: -> {
    {
      high: '..',
      current: '..',
      weather_class: '..'
    }.to_n
  },
  componentDidMount: -> {
    `that = this`
    HTTP.get(`this.props.source`) do |response|

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

      `that.setState(#{state.to_n})`
    end
  }
}

react_class = @React.createClass(params)

source = "http://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast WHERE woeid=22720989 and u='c'&format=json"

@React.render(
  @React.createElement(react_class, {source: source}),
  Element['#weather'].get(0)
)
