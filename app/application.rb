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
  def params
    {
      render: -> { render },
      getInitialState: -> { getInitialState }
    }
  end
end

class TestDiv < ReactClassParams
  def render
    React.createElement("div", {}, "test")
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
