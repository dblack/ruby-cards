require './playing_cards.rb'
  def hand_from(*specs)
    PlayingCards::Hand.new(specs.each_slice(2).map {|r,s| PlayingCards::Card.new(r,s)})
  end
  hand = hand_from("2", "spades", "3", "clubs", "4", "diamonds",
                                             "5", "hearts", "Q", "clubs")

  beats = loses = 0
  deck = PlayingCards::Deck.new
  deck.combination(5).each.with_index do |five, index|
    puts index if index % 1000 == 0
    if PlayingCards::Hand.new(five).beats?(hand)
      beats += 1
    else
      loses += 1
    end
  end
  p "Beaten by #{beats}; beat #{loses}"

  # "Beaten by 2134860; beat 464100"
