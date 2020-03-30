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
