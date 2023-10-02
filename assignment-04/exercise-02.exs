# **Part 2**
# - Declare a map that contains book ISBN as a key and book name as a value.
#     - Add at least 5 books into the map
# - Create a loop that reads commands from the user:
#     - **list** lists all books in the map.
#     - **search ISBN** searches a book with specified ISBN and prints book info.
#     - **add ISBN,NAME** adds new book into the map.
#     - **remove ISBN** removes book with ISBN if found on map.
#     - **quit** exits the loop.

defmodule BookChecker do
  def loop(books) do
    input = IO.gets("Enter a command: ") |> String.trim()

    case String.split(input, " ", parts: 2) do
      ["list"] ->
        books
        |> Enum.each(fn {k, v} -> IO.puts("#{k} - #{v}") end)

        loop(books)

      ["search", isbn] ->
        case Map.get(books, isbn) do
          nil -> IO.puts("Book not found")
          name -> IO.puts("Book: #{name}")
        end

        loop(books)

      ["add", book] ->
        case String.split(book, ",") do
          [isbn, name] ->
            books = Map.put(books, isbn, name)
            IO.puts("Book added")
            loop(books)

          _ ->
            IO.puts("Invalid book")
            loop(books)
        end

      ["remove", isbn] ->
        books = Map.delete(books, isbn)
        IO.puts("Book removed")
        loop(books)

      ["quit"] ->
        IO.puts("Bye!")
        :ok

      _ ->
        IO.puts("Unknown command")
        loop(books)
    end
  end
end

books = %{
  "978-1-56619-909-4" => "The Little Elixir & OTP Guidebook",
  "978-1-4919-1576-9" => "Programming Phoenix",
  "978-1-68050-220-8" => "Programming Ecto",
  "978-1-68050-252-9" => "Craft GraphQL APIs in Elixir with Absinthe",
  "978-1-68050-253-9" => "Metaprogramming Elixir"
}

BookChecker.loop(books)
