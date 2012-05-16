require 'minitest/autorun'
require_relative 'playing_card'

describe PlayingCard do
  describe "when initialized" do
    it "must set its suit and rank" do
      two = PlayingCard.new("2", "spades")
      two.rank.must_equal("2")
      two.suit.must_equal("spades")
    end

    it "should convert integer to string rank" do
      two = PlayingCard.new(2, "spades")
      two.rank.must_equal("2")
    end 
  end

  describe "when compared with another card" do
    it "should evaluate king higher than ten" do
      king = PlayingCard.new("K", "clubs")
      ten = PlayingCard.new(10, "diamonds")
      assert(king > ten)
    end

    it "should equate two kings" do
      king1 = PlayingCard.new("K", "clubs")
      king2 = PlayingCard.new("K", "spades")
      king1.must_equal(king2)
    end
  end
end
