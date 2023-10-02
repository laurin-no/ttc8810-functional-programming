# Part 1
# Declare a keyword list that contains name of the color and color html value.
# See html color values here
# Add at least 10 colors to the keyword list
# Create a loop that asks user the color name or color html value.
# If entered text begins with '#', print the corresponding color name.
# Otherwise print the corresponding html color value.
# If neither is found in keyword list, exit the loop.

defmodule ColorChecker do
  def loop do
    keyword = [
      red: "#FF0000",
      green: "#00FF00",
      blue: "#0000FF",
      yellow: "#FFFF00",
      cyan: "#00FFFF",
      magenta: "#FF00FF",
      black: "#000000",
      white: "#FFFFFF",
      gray: "#808080",
      maroon: "#800000"
    ]

    input = IO.gets("Enter a color name or color html value: ") |> String.trim()

    color =
      cond do
        String.starts_with?(input, "#") ->
          keyword
          |> Enum.find(fn {_, v} -> v == input end)
          |> case do
            {k, _} -> k
            _ -> nil
          end

        true ->
          keyword
          |> Enum.find(fn {k, _} -> k == String.to_atom(input) end)
          |> case do
            {_, v} -> v
            _ -> nil
          end
      end

    if color do
      IO.puts("Color: #{color}")
      loop()
    else
      IO.puts("No color found")
    end
  end
end

ColorChecker.loop()
