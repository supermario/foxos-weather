require 'opal'
require 'native'
require 'browser'
require 'browser/http'
require 'react'

class TestDiv < ReactClass
  def render
    React.createElement("div", {}, this.state.current)
  end
  def getInitialState
    {
      high: 'h',
      current: 'c',
      weather_class: '..'
    }
  end
end

react_class = React.createClass(TestDiv.new.params)

React.render(
  React.createElement(react_class),
  $document['weather']
)
