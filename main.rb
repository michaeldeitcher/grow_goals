require "tty-markdown"
require "tty-prompt"
require "./game.rb"

welcome_str = %Q(
#Welcome to Plant Nurturer
Feed, Light, and Water your challenge plant to achieve it's fastest growth.

)

puts `clear`
puts TTY::Markdown.parse(welcome_str)

begin
  game_won = false
  game = Game.new
  current_plant = game.initial_plant

  while current_plant
    current_plant = game.play_level current_plant
  end
rescue TTY::Reader::InputInterrupt
  puts ''
end
