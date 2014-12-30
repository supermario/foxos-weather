require 'native'

class React
  def self.createClass(hash)
    `React.createClass(#{hash.to_n})`
  end
end
