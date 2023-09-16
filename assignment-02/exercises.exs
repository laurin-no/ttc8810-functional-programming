# Part 1
# Write an Elixir script that calculates how many words are in string "99 bottles of beer on the wall".

IO.puts("Part 1")
str = "99 bottles of beer on the wall"
count = String.split(str, " ") |> length

IO.puts("Number of words: #{count}")

# Part 2
# Given a phrase "Pattern Matching with Elixir. Remember that equals sign is a match operator, not an assignment"., translate it a word at a time to Pig Latin.

# Words beginning with consonants should have the consonant moved to the end of the word, followed by "ay".
# Words beginning with vowels (aeiou) should have "ay" added to the end of the word.
# Some groups of letters are treated like consonants, including "ch", "qu", "squ", "th", "thr", and "sch".
# Some groups are treated like vowels, including "yt" and "xr".

phrase =
  "Pattern Matching with Elixir. Remember that equals sign is a match operator, not an assignment"

IO.puts("Part 2")

mapWord = fn word ->
  case word do
    ["q", "u" | t] -> t ++ ["quay"]
    ["s", "q", "u" | t] -> t ++ ["squay"]
    ["t", "h" | t] -> t ++ ["thay"]
    ["t", "h", "r" | t] -> t ++ ["thray"]
    ["s", "c", "h" | t] -> t ++ ["schay"]
    ["c", "h" | t] -> t ++ ["chay"]
    ["y", "t" | _] -> word ++ ["ay"]
    ["x", "r" | _] -> word ++ ["ay"]
    [h | _] when h in ~w(a e i o u) -> word ++ ["ay"]
    [h | t] -> t ++ [h, "ay"]
  end
end

res =
  phrase
  |> String.split(" ")
  |> Enum.map(&String.graphemes(&1))
  |> Enum.map(&mapWord.(&1))
  |> Enum.join(" ")

IO.puts(res)
