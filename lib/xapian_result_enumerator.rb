class XapianResultEnumerator < WillPaginate::Collection

  attr_accessor :xapian_search
  
  delegate :matches_estimated, :spelling_correction, :words_to_highlight, :to => :xapian_search


end