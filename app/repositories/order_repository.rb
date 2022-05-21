class OrderRepository
  def initialize(csv_file, meal_repository, customer_repository, employee_repository)
    @csv_file = csv_file
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @orders = []
    load_csv if File.exist?(@csv_file)
    @next_id = @orders.empty? ? 1 :@orders.last.id + 1
  end

  def create(order)
    order.id = @next_id
    @orders << order
    save_csv
    @next_id += 1
  end

  def all
    @orders
  end

  def find(id)
    @orders.select { |order| order.id == id }.first
  end

  def undelivered_orders
    @orders.reject { |order| order.delivered? }
  end

  def mark_as_delivered(order)
    order.deliver!
    save_csv
  end


  private

  def load_csv
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|

      id = row[:id].to_i

      meal_id = row[:meal_id].to_i
      meal = @meal_repository.find(meal_id)

      customer_id = row[:customer_id].to_i
      customer = @customer_repository.find(customer_id)

      employee_id = row[:employee_id].to_i
      employee = @employee_repository.find(employee_id)

      delivered = row[:delivered] == 'true'

      order = Order.new(id: id, meal: meal, customer: customer, employee: employee, delivered: delivered)

      @orders << order
    end
  end

  def save_csv
    CSV.open(@csv_file, 'wb', headers: :first_row, header_converters: :symbol) do |csv|
      csv << %i[id meal_id customer_id employee_id delivered]

      @orders.each do |order|
        csv << [order.id, order.meal.id, order.customer.id, order.employee.id, order.delivered?]
      end
    end
  end

end
