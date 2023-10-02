# Part 1

# Implement a Elixir script that:

# Ask a number from the user.
# If given number is evenly divisible by 3, print Divisible by 3.
# If given number is evenly divisible by 5, print Divisible by 5.
# If given number is evenly divisible by 7, print Divisible by 7.
# If given number is not evenly divisible by 3, 5 or 7, find smallest value
# (excluding 1) that number is evenly divisible for and print that value to the output.

input = IO.gets("Enter a number: ") |> String.trim() |> String.to_integer()

cond do
  rem(input, 3) == 0 ->
    IO.puts("Divisible by 3")

  rem(input, 5) == 0 ->
    IO.puts("Divisible by 5")

  rem(input, 7) == 0 ->
    IO.puts("Divisible by 7")

  true ->
    2..input |> Enum.find(&(rem(input, &1) == 0)) |> (&IO.puts("Divisible by #{&1}")).()
end
