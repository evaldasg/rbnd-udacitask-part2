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

  def format_priority(priority)
    value = ' ⇧'.colorize(:red) if priority == 'high'
    value = ' ⇨'.colorize(:yellow) if priority == 'medium'
    value = ' ⇩'.colorize(:green) if priority == 'low'
    value.to_s
  end
end
