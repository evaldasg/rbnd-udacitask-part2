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

  def all
    puts "#{separator}\n#{title}\n#{separator}"

    items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end

  private

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
