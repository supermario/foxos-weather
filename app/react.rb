require 'native'

class React
  def self.react
    Native(`React`)
  end
  def self.create_element(elem, options, *contents)
    elem = create_class(elem) if elem.is_a? ReactClass
    react.createElement(elem, options, *contents).to_n
  end
  def self.create_class(params)
    params = params.params if params.is_a? ReactClass
    react.createClass(params)
  end
  def self.render(element, target)
    react.render(element, target)
  end
end

class ReactClass
  attr_reader :this

  def props
    this.props
  end

  def state
    this.state
  end

  def set_state(state)
    this.setState(state)
  end

  def params
    {
      render:            -> { route(:render, `this`) },
      getInitialState:   -> { route(:initial_state, `this`).to_n },
      componentDidMount: -> { route(:component_did_mount, `this`) }
    }
  end

  def route(method, scope)
    @this = Native(scope)
    send(method)
  end
end
