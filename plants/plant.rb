class PlantHealth
  attr_accessor :light_protection, :nutrients, :nutrient_protection, :water_protection, :height

  def initialize
    @light_protection = 10
    @nutrient_protection = 10
    @nutrients = 2
    @water_protection = 10
    @height = 0
  end

  def to_s
    %Q(
|Height|Nutrients|Nutrient protection|Light protection|
|------|---------|-------------------|----------------|
|#{@height.truncate 2}|#{@nutrients}|#{@nutrient_protection}|#{@light_protection}|
)
  end

  def alive?
    @light_protection > 0 && @nutrients > 0 && @nutrient_protection > 0
  end

end

class Plant
  attr_reader :health

  def initialize
    @health = PlantHealth.new
    @light_threshold = 0
    @nutrient_threshold = 5
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

    if @nutrient_threshold < nutrients
      @health.nutrient_protection -= (nutrients - @nutrient_threshold)
    end

    return unless @health.alive?

    #replenishment
    if @nutrient_threshold < nutrients
      @health.nutrients = @nutrient_threshold
    else
      @health.nutrients += nutrients
    end

    #growth
    potential_growth = @growth_scalers[:light] * light_hours
    potential_growth *= @growth_scalers[:nutrient] * @health.nutrients
    potential_growth *= @growth_scalers[:water] * water
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
