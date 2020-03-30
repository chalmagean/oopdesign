class Report
  def initialize(user:, items:)
    @user = user
    @items = items
  end

  def print
    puts "Invoice Report"
    puts @user
    puts @items
    puts "--------------"
  end
end

invoice_report = Report.new(user: "John", items: ["one", "two", "three"])
puts invoice_report.print
