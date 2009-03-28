class XapianResultEnumerator < Array

  attr_accessor :xapian_search, :page, :total_pages
  
  delegate :matches_estimated, :spelling_correction, :words_to_highlight, :to => :xapian_search


  def first_page
    1
  end

  def last_page
    total_pages
  end
  
end