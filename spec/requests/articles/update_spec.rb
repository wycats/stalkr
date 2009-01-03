require File.expand_path(File.join(File.dirname(__FILE__), "shared"))

describe "resource(@article)", :given => "a article exists" do
  
  describe "PUT" do
    before(:each) do
      @article = Article.first
      @response = request(resource(@article), :method => "PUT", 
        :params => { :article => {:id => @article.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@article))
    end
  end
  
end