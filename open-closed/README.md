# The Open/Closed Principle

Elements (classes, modules, functions, etc.) should be open for extension, and close for modification.

That means that you should design your application in a modular fashion so that you can change its behavior without actually changing its code.

This might sound impossible, but what it's actually referring to is, instead of changing the code you've already writte, you should be able to write new code that plugs in into the old one.

The way you achieve that is usually through patterns.

For example, the [observer pattern](../observer/) lets you subscribe new objects (with totally new behavior) that can respond to messages sent by the old object without actually changing its source code.

Note: Keep in mind that you should avoid adding complexity where it's not needed so use your own judgement to decide if it makes sense to introduce a new level of abstraction or not.

## Example

This first class is not open for extension. There is no way to add new behavior to it without changing its source code.

```ruby
class Report
  def initialize(user:, items:)
    @user = user
    @items = items
  end

  def print
    puts "Printing Report"
    puts @user
    puts @items
    puts "--------------"
  end
end

invoice_report = Report.new(user: "John", items: ["one", "two", "three"])
puts invoice_report.print
```

Let's imagine you want to add a some information in the footer of the `invoice_report`'s print output. With the example above, you would have to change the original class and add the behavior you want.

Instead, you could extend the original class with additional behavior.

```ruby
class Report
  def initialize(user:, items:)
    @user = user
    @items = items
  end

  def decoration
    puts "--------------"
  end
end

class InvoiceReport < Report
  def print
    puts "Printing Invoice Report"
    puts @user
    puts @items
    decoration
    puts "^------------^"
  end
end

class CustomReport < Report
  def initialize(address:, **args)
    super(**args)
    @address = address
  end

  def print
    puts "Printing Custom Report"
    puts @user
    puts @items
    puts @address
    decoration
  end
end

invoice_report = InvoiceReport.new(user: "John", items: ["one", "two", "three"])
puts invoice_report.print

custom_report = CustomReport.new(user: "John", items: ["one", "two", "three"], address: "Main Str.")
puts custom_report.print
```

Notice how both `InvoiceReport` and `CustomReport` don't change the original class. The add to it.

Also note that this is just *one* example of how you could extend the functionality of a class.

## Exercise 1
Given the following class that calculates the total mileage separated by gas type, we want to be able to print the result in both text, and HTML.

Please refactor the class (using the open/close principle) to support the new behavior, and be open to adding more options for printing in the future.

```ruby
class MileageCalculator
  def initialize(cars:)
    @cars = cars
  end

  def miles_total
    @cars.inject(Hash.new(0)) do |result, car|
      result[car.fuel_type] = result[car.fuel_type] + car.miles
      result
    end
  end
end

Car = Struct.new(:name, :miles, :fuel_type)

mustang = Car.new("Shelby GT500", 100_000, :gas)
mercedes = Car.new("Mercedes C200", 120_000, :gas)
fiesta = Car.new("Fiesta", 20_000, :diesel)
opel = Car.new("Astra", 100_000, :diesel)

calculator = MileageCalculator.new(cars: [mustang, mercedes, fiesta, opel])
puts calculator.miles_total
# => {:gas=>220000, :diesel=>120000}
```
