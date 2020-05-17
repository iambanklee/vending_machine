require 'product'
require 'inventory'

class VendingMachine
  attr_reader :products, :inventory

  CHANGE_DENOMINATION_MAP = {
    '£2' => 200,
    '£1' => 100,
    '50p' => 50,
    '20p' => 20,
    '10p' => 10,
    '5p' => 5,
    '2p' => 2,
    '1p' => 1,
  }

  def initialize(items, change)
    initialize_product(items)
    initialize_inventory(items, change)

    @inserted_amount = 0
    @selected_item_amount = 0
  end

  def purchase(item_name)
    select_item(item_name)

    while outstanding_money > 0
      coin = Kernel.gets.chomp
      insert_money(coin)
    end

    item_name
  end

  def return_changes(amount)
    result = []

    CHANGE_DENOMINATION_MAP.each do |denomination, pence|
      next if pence > amount
      while amount > 0
        result << denomination
        amount -= pence
        break if pence > amount
      end
    end

    result
  end

  def select_item(name)
    product = products[name]
    @selected_item_amount += product.price
  end

  def insert_money(coin)
    @inserted_amount += CHANGE_DENOMINATION_MAP[coin]
  end

  def outstanding_money
    @selected_item_amount - @inserted_amount
  end

  private

  def initialize_product(items)
    @products = {}

    JSON.parse(items).each do |name, attributes|
      @products[name] = Product.new(name, attributes['price'])
    end
  end

  def initialize_inventory(items, change)
    @inventory = Inventory.new

    JSON.parse(items).each do |name, attributes|
      @inventory.add(name: name, stock: attributes['stock'])
    end

    @inventory.reload_stock(change)
  end
end