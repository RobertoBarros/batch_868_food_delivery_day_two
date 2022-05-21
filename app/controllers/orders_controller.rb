require_relative '../views/orders_view'

class OrdersController
  def initialize(meal_repository, customer_repository, employee_repository, order_repository)
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @order_repository = order_repository

    @view = OrdersView.new
    @meals_view = MealsView.new
    @customers_view = CustomersView.new
  end

   def add
    # 1. Listar os meals e selecionar um deles
    meals = @meal_repository.all
    @meals_view.list(meals)
    index = @view.ask_index
    meal = meals[index]

    # 2. Listar os customers e selecionar um deles
    customers = @customer_repository.all
    @customers_view.list(customers)
    index = @view.ask_index
    customer = customers[index]

    # 3. Listar os employees do tipo riders e selecionar um deles
    riders = @employee_repository.all_riders
    @view.list_riders(riders)
    index = @view.ask_index
    employee = riders[index]

    # 4. Instanciar uma order
    order = Order.new(meal: meal, customer: customer, employee: employee)

    # 5. Adicionar a order ao repositório
    @order_repository.create(order)
   end

   def list_undelivered_orders
    orders = @order_repository.undelivered_orders
    @view.list(orders)
   end

   def list_my_orders(employee)
    orders = @order_repository.undelivered_orders.select { |order| order.employee.id == employee.id }
    @view.list(orders)

   end

   def mark_as_delivered(employee)
    orders = @order_repository.undelivered_orders.select { |order| order.employee.id == employee.id }
    @view.list(orders)
    index = @view.ask_index
    order = orders[index]

    @order_repository.mark_as_delivered(order)
   end


end
