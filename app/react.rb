require 'react.js'

class React
  def self.react
    Native(`React`)
  end
  def self.createElement(elem, options, *contents)
    react.createElement(elem, options, *contents).to_n
  end
  def self.createClass(params)
    if params.is_a? ReactClass
      params = params.params
    end
    react.createClass(params)
  end
  def self.render(element, target)
    react.render(element, target)
  end
end

class ReactClass
  def this
    @this
  end
  def params
    {
      render: -> { route(:render, `this`) },
      getInitialState: -> { route(:getInitialState, `this`).to_n }
    }
  end
  def route(method, scope)
    @this = Native(scope)
    send(method)
  end
end
