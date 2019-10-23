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
|Height|Nutrients|Nutrient protection|Light protection|Water protection|
|------|---------|-------------------|----------------|----------------|
|#{@height.truncate 2}|#{@nutrients}|#{@nutrient_protection}|#{@light_protection}|#{@water_protection}|
)
  end

  def alive?
    @light_protection > 0 && @nutrients > 0 && @nutrient_protection > 0 && @water_protection > 0
  end

end

class Plant
  attr_reader :health, :species, :success

  def initialize
    @health = PlantHealth.new
    @light_threshold = 0
    @nutrient_threshold = 5
    @water_threshold = 4
    @growth_scalers = {
        light: 0.3,
        nutrient: 0.1,
        water: 0.2
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

    if @water_threshold < water
      @health.water_protection -= (water - @water_threshold)
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
    @species = "Hedera helix English ivy, European ivy, or just ivy"
    @success = "bloomed with an abundance of beautiful purple flowers."
  end

end


# medium light
class SpiderPlant < Plant
  def initialize
    super
    @light_threshold = 8
    @species = "Chlorophytum comosum - Spider Plant"
    @success = "produced a luscious crown of voluminous foliage."
  end
end

# high light
class Hibiscus < Plant
  def initialize
    super
    @light_threshold = 18
    @species = "Hibiscus syriacus - Common Garden Hibiscus"
    @success = "bloomed a vibrant yellow flower."
  end
end
