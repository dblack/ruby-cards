require 'minitest/autorun'
require_relative 'playing_cards'

class CardTest < MiniTest::Unit::TestCase
  def test_initialization
    card = PlayingCards::Card.new("2", "spades")
    assert_equal("2", card.rank)
    assert_equal("spades", card.suit)
  end

  def test_initializing_invalid_card_raises_exception
    assert_raises(PlayingCards::Card::InvalidCardError) do
      PlayingCards::Card.new("blah", "things")
    end
  end

  def test_int_gets_saved_as_string
    card = PlayingCards::Card.new(2, "spades")
    assert_equal("2", card.rank)
  end

  def test_card_comparison
    king = PlayingCards::Card.new("K", "clubs")
    ten = PlayingCards::Card.new(10, "diamonds")
    assert(king > ten)
  end

  def test_card_equality
    king1 = PlayingCards::Card.new("K", "clubs")
    king2 = PlayingCards::Card.new("K", "spades")
    assert(king1 == king2)
  end

  def test_invalid_rank
    assert_raises(PlayingCards::Card::InvalidCardError) {
      PlayingCards::Card.new("blah", "diamonds")
    }
  end

  def test_invalid_suit
    assert_raises(PlayingCards::Card::InvalidCardError) {
      PlayingCards::Card.new("J", "things")
    }
  end
end

class HandTest < MiniTest::Unit::TestCase
  def test_pair
    hand = hand_from("2", "spades", "2", "clubs", "3", "diamonds",
                     "5", "hearts", "J", "clubs")
    assert(hand.is_pair?)
    assert_equal("pair", hand.hand_name)
  end

  def test_two_pair
    hand = hand_from("2", "spades", "2", "clubs", "3", "diamonds",
                     "3", "hearts", "J", "clubs")
    assert(hand.is_two_pair?)
    assert_equal("two pair", hand.hand_name)
  end

  def test_high_card
    hand = hand_from("2", "spades", "K", "clubs", "8", "diamonds",
                     "3", "hearts", "J", "clubs")
    assert(hand.is_high_card?)
    assert_equal("high card", hand.hand_name)
  end

  def test_three_of_a_kind
    hand = hand_from("2", "spades", "2", "clubs", "3", "diamonds",
                     "5", "hearts", "2", "hearts")
    assert(hand.is_three_of_a_kind?)
    assert_equal("three of a kind", hand.hand_name)
  end

  def test_full_house
    hand = hand_from("2", "spades", "2", "clubs", "3", "diamonds",
                     "3", "hearts", "2", "hearts")
    assert(hand.is_full_house?)
    assert_equal("full house", hand.hand_name)
  end 

  def test_four_of_a_kind
    hand = hand_from("3", "spades", "3", "clubs", "3", "diamonds",
                     "3", "hearts", "2", "hearts")
    assert(hand.is_four_of_a_kind?)
    assert_equal("four of a kind", hand.hand_name)
  end

  def test_flush
    hand = hand_from("3", "spades", "4", "spades", "J", "spades",
                     "6", "spades", "K", "spades")
    assert(hand.is_flush?)
    assert_equal("flush", hand.hand_name)
  end

  def test_straight
    hand = hand_from("2", "spades", "3", "clubs", "4", "diamonds",
                     "5", "hearts", "6", "clubs")
    assert(hand.is_straight?)
    assert_equal("straight", hand.hand_name)
  end

  def test_straight_flush
    hand = hand_from("2", "spades", "3", "spades", "4", "spades",
                     "5", "spades", "6", "spades")
    assert(hand.is_straight_flush?)
    assert_equal("straight flush", hand.hand_name)
  end

  def test_royal_straight_flush
    hand = hand_from("10", "clubs", "J", "clubs", "Q", "clubs",
                     "K", "clubs", "A", "clubs")
    assert(hand.is_royal_straight_flush?)
    assert_equal("royal straight flush", hand.hand_name)
  end

  def test_sort
    hand1 = hand_from("2", "spades", "3", "clubs", "4", "diamonds",
                      "5", "hearts", "6", "clubs")
    hand2 = hand_from("2", "spades", "3", "clubs", "4", "diamonds",
                      "5", "hearts", "2", "clubs")
    hand3 = hand_from("2", "spades", "2", "clubs", "3", "diamonds",
                      "3", "hearts", "2", "hearts")
    assert_equal([hand2, hand1, hand3], [hand1, hand2, hand3].sort)
  end

  def test_get_high_card
    hand = hand_from("2", "spades", "K", "clubs", "8", "diamonds",
                     "3", "hearts", "J", "clubs")
    assert_equal(PlayingCards::Card.new("K", "clubs"), hand.high_card)
  end
  
  def test_beats_high_card
    hand1 = hand_from("2", "spades", "K", "clubs", "8", "diamonds",
                      "3", "hearts", "J", "clubs")
    hand2 = hand_from("2", "spades", "10", "clubs", "8", "diamonds",
                      "3", "hearts", "J", "clubs")
    assert(hand1.beats?(hand2))
  end

  def test_beats_pair
    hand1 = hand_from("2", "spades", "2", "clubs", "8", "diamonds",
                      "3", "hearts", "J", "clubs")
    hand2 = hand_from("10", "spades", "10", "clubs", "8", "diamonds",
                      "3", "hearts", "J", "clubs")
    assert(hand2.beats?(hand1))
  end

  def test_beats_pair_with_kicker
    hand1 = hand_from("2", "spades", "2", "clubs", "8", "diamonds",
                      "3", "hearts", "J", "clubs")
    hand2 = hand_from("2", "spades", "2", "clubs", "9", "diamonds",
                      "3", "hearts", "J", "clubs")
    assert(hand2.beats?(hand1))
  end

  def test_beats_two_pair
    hand1 = hand_from("2", "spades", "2", "clubs", "8", "diamonds",
                      "8", "hearts", "J", "clubs")
    hand2 = hand_from("2", "diamonds", "2", "hearts", "9", "diamonds",
                      "9", "hearts", "J", "clubs")
    assert(hand2.beats?(hand1))
  end

  def test_beats_two_pair_with_kicker
    hand1 = hand_from("2", "spades", "2", "clubs", "8", "diamonds",
                      "8", "hearts", "3", "clubs")
    hand2 = hand_from("2", "diamonds", "2", "hearts", "8", "diamonds",
                      "8", "hearts", "5", "clubs")
    assert(hand2.beats?(hand1))
  end

  def test_beats_three_of_a_kind
    hand1 = hand_from("2", "spades", "2", "clubs", "2", "diamonds",
                      "8", "hearts", "J", "clubs")
    hand2 = hand_from("5", "diamonds", "5", "hearts", "5", "diamonds",
                      "9", "hearts", "J", "clubs")
    assert(hand2.beats?(hand1))  
  end

  def test_beats_straight
    hand1 = hand_from("2", "spades", "3", "clubs", "4", "diamonds",
                      "5", "hearts", "6", "clubs")
    hand2 = hand_from("5", "diamonds", "6", "hearts", "7", "clubs",
                      "8", "spades", "9", "clubs")
    assert(hand2.beats?(hand1))  
  end

  def test_beats_flush
    hand1 = hand_from("3", "spades", "4", "spades", "J", "spades",
                     "6", "spades", "K", "spades")
    hand2 = hand_from("3", "spades", "4", "spades", "J", "spades",
                                      "6", "spades", "A", "spades")
    assert(hand2.beats?(hand1))
  end

  def test_beats_full_house
    hand1 = hand_from("2", "spades", "2", "clubs", "3", "diamonds",
                     "3", "hearts", "2", "hearts")
    hand2 = hand_from("4", "spades", "4", "clubs", "3", "diamonds",
                                      "3", "hearts", "4", "hearts")
    assert(hand2.beats?(hand1))
  end

  def test_beats_four_of_a_kind
    hand1 = hand_from("2", "spades", "2", "clubs", "2", "diamonds",
                      "2", "hearts", "J", "clubs")
    hand2 = hand_from("5", "diamonds", "5", "hearts", "5", "clubs",
                      "5", "spades", "J", "clubs")
    assert(hand2.beats?(hand1))  
  end

  def test_beats_straight_flush
    hand1 = hand_from("3", "spades", "4", "spades", "5", "spades",
                     "6", "spades", "7", "spades")
    hand2 = hand_from("5", "spades", "4", "spades", "7", "spades",
                                      "6", "spades", "8", "spades")
    assert(hand2.beats?(hand1))
  end
  
  def test_ties_high_card
    hand = hand_from("2", "spades", "K", "clubs", "8", "diamonds",
                      "3", "hearts", "J", "clubs")
    assert(hand.ties?(hand))
  end

  def test_ties_pair
    hand = hand_from("2", "spades", "2", "clubs", "8", "diamonds",
                      "3", "hearts", "J", "clubs")
    assert(hand.ties?(hand))
  end

  def test_ties_two_pair
    hand = hand_from("2", "spades", "2", "clubs", "8", "diamonds",
                      "8", "hearts", "J", "clubs")
    assert(hand.ties?(hand))
  end

  def test_ties_three_of_a_kind
    hand = hand_from("5", "diamonds", "5", "hearts", "5", "diamonds",
                      "9", "hearts", "J", "clubs")
    assert(hand.ties?(hand))  
  end

  def test_ties_straight
    hand = hand_from("5", "diamonds", "6", "hearts", "7", "clubs",
                      "8", "spades", "9", "clubs")
    assert(hand.ties?(hand))
  end

  def test_ties_flush
    hand = hand_from("3", "spades", "4", "spades", "J", "spades",
                     "6", "spades", "K", "spades")
    assert(hand.ties?(hand))
  end

  def test_ties_full_house
    hand1 = hand_from("2", "spades", "2", "clubs", "3", "diamonds",
                     "3", "hearts", "2", "hearts")
    assert(hand1.ties?(hand1))
  end

  def test_beats_four_of_a_kind
    hand = hand_from("2", "spades", "2", "clubs", "2", "diamonds",
                      "2", "hearts", "J", "clubs")
    assert(hand.ties?(hand))
  end

  def test_ties_straight_flush
    hand1 = hand_from("3", "spades", "4", "spades", "5", "spades",
                     "6", "spades", "7", "spades")
    assert(hand1.ties?(hand1))
  end
  
  def test_ties_royal_straight_flush
    hand1 = hand_from("10", "clubs", "J", "clubs", "Q", "clubs",
                       "K", "clubs", "A", "clubs")
    hand2 = hand_from("10", "hearts", "J", "hearts", "Q", "hearts",
                      "K", "hearts", "A", "hearts")
    assert(hand1.ties?(hand2))
  end
  
  def hand_from(*specs)
    PlayingCards::Hand.new(specs.each_slice(2).map {|r,s| PlayingCards::Card.new(r,s)})
  end

end
