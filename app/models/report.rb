class Report < ApplicationRecord
	def self.select_destinations
  	["全国","本省","异地"]
	end

	def self.select_years
    years = []
    i = 4
    until i < 0 
      years << Time.now.year-i
      i = i - 1
    end
    return years
  end

  def self.select_months
    ["1","2","3","4","5","6","7","8","9","10","11","12"]
  end
end
