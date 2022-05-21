require_relative '../views/meals_view'

class MealsController
  def initialize(meal_repository)
    @meal_repository = meal_repository
    @view = MealsView.new
  end

  def add
    # 1. Perguntar o nome do meal
    name = @view.ask_name

    # 2. Perguntar o preço do meal
    price = @view.ask_price

    # 3. Criar uma instância desse meal
    meal = Meal.new(name: name, price: price)

    # 4. Armazenar a instância do meal no repositório
    @meal_repository.create(meal)
  end

  def list
    # 1. Pegar todos os meals do repositório
    meals = @meal_repository.all

    # 2. Mandar os meals para a view exibir
    @view.list(meals)

  end
end
