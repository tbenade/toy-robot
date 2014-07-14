module Validations

  # validates if the supplied val can be converted to an integer. No good for octal
  def integer?(val)
    Integer(val) != nil rescue false
  end

end