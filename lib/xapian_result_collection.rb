class XapianResultCollection < Array

  attr_accessor :xapian_search
  
  delegate :matches_estimated, :spelling_correction, :words_to_highlight, :to => :xapian_search

end