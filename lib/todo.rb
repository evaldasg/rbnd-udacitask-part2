class TodoItem
  include Listable

  ALLOWED_PRIORITIES = %w(low medium high).freeze

  attr_reader :description, :due, :priority, :type

  def initialize(description, options={})
    @description = description
    @type = options[:type]
    @due = options[:due] ? Chronic.parse(options[:due]) : options[:due]
    validate_and_assign_priority(options[:priority]) if options[:priority]
  end

  def details
    format_description(description, type) + details_for_table
  end

  def details_for_table
    'due: ' + (@due ? format_date(@due) : 'No due date') + format_priority(@priority)
  end

  private

  def validate_and_assign_priority(priority)
    message = "'#{priority}' is not allowed."
    raise UdaciListErrors::InvalidPriorityValue, message unless ALLOWED_PRIORITIES.include?(priority)
    @priority = priority
  end
end
