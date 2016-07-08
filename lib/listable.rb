module Listable
  def format_description(description)
    description.to_s.ljust(25)
  end

  # Takes in either 1 or 2 dates
  def format_date(start_date, end_date = nil)
    dates = start_date.strftime('%D')
    dates << ' -- ' + end_date.strftime('%D') if end_date
    dates
  end
end
