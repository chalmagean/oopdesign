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

# vs.

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
