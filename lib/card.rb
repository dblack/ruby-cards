module PlayingCards
  class Card
    class InvalidCardError < StandardError
    end
  
    include Comparable
  
    SUITS = %w{ hearts diamonds spades clubs }
    RANKS = %w{ 2 3 4 5 6 7 8 9 10 J Q K A }
  
    attr_reader :rank, :suit
  
    def initialize(rank, suit)
      @rank = rank.to_s.upcase
      @suit = suit.downcase
      unless valid?
        raise InvalidCardError
      end
    end
  
    def to_s
      "#{rank} of #{suit}"
    end
  
    def <=>(other_card)
      RANKS.index(self.rank) <=> RANKS.index(other_card.rank)
    end
  
    def valid?
      SUITS.include?(suit) && RANKS.include?(rank)
    end
  end 
end
