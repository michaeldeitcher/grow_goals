require "tty-markdown"
require "tty-prompt"
require "./game.rb"

welcome_str = %Q(
#Welcome to Grow Goals
Find your plant's happy ratio to achieve your grow goals.

)

puts TTY::Markdown.parse(welcome_str)

game_won = false
game = Game.new
current_plant = game.initial_plant

while current_plant
  current_plant = game.play_level current_plant
end
