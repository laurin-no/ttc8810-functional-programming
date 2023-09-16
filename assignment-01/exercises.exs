# Part 1
# Write an Elixir script that declares a variable and sets its value to 123.
# Print the value of the variable to the console.
# Add code that asks a text line from the user (use IO.gets).
# Add text <- You said that to the text that user entered.
# Print the combined text into the console.

IO.puts("Part 1")

x = 123
IO.puts(x)

text = IO.gets(:stdio, "Enter some text: ")
IO.puts("#{text} <- you said that")

# Part 2
# Write an Elixir script that calculates the result of 154 divided by 78 and prints it to the console.
# Get the result of calculation (step 1) rounded to nearest integer and print it to console.
# Get the result of calculation (step 1) and print only the integer part of it into the console.

IO.puts("Part 2")

res = 154 / 78
IO.puts(res)
IO.puts(round(res))
IO.puts(trunc(res))

# Part 3
# Ask a line of text from the user (use IO.gets).
# Print the number of characters in string that user entered.
# Print the entered text in reverse.
# Replace the word foo in entered text with bar and print resulted string into the console.

IO.puts("Part 3")

textThree = IO.gets("Enter some text: ")
IO.puts("Number of characters: #{String.length(textThree)}")
IO.puts("Reversed text: #{String.reverse(textThree)}")
IO.puts("Replaced text: #{String.replace(textThree, "foo", "bar")}")

# Part 4
# Write an anonymous function that takes three parameters and calculates a product (multiplication) of those three values.
# Ask three numbers from user (use IO.gets and String.to_integer) and pass them to your function created in step 1.
# Print the result to the console.
# Write an anonymous function that concats two lists and returns the result.
# Call the list concat function and print the results.
# Declare a tuple with atoms ok and fail.
# Add new atom canceled and print the combined tuple.

IO.puts("Part 4")

mult = fn a, b, c -> a * b * c end
IO.puts("Enter three numbers: ")
b = String.to_integer(IO.gets("b: ") |> String.trim())
a = String.to_integer(IO.gets("a: ") |> String.trim())
c = String.to_integer(IO.gets("c: ") |> String.trim())
IO.puts("Result: #{mult.(a, b, c)}")

concat = fn a, b -> a ++ b end

list1 = [1, 2, 3]
list2 = [4, 5, 6]

concated = concat.(list1, list2)
IO.inspect(concated, charlists: :as_lists)

tuple = {:ok, :fail}
newTuple = Tuple.append(tuple, :canceled)
IO.inspect(newTuple)
