# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class XapianSearchExtension < Spree::Extension
  version "1.0"
  description "Full text product search for Spree using acts_as_xapian"
  url "http://github.com/davidnorth/spree-xapian-search"

  def activate

    require 'paging_helper'
    ActionView::Base.send(:include, PaginatingFind::Helpers)    

    Product.class_eval do
      
      cattr_accessor :xapian_search_texts
      xapian_search_texts = [:name, :description]

      acts_as_xapian :texts => xapian_search_texts

      attr_accessor :search_percent
      attr_accessor :search_weight

      def self.search(query, options = {})
        options = {:per_page => 10}.update(options)
        options[:page] ||= 1
        
        total_matches = ActsAsXapian::Search.new([Product], query, :limit => options[:per_page]).matches_estimated
        total_pages = (total_matches / options[:per_page].to_f).ceil
        
        offset = options[:per_page] * (options[:page].to_i - 1)
        xapian_search = ActsAsXapian::Search.new([Product], query, :limit => options[:per_page], :offset => offset)

        products = XapianResultEnumerator.new(
          xapian_search.results.map do |result|
            product = result[:model]
            product.search_percent = result[:percent]
            product.search_weight = result[:weight]
            product
          end
        )
                
        products.xapian_search = xapian_search
        products.page = options[:page].to_i
        products.total_pages = total_pages
        products

      end
      
    end

    ProductsController.class_eval do
      
      def search
        if params[:q]
          @products = Product.search(params[:q], :page => params[:page], :per_page => 10)
        end
      end
      
    end
    
  end
end