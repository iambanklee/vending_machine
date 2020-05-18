# Vending Machine
1. This is the implementation for the Vending Machine challenge.
2. I chose option 2 solving this challenge. Spent around 5 hours in total, most of time in formatting output messages :S
3. README took similar time to complete...

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
50p
You have inserted 50p
This machine accepts following coins: ["£2", "£1", "50p", "20p", "10p", "5p", "2p", "1p"]
You need £0.09 to proceed.
50p
You have inserted 50p
Please collect your Black Tea
Black Tea now has 9 in stock
Please remember to collect your change: ["20p", "20p", "1p"]
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
50p has 12 in stock
£1 has 10 in stock
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

## Implementation approaches
I used a mix of DDD/BDD/TDD approaches as the requirements seems clear but include no expecting input and output examples nor format.

### Implementation ideas
1. The base money unit of the implementation is British pence. e.g a product price £1.55 is 155. By doing this it:
	- simplifies the calculation
	- keep a flexibility to convert to other currency if need (given a converting rate provided or using online service like OpenExchangeRates API)
2. As the is no format defined for inputs (product and change list) , I decided to use JSON as it's common and easy to use, store and interchange with others
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

### Early stage - making a PoC/MVP
1. Minimum OOD at this stage as we are still exploring domain objects and its interfaces
2. Implement each functions as basic as possible and make it work (with passed tests) to fit the requirements
3. Once it works, implement next function, rather than refactoring as most of TDD guide told you to do so
4. Repeat step 2 until all requirements are fit, so we know we have a PoC/MVP.

### Middle stage - Refactoring with proper OOP
1. After reviewing the PoC, I though there were few domain object/class candidates: product, inventory and potentially change
2. Started with product and inventory, they looked similar but decided to separate them in 2 classes as they presents different domain. Product is basically only holding data but Inventory has some operations, which might change in the future, depending on business requirements.
3. Decided not to implement change class as there was not enough requirements around it
4. Started refactoring, extracted functions to classes.
5. Replaced original functions with new classes and made sure all tests are still pass

### Final stage - fine tune and tweaks
1. Renamed method/classes to be more accurate based on my understanding to the problem domain
2. Implemented runnable bundle command and fine tune the output message format
3. Some clean up

## Potential improvements (in no specific order)
1. Stock checking - The implementation doesn't check if there is enough product or coin stock for selling at the moment
2. Currency - The implementation use only British coins as constant, it could be more flexible to take other currency and maybe bills
3. VendingMachine#amount_to_change - this should be extract to currency basis in the future
4. Identifier - should use product or change ID to be the identifier rather than string as their key
5. STDOUT and logging - lot of `puts` in the code, which can be extracted or replaced by something better


