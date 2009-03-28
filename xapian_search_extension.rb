# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class XapianSearchExtension < Spree::Extension
  version "1.0"
  description "Full text product search for Spree using acts_as_xapian"
  url "http://github.com/davidnorth/spree-xapian-search"

  # Please use xapian_search/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate

    Product.class_eval do
      acts_as_xapian :texts => [:name, :description]
    end
    
  end
end