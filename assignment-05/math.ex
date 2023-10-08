# Declare functions Math.add, Math.sub, Math.mul, and Math.div, each taking two parameters.
# Declare a private function Math.info which prints info from above public functions

# The Math.add calls Math.info which prints "Adding x and y" (x and y the actual parameters to Math.add)
# Use Math.info similarly from sub, mul and div functions.

defmodule Math do
  def add(x, y) do
    info(x, y, "Adding")
    x + y
  end

  def sub(x, y) do
    info(x, y, "Subtracting")
    x - y
  end

  def mul(x, y) do
    info(x, y, "Multiplying")
    x * y
  end

  def div(x, y) do
    info(x, y, "Dividing")
    x / y
  end

  defp info(x, y, op) do
    IO.puts("#{op} #{x} and #{y}")
  end
end
