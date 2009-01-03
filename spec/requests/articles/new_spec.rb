require File.expand_path(File.join(File.dirname(__FILE__), "shared"))

describe "resource(:articles, :new)" do
  it_should_behave_like "a form for entering title and body"
  
  before(:each) do
    @response = request(resource(:articles, :new))
  end
  
  it "has a form that points to resource(:articles)" do
    @response.should have_selector("form[action='#{resource(:articles)}'][method='post']")
  end
  
  describe "when submitting the form" do
    it_should_behave_like "a form with potentially invalid details"
    
    before(:each) do
      @button_name = "Create"
    end
    
    describe "with valid details" do
      before(:each) do
        @paragraph = /[:paragraph:]/.gen
        fill_in      "Title", :with => "A glorious title"
        fill_in      "Body",  :with => @paragraph
        @response = click_button @button_name
      end
    
      it "redirects to resource(@article)" do
        @response.url.should include(resource(Article.first))
      end
    
      it "displays the article's title" do
        @response.should have_selector("h1:contains('A glorious title')")
      end
    
      it "displays the article's body" do
        @response.should have_selector(":contains('#{@paragraph}')")
      end
    
      it "displays a message indicating that the article was created" do
        @response.should have_selector("div.notice:contains('Article was successfully created')")
      end
    end
  end
end