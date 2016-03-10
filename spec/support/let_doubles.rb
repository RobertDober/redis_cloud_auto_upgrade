
module LetDoublesHelper
  def let_doubles(*names)
    names.each(&method(:let_double))
  end

  def let_double(name)
    let(name) { double }
  end
end # module LetDoublesHelper

RSpec.configure do |conf|
  conf.extend LetDoublesHelper
end
