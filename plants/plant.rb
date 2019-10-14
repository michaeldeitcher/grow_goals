class PlantHealth
  attr_accessor :light_protection, :nutrients, :nutrient_protection, :water_protection, :height

  def initialize
    @light_protection = 10
    @nutrient_protection = 10
    @nutrients = 13
    @water_protection = 10
    @height = 0
  end

  def to_s
    %Q(
Height: #{@height.truncate 2}
Nutrients: #{@nutrients}
Light protection: #{@light_protection}
)
  end

  def alive?
    @light_protection > 0 && @nutrients > 0
  end

end

class Plant
  attr_reader :health

  def initialize
    @health = PlantHealth.new
    @light_threshold = 0
    @growth_scalers = {
        light: 0.1,
        nutrient: 0.1,
        water: 0.1
    }
    @growth_goal = 10
    @nutrient_depletion_per_day = 1
  end

  def process_day light_hours=0, nutrients=0, water=0
    #protection
    if @light_threshold < light_hours
      @health.light_protection -= (light_hours - @light_threshold)
    end

    return unless @health.alive?

    #growth
    potential_growth = @growth_scalers[:light] * light_hours
    potential_growth *= @growth_scalers[:nutrient] * @health.nutrients
    @health.height += potential_growth

    #depletion
    @health.nutrients -= @nutrient_depletion_per_day
    @health.nutrients = 0 if @health.nutrients < 0
  end

  def acheived_growth_goal?
    @health.height >= @growth_goal
  end
end

# low light
class EnglishIvy < Plant
  def initialize
    super
    @light_threshold = 3
  end
end


# medium light
class SpiderPlant < Plant
  def initialize
    super
    @light_threshold = 8
  end
end

# high light
class Hibiscus < Plant
  def initialize
    super
    @light_threshold = 18
  end
end
