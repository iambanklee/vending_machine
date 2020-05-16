class VendingMachine
  attr_reader :item_inventory, :change_inventory, :inserted_money

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

  def initialize(item, change)
    @item_inventory = JSON.parse(item)
    @change_inventory = JSON.parse(change)
    @inserted_money = 0
    @order_price = 0
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
    product = item_inventory[name]
    @order_price += product['price']
  end

  def insert_money(coin)
    @inserted_money += CHANGE_DENOMINATION_MAP[coin]
  end

  def outstanding_money
    @order_price - @inserted_money
  end
end