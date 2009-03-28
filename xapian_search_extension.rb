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
      
      def self.search(query, options = {})
        options = {:page => 1, :per_page => 10}.update(options)
        search = ActsAsXapian::Search.new([Product], query, :limit => options[:per_page])
        products = search.results.map{|result| result[:model]}
        
        products
      end
      
    end

    ProductsController.class_eval do
      
      def search
        if params[:q]
          @products = Product.search(params[:q], :page => params[:page], :per_page => 3)
        end
      end
      
    end
    
  end
end