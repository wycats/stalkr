require File.expand_path(File.join(File.dirname(__FILE__), "shared"))

describe "resource(@article)" do
  describe "clicking the 'Delete' link", :given => "a article exists" do
    before(:each) do
      visit resource(:articles)
      @response = click_link "delete"
    end
    
    it "sends the user to a confirmation page" do
      @response.should have_selector("form[action='#{resource(Article.first)}']")
      @response.should have_selector("form input[name='_method'][value='delete']")
    end
    
    describe "confirming the deletion" do
      before(:each) do
        @response = click_button "Delete"
      end
    
      it "redirects back to the index page" do
        @response.url.should include(resource(:articles))
      end
      
      it "successfully deleted the item" do
        @response.should_not have_selector("ul li")
      end
      
      it "displays a message indicating that the article was deleted" do
        @response.should have_selector("div.notice:contains('Article was successfully deleted')")
      end
    end
  end
  
  describe "a successful DELETE", :given => "a article exists" do
     before(:each) do
       @response = request(resource(Article.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:articles))
     end

   end
end