defmodule FiveHundred.Bid do
  @derive Jason.Encoder
  defstruct [:name, :suit, :tricks, :points]
  alias FiveHundred.{Bid, Card}

  @type t :: %Bid{
          name: String.t(),
          suit: Card.suit(),
          tricks: integer,
          points: 40..1000
        }

  @type special_bid :: %Bid{
          name: String.t(),
          points: 250 | 500 | 1000,
          suit: :no_trumps,
          tricks: 10
        }

  @spec bids() :: [t()]
  @doc """
  bids/0 returns a list of bids according to the table below:
  | Tricks       | Spades | Clubs | Diamonds | Hearts | No Trumps |
  |:------------:|:------:|:-----:|:--------:|:------:|:---------:|
  | 6 tricks     | 40     | 80    | 120      | 160    | 200       |
  | 7 tricks     | 60     | 120   | 180      | 240    | 300       |
  | 8 tricks     | 80     | 160   | 240      | 320    | 400       |
  | 9 tricks     | 100    | 200   | 300      | 400    | 500       |
  | 10 tricks    | 120    | 240   | 360      | 480    | 600       |
  | Misere       | 250    |       |          |        |           |
  | Open Misere  | 500    |       |          |        |           |
  | Blind Misere | 1000   |       |          |        |           |
  """
  def bids(), do: List.flatten(standard_bids(), special_bids())

  @spec standard_bids() :: [t()]
  defp standard_bids() do
    suits =
      Card.suits()
      |> Enum.reverse()
      |> Enum.with_index()

    base_points = [40, 60, 80, 100, 120] |> Enum.with_index()

    for {points, point_index} <- base_points, {suit, suit_index} <- suits do
      tricks = point_index + 6

      %Bid{
        name: "#{tricks} #{Atom.to_string(suit)}",
        suit: suit,
        tricks: tricks,
        points: points * (suit_index + 1)
      }
    end
  end

  @spec special_bids() :: [special_bid()]
  defp special_bids(),
    do: [
      %Bid{
        name: "Misère",
        suit: :no_trumps,
        tricks: 10,
        points: 250
      },
      %Bid{
        name: "Open Misère",
        suit: :no_trumps,
        tricks: 10,
        points: 500
      },
      %Bid{
        name: "Blind Misère",
        suit: :no_trumps,
        tricks: 10,
        points: 1000
      }
    ]

  @spec compare(t(), t()) :: :lt | :gt | :eq
  def compare(a, b) do
    cond do
      a.points < b.points -> :lt
      a.points > b.points -> :gt
      a.points == b.points -> :eq
    end
  end

  @spec sort_by_points([t()]) :: [t()]
  def sort_by_points(list), do: Enum.sort(list, &point_comparator/2)

  @spec point_comparator(t(), t()) :: boolean
  defp point_comparator(ax, bx), do: ax.points >= bx.points
end
