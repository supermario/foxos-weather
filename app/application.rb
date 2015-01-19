require 'opal'
require 'native'
require 'browser'
require 'browser/http'
require 'react'

class React
  def self.react
    Native(`React`)
  end
  def self.createElement(elem_name, options, *contents)
    react.createElement(elem_name, options, *contents).to_n
  end
  def self.createClass(params)
    react.createClass(params)
  end
  def self.render(element, target)
    react.render(element, target)
  end
end

class ReactClassParams
  def this
    self
  end
  def state
    self
  end
  def current
    `#{@this}.state.current`
  end
  def params
    {
      render: -> { route(:render, `this`) },
      getInitialState: -> { route(:getInitialState, `this`) }
    }
  end
  def route(method, scope)
    @this = scope
    send(method)
  end
end

class TestDiv < ReactClassParams
  def render
    React.createElement("div", {}, this.state.current)
  end
  def getInitialState
    {
      high: 'h',
      current: 'c',
      weather_class: '..'
    }.to_n
  end
end

react_class = React.createClass(TestDiv.new.params)

React.render(
  React.createElement(react_class),
  $document['weather']
)
