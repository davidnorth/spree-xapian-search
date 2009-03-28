# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class XapianSearchExtension < Spree::Extension
  version "1.0"
  description "Full text product search for Spree using acts_as_xapian"
  url "http://github.com/davidnorth/spree-xapian-search"

  def activate

    Product.class_eval do
      acts_as_xapian :texts => [:name, :description]
      attr_accessor :search_percent
      attr_accessor :search_weight

      def self.search(query, options = {})
        options = {:page => 1, :per_page => 10}.update(options)
        xapian_search = ActsAsXapian::Search.new([Product], query, :limit => options[:per_page])

        products = XapianResultCollection.new

        xapian_search.results.map do |result|
          product = result[:model]
          product.search_percent = result[:percent]
          product.search_weight = result[:weight]
          products << product
        end

        products.xapian_search = xapian_search

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