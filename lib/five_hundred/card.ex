defmodule FiveHundred.Card do
  @doc """
  Models a card from a standard 53 card deck
  """

  @derive Jason.Encoder
  defstruct [:rank, :suit]
  alias FiveHundred.Card

  @type t :: %Card{rank: rank, suit: suit}
  @type suit :: :hearts | :diamonds | :clubs | :spades | :joker
  @type rank :: 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15

  @spec suits() :: [{suit, integer}]
  def suits(),
    do:
      [:hearts, :diamonds, :clubs, :spades]
      |> Enum.reverse()
      |> Enum.with_index()

  @spec ranks() :: [rank]
  def ranks(), do: Enum.to_list(2..14)

  @spec joker() :: %Card{rank: rank, suit: suit}
  def joker(), do: %Card{rank: 15, suit: :joker}
end
