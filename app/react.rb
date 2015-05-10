require 'native'

class React
  def self.react
    Native(`React`)
  end
  def self.createElement(elem, options, *contents)
    elem = createClass(elem) if elem.is_a? ReactClass
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
  def props
    @this.props
  end
  def params
    {
      render:            -> { route(:render, `this`) },
      getInitialState:   -> { route(:getInitialState, `this`).to_n },
      componentDidMount: -> { route(:componentDidMount, `this`) }
    }
  end
  def route(method, scope)
    @this = Native(scope)
    send(method)
  end
end
