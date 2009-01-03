require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Merb::GlobalHelpers" do
  include Merb::GlobalHelpers
  include Merb::AssetsMixin

  describe "#read_more" do
    it "truncates passed in text" do
      paragraph = /[:paragraph:]/.gen
      text = read_more(paragraph, :articles, 30)
      text.should =~ /#{paragraph[0...30]}.*#{resource(:articles)}/
    end
  
    it "returns nil if the passed in text is nil" do
      read_more(nil, :articles).should == nil
    end
    
    it "doesn't truncate if the passed in text is smaller than the size" do
      text = read_more("foobar", :articles, 50)
      text.should == 'foobar<a href="/articles">... read more</a>'
    end
    
    it "handles an Array for the object parameter" do
      text = read_more("foobar", [:articles, :new], 50)
      text.should == 'foobar<a href="/articles/new">... read more</a>'
    end
  end
end