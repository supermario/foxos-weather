require 'opal'
require 'react'
require 'browser'

class TestDiv < ReactClass
  def render
    React.createElement("div", {}, this.state.text)
  end
  def getInitialState
    { text: 'Hello Opal!' }
  end
end

React.render(
  React.createElement(TestDiv.new),
  $document['test']
)
