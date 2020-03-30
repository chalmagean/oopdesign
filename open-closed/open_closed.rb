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
    puts "Invoice Report"
    puts @user
    puts @items
    decoration
  end
end

class CustomReport < Report
  def initialize(address:, **args)
    super(**args)
    @address = address
  end

  def print
    puts "Custom Report"
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
