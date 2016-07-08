class UdaciList
  ALLOWED_ITEM_TYPES = %w(todo event link).freeze

  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] ? options[:title] : 'Untitled List'
    @items = []
  end

  def add(type, description, options={})
    validate_type(type = type.downcase)

    items.push Object.const_get(type.capitalize + 'Item').new(description, options.merge(type: type))
  end

  def delete(index)
    validate_delete_item(index)
    items.delete_at(index - 1)
  end

  def all(filter_items: nil)
    puts "#{separator}\n#{title}\n#{separator}"

    view_items = filter_items ? find_by_type(filter_items) : items

    view_items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end

  def filter(item_type)
    alert_nonexisting_filter(item_type) unless ALLOWED_ITEM_TYPES.include?(item_type)
    all(filter_items: item_type)
  end

  private

  def find_by_type(item_type)
    items.select { |item| item.type == item_type }
  end

  def alert_nonexisting_filter(item_type)
    puts "'#{item_type}' is not supported."
  end

  def separator
    @separator ||= '-' * title.length
  end

  def validate_type(item_type)
    message = "'#{item_type}' is not supported type."
    raise UdaciListErrors::InvalidItemType, message unless ALLOWED_ITEM_TYPES.include?(item_type)
  end

  def validate_delete_item(index)
    message = "Index '#{index}' is out of range."
    raise UdaciListErrors::IndexExceedsListSize, message unless items.size >= index
  end
end
