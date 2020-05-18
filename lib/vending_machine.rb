# frozen_string_literal: true

require 'json'

require_relative 'product'
require_relative 'inventory'

class VendingMachine
  attr_reader :products, :item_inventory, :change_inventory

  CHANGE_DENOMINATION_MAP = {
    '£2' => 200,
    '£1' => 100,
    '50p' => 50,
    '20p' => 20,
    '10p' => 10,
    '5p' => 5,
    '2p' => 2,
    '1p' => 1
  }.freeze

  def initialize(items, change)
    initialize_product(items)
    initialize_inventory(items, change)

    @inserted_amount = 0
    @selected_item_amount = 0
  end

  # This is the main entry point for this implementation
  # It contains lot of puts message to interact with users. remove all puts for better readability
  def purchase(item_name)
    select_item = select_item(item_name)

    puts "You have selected #{select_item.name}, price: #{formatting_price(select_item.price)}"
    while outstanding_amount.positive?
      puts "This machine accepts following coins: #{CHANGE_DENOMINATION_MAP.keys}"
      puts "You need #{formatting_price(outstanding_amount)} to proceed. "
      coin = Kernel.gets.chomp
      if CHANGE_DENOMINATION_MAP[coin]
        puts "You have inserted #{coin}"
        insert_money(coin)
      else
        puts "This machine doesn't accept #{coin}"
      end
    end

    puts "Please collect your #{select_item.name}"

    item_inventory.decrease(name: select_item.name, stock: 1)
    puts "#{select_item.name} now has #{item_inventory.stock_of(select_item.name)} in stock"

    return_change
    reset_amounts

    select_item.name
  end

  def return_change
    if outstanding_amount.negative?
      change_detail = amount_to_change(-outstanding_amount)
      change_detail.each { |change| change_inventory.decrease(name: change, stock: 1) }
      puts "Please remember to collect your change: #{change_detail}"
    end
  end

  def amount_to_change(amount)
    result = []

    CHANGE_DENOMINATION_MAP.each do |denomination, pence|
      next if pence > amount

      while amount.positive?
        result << denomination
        amount -= pence
        break if pence > amount
      end
    end

    result
  end

  private

  def select_item(name)
    product = products[name]
    @selected_item_amount += product.price
    product
  end

  def insert_money(coin)
    @change_inventory.increase(name: coin, stock: 1)
    @inserted_amount += CHANGE_DENOMINATION_MAP[coin]
  end

  def outstanding_amount
    @selected_item_amount - @inserted_amount
  end

  def reset_amounts
    @inserted_amount = 0
    @selected_item_amount = 0
  end

  def initialize_product(items)
    @products = {}

    JSON.parse(items).each do |name, attributes|
      @products[name] = Product.new(name, attributes['price'])
    end
  end

  def initialize_inventory(items, change)
    @item_inventory = Inventory.new

    JSON.parse(items).each do |name, attributes|
      @item_inventory.increase(name: name, stock: attributes['stock'])
    end

    @change_inventory = Inventory.new
    @change_inventory.reload_stock(change)
  end

  def formatting_price(price)
    format('£%.2f', (price / 100.0))
  end
end
