# Implement a game of Blackjack against computer.

# Create two processes of player and dealer.
# Use inter-process communication to handle all aspects of the game between player and dealer.
# No need to implement betting, each game results of win or loss for the player.
# No need to implement hidden cards, assume that player and dealer cards are visible.
# Allow option to play again.

defmodule Game do
  def start() do
    parent = self()

    player = spawn_link(fn -> Player.start() end)
    dealer = spawn_link(fn -> Dealer.start(parent) end)

    send(dealer, {:start, player})

    receive do
      :bye ->
        IO.puts("Shutting down game. Bye!")

      _ ->
        "Unknown command for parent"
    end
  end
end

defmodule Player do
  def start do
    loop()
  end

  defp loop() do
    receive do
      {:deal, dealer, player_hand, house_hand} ->
        IO.puts("Player dealt hand: #{inspect(player_hand)} (#{Hand.sum_value(player_hand)}))")
        IO.puts("House hand: #{inspect(house_hand)} (#{Hand.sum_value(house_hand)}))")

        suggested_descision = make_decision(player_hand, house_hand)
        IO.puts("Suggested decision: #{suggested_descision}")

        action = ask_decision()
        IO.puts("Player action: #{action}")

        send(dealer, {action, self()})
        loop()

      {:bust, dealer} ->
        IO.puts("Player busts :(")
        play_again?(dealer)

      {:win, dealer} ->
        IO.puts("Player wins :)")
        play_again?(dealer)

      {:lose, dealer} ->
        IO.puts("Player loses :(")
        play_again?(dealer)

      _ ->
        IO.puts("Unknown command")
        start()
    end
  end

  defp make_decision(player_hand, house_hand) do
    player_sum = Hand.sum_value(player_hand)
    house_sum = Hand.sum_value(house_hand)

    cond do
      player_sum >= 17 -> :stand
      player_sum < 12 -> :hit
      player_sum == 12 and house_sum in 4..6 -> :hit
      player_sum in 13..16 and house_sum in 2..6 -> :stand
      true -> :hit
    end
  end

  defp ask_decision() do
    case IO.gets("Hit or stand? (h/s): ") |> String.trim() do
      "h" -> :hit
      "s" -> :stand
      _ -> ask_decision()
    end
  end

  defp play_again?(dealer) do
    again = IO.gets("Play again? (y/n): ") |> String.trim() == "y"

    IO.puts("\n\n\n")

    if again do
      send(dealer, {:start, self()})
      loop()
    else
      IO.puts("Player had enough. Bye!")
      send(dealer, :bye)
      :ok
    end
  end
end

defmodule Dealer do
  def start(parent) do
    deck = Deck.new() |> Deck.shuffle()
    loop(parent, deck)
  end

  defp loop(parent, deck, player_hand \\ Nil, house_hand \\ Nil) do
    receive do
      {:start, player} ->
        IO.puts("Dealer starting with player #{inspect(player)}")

        {player_hand, deck} = Deck.deal_two(deck)
        {house_hand, deck} = Deck.deal(deck)

        IO.puts("Player hand: #{inspect(player_hand)}")
        IO.puts("House hand: #{inspect(house_hand)}")

        send(player, {:deal, self(), player_hand, house_hand})
        loop(parent, deck, player_hand, house_hand)

      {:hit, player} ->
        IO.puts("Player hits.")
        {card, deck} = Deck.deal(deck)
        IO.puts("Player dealt #{inspect(card)}")

        player_hand = player_hand ++ card

        IO.puts("Player hand: #{inspect(player_hand)}")

        if Hand.sum_value(player_hand) > 21 do
          IO.puts("Player busts")
          send(player, {:bust, self()})

          start(parent)
        else
          IO.puts("Player hand: #{inspect(player_hand)}")
          send(player, {:deal, self(), player_hand, house_hand})
          loop(parent, deck, player_hand, house_hand)
        end

      {:stand, player} ->
        IO.puts("Player stands.")

        house_hand = deal_house(deck, house_hand)
        house_hand_value = Hand.sum_value(house_hand)

        IO.puts("House draws hand: #{inspect(house_hand)} (#{house_hand_value})")

        cond do
          house_hand_value > 21 ->
            IO.puts("House busts")
            send(player, {:win, self()})
            start(parent)

          house_hand_value > Hand.sum_value(player_hand) ->
            IO.puts("House wins")
            send(player, {:lose, self()})
            start(parent)

          true ->
            IO.puts("Player wins")
            send(player, {:win, self()})
            start(parent)
        end

      :bye ->
        IO.puts("Dealer calling it a day. Bye!")
        send(parent, :bye)
        :ok

      _ ->
        IO.puts("Unknown command")
    end
  end

  defp deal_house(deck, house_hand) do
    if Hand.sum_value(house_hand) < 17 do
      {card, deck} = Deck.deal(deck)
      house_hand = house_hand ++ card
      deal_house(deck, house_hand)
    else
      house_hand
    end
  end
end

defmodule Deck do
  @suits ["♠", "♥", "♦", "♣"]
  @ranks ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

  def new do
    for suit <- @suits, rank <- @ranks, do: {rank, suit}
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def deal([card | deck]) do
    {[card], deck}
  end

  def deal_two([card1 | [card2 | deck]]) do
    {[card1, card2], deck}
  end
end

defmodule Hand do
  def is_face_card({value, _}), do: String.contains?("JQK", value)

  def sum_value(hand) do
    sum_value(hand, 0)
  end

  def sum_value([], acc) do
    acc
  end

  def sum_value([head | tail], acc) do
    face_card = Hand.is_face_card(head)

    # TODO Aces are actually not handled correctly
    case head do
      {"A", _} when acc > 10 ->
        sum_value(tail, 1 + acc)

      {"A", _} when acc <= 10 ->
        sum_value(tail, 11 + acc)

      _ when face_card ->
        sum_value(tail, 10 + acc)

      _ ->
        sum_value(tail, String.to_integer(elem(head, 0)) + acc)
    end
  end
end

Game.start()
