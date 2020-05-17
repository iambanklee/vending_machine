[![Build Status](https://travis-ci.org/iambanklee/vending_machine.svg?branch=master)](https://travis-ci.org/iambanklee/vending_machine)

# Vending Machine
This is the implementation for the Vending Machine challenge

## Environment
- Ruby 2.7.1
- Bundler 2.1.4

## Installation
```bash
$ git clone https://github.com/iambanklee/vending_machine
$ cd vending_machine
$ bundle install
```

## How to use
This implementation includes a bundle command for easy usage
```bash
$ bundle exec bin/purchase
```

It starts the vending machine and provide one item purchase process for demo purpose.
Following is a preview of buying pre-defined products. All items and change initial stock is 10 in this case.
```bash
$ bundle exec bin/purchase

Welcome!
This machine provides following product: ["Green Tea", "Milk Tea", "Black Tea"]
Please select item from provided list
Black Tea
You have selected Black Tea, price: £0.59
This machine accepts following coins: ["£2", "£1", "50p", "20p", "10p", "5p", "2p", "1p"]
You need £0.59 to proceed.
£2
You have inserted £2
Please collect your Black Tea
Black Tea now has 9 in stock
Please remember to collect your change: ["£1", "20p", "20p", "1p"]
== current item inventory ==
Green Tea has 10 in stock
Milk Tea has 10 in stock
Black Tea has 9 in stock
== current change inventory ==
1p has 9 in stock
2p has 10 in stock
5p has 10 in stock
10p has 10 in stock
20p has 8 in stock
50p has 10 in stock
£1 has 9 in stock
£2 has 10 in stock
```

You can also reload the either products or change. For example:
```ruby
# Assume you already have an vending machine instance
# Reload product
products_to_reload = {
  'Green Tea' => 5
}

vending_machine.item_inventory.reload_stock(products_to_reload)

# Reload change
change_to_reload = {
  '50p' => 100
}

vending_machine.change_inventory.reload_stock(change_to_reload)

```

## Tests
RSpec with 100% test coverage

## Implemation approaches
I used a mix of DDD/BDD/TDD approaches as the requirements seems clear but include no expecting input and output examples nor format.

### Early stage - making a PoC/MVP
As the is no expected format for inputs to , I decided to use JSON as it's quite common and easy to use.
```ruby
# Example for items JSON - key as product name with nested JSON as item attributes, which similar to real-world cases
items = {
  "Green Tea" => {"price"=>70, "stock"=>10}, 
  "Milk Tea" => {"price"=>99, "stock"=>10},
  "Black Tea"=> {"price"=>59, "stock"=>10}
}

# Example for change JSON - key as denomitation and value presents its stock
changes = {"1p"=>10, "2p"=>10, "5p"=>10, "10p"=>10, "20p"=>10, "50p"=>10, "£1"=>10, "£2"=>10}
```

1. Implement each functions as basic as possible and make it work (with passed tests) to fit the requirements
2. Once it works, implement next function, rather than refactoring as most of TDD guide told you to do so
3. Repeat step 2 until all requirements are fit, so we know we have a PoC/MVP.
4. Minimun OOD at this stage as we are still exploring domain objects and its interfaces

### Middle stage - Refactoring with proper OOP
1. After reviewing the PoC, I though there were few domain object/class candidates: product, inventory and potentially change
2. Started with product and inventory, they looked similar but decided to sepepate them in 2 classes as they presents different domain. Product is basically only holding data but Inventory has some operations, which might change in the future, depending on business requirements.
3. Decided not to implement change class as there was not enough requirements around it
4. Started refactoring, extracted functions to classes.
5. Replaced original functions with new classes and made sure all tests are still pass

### Final stage - fine tune and tweaks
1. Renamed method/classes to be more accurate based on my understanding to the problem domain
2. Implemented runnable bundle command and fine tune the output message format
3. Some clean up

## Potential improvements



