str = "123a456"

defmodule Input do
  def loop do
    input = IO.gets("Enter a calculation: ") |> String.trim()

    try do
      Calculator.calc(input)
      loop()
    rescue
      _ -> IO.puts("not a valid input, exiting")
    end
  end
end

Input.loop()
