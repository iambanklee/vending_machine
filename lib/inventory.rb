# frozen_string_literal: true

class Inventory
  attr_reader :items

  def initialize
    @items = {}
  end

  def increase(name:, stock:)
    items[name] ||= 0
    items[name] += stock
  end

  def decrease(name:, stock:)
    items[name] ||= 0
    items[name] -= stock
  end

  def stock_of(name)
    items[name]
  end

  def reload_stock(list)
    JSON.parse(list).each { |name, stock| increase(name: name, stock: stock) }
    items.select { |name, _stock| list[name] }
  end
end
