require "tty-markdown"
require "tty-prompt"
require './plants/plant.rb'

def putmarkdown s
  puts TTY::Markdown.parse s.to_s
end

class Game
  def initialize
    @days = 0
    @dosage = nil
  end

  def play
    @plant = Hibiscus.new

    while @plant.health.alive? && !@plant.acheived_growth_goal?
      @days += 1
      putmarkdown "#Day #{@days}"
      putmarkdown @plant.health
      self.prompt_for_daily_dosage
      @plant.process_day @dosage[:hours], @dosage[:nutrient], @dosage[:water]
    end

    if @plant.acheived_growth_goal?
      putmarkdown "#You have acheived your growth goal in #{@days} days."
    end

    unless @plant.health.alive?
      putmarkdown "#Your plant is dead at #{@days} days."
    end
    @plant.health.alive?
  end

  def prompt_for_daily_dosage
    prompt = TTY::Prompt.new
    @dosage ||= {hours: 0, nutrient: 0, water: 0}

    @dosage[:hours] = prompt.slider 'Light', max: 24, format: "|:slider| %d Hours", default: @dosage[:hours]

    @dosage[:nutrient] = prompt.slider 'Nutrient', max: 10, format: "|:slider| %d Units", default: @dosage[:nutrient]

    @dosage[:water] = prompt.slider 'Water', max: 8, format: "|:slider| %d Oz", default: @dosage[:water]

    @dosage
  end
end