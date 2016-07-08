class LinkItem
  include Listable

  attr_reader :description, :site_name, :type

  def initialize(url, options={})
    @description = url
    @site_name = options[:site_name]
    @type = options[:type]
  end

  def details
    format_description(description, type) + details_for_table
  end

  def details_for_table
    'site name: ' + site_name.to_s
  end
end
