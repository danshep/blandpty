require 'csv'
require 'erb'

class Page
  attr_reader :title, :items
  attr_accessor :footer
  def initialize(title)
    @title = title
    @items = []
  end
  def icon; nil; end
  def self.new_page(title)
    case title
    when 'Tap Beer'
      BeerPage.new(title)
    when 'From The Fridge'
      FridgePage.new(title)
    when 'Wine'
      WinePage.new(title)
    when 'Cocktails'
      CocktailPage.new(title)
    else 
      raise title
    end
  end
end

class BoozeItem
  def tex_name
    @name.gsub(/[&]/) do |x|
      "\\#{x}"
    end.gsub(/\((gf|vegan)\)/) do |x|
      "{\\tiny #{x}}"
    end.gsub(/\*(.*)\*/) do |_|
      "\\textbf{#{$1}}"
    end
  end
  def abv
    if /^\d+(?:\.\d+)?$/ === @abv
      "%0.02f" % @abv
    else
      @abv
    end
  end
end

class BeerPage < Page
  def icon; 'GlassWeizen'; end
  def add_item(*args)
    items << BeerItem.new(*args)
  end
end

class BeerItem < BoozeItem
  def initialize(name, description, abv, pot, pint)
    @name, @description, @abv, @pot, @pint = name, description, abv, pot, pint
  end
  def tex_output
    "\\Beer{#{tex_name}}{#{@description}}{#{abv}}{#{@pot}}{#{@pint}}"
  end
end

class FridgePage < Page
  def icon; 'GlassFridge'; end
  def add_item(*args)
    items << FridgeItem.new(*args)
  end  
end

class FridgeItem < BoozeItem
  def initialize(name, _, abv, price, *args)
    @name, @abv, @price = name, abv, price
  end
  def tex_output
    "\\Booze{#{tex_name}}{#{abv}}{#{@price}}"
  end
end

class WinePage < Page
  def icon; 'GlassWine'; end
  def add_item(*args)
    items << WineItem.new(*args)
  end
end

class WineItem < BoozeItem
  def initialize(name, description, abv, glass_price, bottle_price)
    @name, @description, @abv, @glass_price, @bottle_price = name, description, abv, glass_price, bottle_price
  end
  def tex_output
    #"\\Booze{#{tex_name}}{#{abv}}{#{@glass_price}} \\\\\n    \\Expl{#{@description}}"
    "\\Wine{#{tex_name}}{#{@description}}{#{abv}}{#{@glass_price}}{#{@bottle_price}}"
  end
end

class CocktailPage < Page
  def add_item(*args)
    items << CocktailItem.new(*args)
  end
end

class CocktailItem < BoozeItem
  def initialize(name, ingredients, price, icon, tagline)
    @name, @ingredients, @price, @icon, @tagline = name, ingredients, price, icon, tagline
  end
  def tex_output
    "\\Cocktail{#{tex_name}}{\\#{@icon}}{#{@price}} \\\\\n    \\Expl{#{@ingredients}} \\\\\n    \\Expl{\\it #{@tagline}}"
  end
end

pages = []

CSV.open('generate_menu.csv').each do |row|
  next if row.compact.empty?
  next if row.shift == 'x'
  if /Page: (.*)/ === row.first
    pages << Page.new_page($1)
  elsif /Footer: (.*)/ === row.first
    pages.last.footer = $1
  else
    #p row
    pages.last.add_item(*row)
  end
end

output = ERB.new(File.read('menu.tex.erb'), trim_mode: '-').result(binding)
File.open('menu.tex','w') { |f| f.write output }