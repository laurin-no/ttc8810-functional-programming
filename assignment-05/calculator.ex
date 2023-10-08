# Declare a function Calculator.calc that takes a string parameter.

# From string parameter, parse a number, operator (+,-,*,/) and second number,
#  for example 123+456

# Call the corresponding Math function based on parsed operator and two numbers.

defmodule Calculator do
  def calc(str) do
    [x, op, y] = String.split(str, ~r{(\+|-|\*|\/)}, include_captures: true)
    x = String.to_integer(x)
    y = String.to_integer(y)

    case op do
      "+" -> Math.add(x, y)
      "-" -> Math.sub(x, y)
      "*" -> Math.mul(x, y)
      "/" -> Math.div(x, y)
    end
  end
end
