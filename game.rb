require "tty-markdown"
require "tty-prompt"
require './plants/plant.rb'

def putmarkdown s
  puts TTY::Markdown.parse s.to_s
end

class Game
  @@plants = [Hibiscus, SpiderPlant]

  def initialize
    @current_plant_index = 0
  end

  def play
    @@plants.each {|plant| play_level plant}
  end

  def initial_plant
    @@plants[@current_plant_index]
  end

  def play_level plant_class
    current_plant = @@plants[@current_plant_index]
    plant_growth_achieved = false
    while !plant_growth_achieved
      plant_growth_achieved = Level.new.play current_plant
      break unless TTY::Prompt.new.yes?('Would you like to try again?') unless plant_growth_achieved
    end
    # TODO - stop game if No
    @current_plant_index += 1
    @@plants[@current_plant_index]
  end
end

class Level
  def initialize
    @days = 0
    @dosage = nil
  end

  def play plant_class
    @plant = plant_class.new

    # Day loop
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