require "tty-markdown"
require "tty-prompt"
require "./game.rb"

prompt = TTY::Prompt.new

welcome_str = %Q(
#Welcome to Grow Goals
Find your plant's happy ratio to achieve your grow goals.

)

puts TTY::Markdown.parse(welcome_str)

game_won = false
while !game_won
  game_won = Game.new.play
  break unless prompt.yes?('Would you like to try again?') unless game_won
end