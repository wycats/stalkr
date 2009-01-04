module DataMapper
  module Types
    
    # load the HTML version of a markdown string
    class Markdown < DataMapper::Type
      require 'rdiscount'
      primitive String
      # def self.load(value, property)
      # end
      
      def self.dump(value, property)
        value.nil? ? nil : RDiscount.new(value).to_html
      end
    end
    
  end
end