class Inventory
  attr_reader :items

  def initialize
    @items = {}
  end

  def add(name:, stock:)
    items[name] ||= 0
    items[name] += stock
  end

  def stock_of(name)
    items[name]
  end

  def reload_stock(list)
    JSON.parse(list).each { |name, stock| add(name: name, stock: stock) }
    items.select { |name, _stock| list[name] }
  end
end