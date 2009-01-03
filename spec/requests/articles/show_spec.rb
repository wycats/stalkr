require File.expand_path(File.join(File.dirname(__FILE__), "shared"))

describe "resource(@article)", :given => "a article exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Article.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
    
    it "has a title" do
      @response.should have_selector("h1:contains('#{@article[:title]}')")
    end
    
    it "has a body" do
      @response.should have_selector(":contains('#{@article[:body]}')")
    end
    
    it "has a link back to the index page" do
      @response.should have_selector("a[href='#{resource(:articles)}']")
    end
  end
  
end

