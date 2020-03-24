# The "Tell Don't Ask" Principle

> Procedural code gets information then makes decisions.
>
> Object-oriented code tells objects to do things.
>
> --- Alec Sharp

Tell objects what to do (what you want), and trust that they know how to do it. You don't have to get their state, make assertions about it, and them tell them what to do depending on their internal state.

Objects should make their own decisions internally based on the information they hold (or has been provided to them via messages).

By doing this, you will isolate responsibilities in different objects which are then easy to replace with other objects that play the same role.

It looks like this: `user.company.address.street` vs. `user.company_street`.

The exception to this rule is querying objects when filtering for example. You might have a list of objects you want to filter based on a query method like `.active?`. Try to pay special attention whenever you are using them so you don't add coupling to the caller.

## Example

In this first example, the `to_s` method on the `User` object reaches into another object that is not in its immediate vicinity (namely the `Address` object). That means it knows how `Company` works internally, and that means `User` is coupled with `Company`.

```ruby
User = Struct.new(:name, :company) do
  def to_s
    street_number = if (number = company.address.number.to_i) > 5
                      "is too far away"
                    else
                      number
                    end
    [
      name,
      company.address.street,
      street_number
    ].join(" ")
  end
end
Company = Struct.new(:name, :address)
Address = Struct.new(:street, :number)

address = Address.new("Main Str.", "6")
company = Company.new("Google Inc.", address)
user = User.new("John", company)

puts user
```

In this second example, `User` doesn't care how `Company` gets the address, it's not the `User`s concern. It trusts `Company` to do it's job and respond with the proper address.

This results in a more decoupled design, where objects could be replaced with other objects that play the same role.

```ruby
User = Struct.new(:name, :company) do
  def to_s
    [name, company.to_s].join(" ")
  end
end

Company = Struct.new(:name, :address) do
  def to_s
    address.to_s
  end
end

Address = Struct.new(:street, :number) do
  def to_s
    [street, print_number].join(" ")
  end

  private

    def print_number
      number.to_i > 5 ? "is too far away" : number
    end
end

address = Address.new("Main Str.", "6")
company = Company.new("Google Inc.", address)
user = User.new("John", company)

puts user
```

I could replace the `Company` object with an `Enterprise` object if I wanted to and the `User` object wouldn't care. But more importantly, the `User` object wouldn't have to change.

Also, the `Enterprise` object might not have an `Address` collaborator. It could perform its role however it sees fit as long as it does the job.

```ruby
User = Struct.new(:name, :company) do
  def to_s
    [name, company.to_s].join(" ")
  end
end

Enterprise = Struct.new(:name) do
  def to_s
    "Main Str."
  end
end

enterprise = Enterprise.new("Google Inc.")
user = User.new("John", enterprise)

puts user
```

## Exercise 1 - Close locations

Fill in the TODOs with the correct implementation.

```ruby
Map = Struct.new(:addresses) do
  def radius_fifty
    # TODO: ..
  end
end

Address = Struct.new(:street, :number, :distance) do
  # TODO: ...
end

home = Address.new("Home Str.", "1", "10km")
work = Address.new("Work Str.", "6", "13km")
vacation_home = Address.new("Vacation Str.", "5", "100km")
parents_house = Address.new("Parents Str.", "2", "230km")

map = Map.new([home, work, vacation_home, parents_house])

puts map.radius_fifty

# Expected:
#
# => ["Home Str. Nr. 1 (10km)", "Work Str. Nr. 6 (13km)"]
```

## Exercise 2 - Party friends

John has a bunch of friends (who also have friends) and he wants to throw a pet party for all his friend's dogs that are over 2 years old.

```ruby
Person = Struct.new(:name, :friends, :pets) do
  def dog_party
    # TODO: ...
  end
end

Pet = Struct.new(:name, :type, :age) do
  # TODO: ...
end

tom = Pet.new("Tom", :cat, 5)
lessie = Pet.new("Lessie", :dog, 9)
puffy = Pet.new("Puffy", :dog, 2)
oscar = Pet.new("Oscar", :dog, 11)
max = Pet.new("Max", :dog, 1)
coco = Pet.new("Coco", :parrot, 2)

jim = Person.new("Jim", [], [tom])
daniel = Person.new("Daniel", [], [lessie])
katherine = Person.new("Katherine", [], [coco])
joe = Person.new("Joe", [jim, daniel], [puffy])
mary = Person.new("Mary", [katherine], [oscar, max])
john = Person.new("John", [joe, mary], [])

puts john.dog_party

# Expected:
#
# => ["Daniel's Lessie", "Mary's Oscar"]
```

