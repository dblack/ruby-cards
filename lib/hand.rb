module PlayingCards
  class Hand

    include Comparable

    HANDS_IN_ORDER = [ 
      "royal straight flush",
      "straight flush",
      "four of a kind",
      "full house",
      "flush",
      "straight",
      "three of a kind",
      "two pair",
      "pair",
      "high card"
    ]

    high_card_proc = proc do |hand1, hand2|
      hand1.high_card <=> hand2.high_card
    end
    
    TIE_BREAKERS = {
      "high card" => high_card_proc,
      "pair" => proc do |hand1, hand2|
        comp = hand1.compare_multiple_card(hand2, 2)
        comp.zero? ? hand1.compare_kickers(hand2) : comp
      end,
      "two pair" => proc do |hand1, hand2|
        pairs1 = hand1.multiple_cards(2).sort
        pairs2 = hand2.multiple_cards(2).sort
        comp = pairs1.last <=> pairs2.last
        comp.zero? ? hand1.compare_kickers(hand2) : comp
      end,
      "straight" => high_card_proc,
      "flush" => high_card_proc,
      "three of a kind" => proc do |hand1, hand2|
        hand1.compare_multiple_card(hand2, 3)
      end,
      "full house" => proc do |hand1, hand2|
        hand1.compare_multiple_card(hand2, 3)
      end,
      "four of a kind" => proc do |hand1, hand2|
        hand1.compare_multiple_card(hand2, 4)
      end,
      "straight flush" => high_card_proc,
      "royal straight flush" => proc { 0 }
    }

    def initialize(cards)
      @cards = cards
    end

    attr_reader :cards
    protected :cards

    def multiple_cards(n)
      cards.select do |card|
        cards.count {|c| c.rank == card.rank } == n
      end
    end

    def compare_multiple_card(other, n)
      self.multiple_cards(n).first <=> other.multiple_cards(n).first
    end

    def kickers
      multiple_cards(1).sort
    end
    
    def compare_kickers(other)
      kickers.each.with_index do |card, i|
        comp = card <=> other.kickers[i]
        return comp unless comp.zero?
      end
      return 0
    end
    
    def hand_name
      HANDS_IN_ORDER.each do |hand_name|
        send("is_#{hand_name.tr(' ', '_')}?") and return hand_name
      end
    end

    def <=>(hand)
      order_comp = HANDS_IN_ORDER.index(hand.hand_name) <=> HANDS_IN_ORDER.index(self.hand_name)
      if order_comp == 0
        TIE_BREAKERS[self.hand_name][self, hand]
      else
        order_comp
      end
    end

    def ties?(hand)
      self == hand
    end
    
    def beats?(hand)
      self > hand
    end

    def distribution
      Hash.new(0).tap do |hist|
        @cards.each do |card|
          hist[card.rank] += 1
        end
      end.values.sort
    end

    def is_royal_straight_flush?
      is_straight_flush? && @cards.sort.first.rank == "10"
    end

    def is_high_card?
      !is_straight? && distribution == [1,1,1,1,1]
    end

    def is_pair?
      distribution == [1,1,1,2]
    end

    def is_two_pair?
      distribution == [1,2,2]
    end

    def is_three_of_a_kind?
      distribution == [1,1,3]
    end

    def is_full_house?
      distribution == [2,3]
    end

    def is_four_of_a_kind?
      distribution == [1,4]
    end

    def is_straight?
      ranks = cards.map(&:rank).uniq.sort_by {|c| Card::RANKS.index(c) }
      !is_pair? && Card::RANKS.index(ranks.last) - Card::RANKS.index(ranks.first) == 4
    end

    def is_flush?
      suit = @cards.first.suit
      @cards.all? {|card| card.suit == suit }
    end

    def is_straight_flush?
      is_straight? && is_flush?
    end

    def high_card
      @cards.sort.last
    end
  end
end

