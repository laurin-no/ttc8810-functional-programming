# Part 2

# Write an anonymous function that takes two parameters:

# Use a guard to check if both parameters are a string type. If so, return a combined string of the parameters.
# If parameters are not strings, return the addition result of the parameters.
# Test your anonymous function with string and number parameters and print the results.

check = fn
  a, b when is_binary(a) and is_binary(b) -> a <> b
  a, b -> a + b
end

IO.puts(check.("Hello", "World"))
IO.puts(check.(1, 2))
