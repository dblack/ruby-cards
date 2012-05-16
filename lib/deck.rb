module PlayingCards
  class Deck
    def initialize
      @cards = []
      Card::SUITS.each do |suit|
        Card::RANKS.each do |rank|
          card = Card.new(rank, suit)
          @cards.push(card)
        end
      end
      @cards.shuffle!
    end

    def combination(n)
      @cards.combination(n)
    end

    def size
      @cards.size
    end

    def deal(n=1)
      hand = []
      n.times do |i|
        card = @cards.pop
        yield card if block_given?
        hand << card
      end
      hand
    end
  end
end
