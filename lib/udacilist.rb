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
    validate_item_index(index)
    items.delete_at(index - 1)
  end

  def all(filter_items: nil, print_table: false)
    view_items = filter_items ? find_by_type(filter_items) : items

    print_table ? print_in_table(view_items) : print_in_list(view_items)
  end

  def filter(item_type, print_table: false)
    return alert_nonexisting_filter(item_type) unless ALLOWED_ITEM_TYPES.include?(item_type)
    all(filter_items: item_type, print_table: print_table)
  end

  def change_priority(index, name)
    validate_item_index(index)
    item = items.at(index - 1)
    item.type == 'todo' && item.change_priority(name)
  end

  private

  def print_in_list(view_items)
    puts "#{separator}\n#{title}\n#{separator}"
    view_items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end

  def print_in_table(view_items)
    table = Terminal::Table.new do |t|
      t.style.all_separators = true
      t.title = title.to_s.colorize(color: :red, mode: :bold)
      t.headings = %w(# Type Description Details).map { |h| h.colorize(color: :magenta, mode: :bold) }
      view_items.each_with_index do |item, position|
        t.add_row [position + 1, item.type, item.description, item.details_for_table]
      end
    end
    puts table
  end

  def find_by_type(item_type)
    items.select { |item| item.type == item_type }
  end

  def alert_nonexisting_filter(item_type)
    puts "Filter with item type: '#{item_type}' is not supported."
  end

  def separator
    @separator ||= '-' * title.length
  end

  def validate_type(item_type)
    message = "'#{item_type}' is not supported type."
    raise UdaciListErrors::InvalidItemType, message unless ALLOWED_ITEM_TYPES.include?(item_type)
  end

  def validate_item_index(index)
    message = "Index '#{index}' is out of range."
    raise UdaciListErrors::IndexExceedsListSize, message unless items.size >= index
  end
end
