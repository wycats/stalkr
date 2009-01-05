require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

given "a article exists" do
  login
  Article.all.destroy!

  @article = Article.make.attributes
  @article[:title].strip!
  @article[:body].strip!
  
  request(resource(:articles), :method => "POST", :params => { :article => @article })
  logout
end

shared_examples_for "an unauthenticated page" do
  before(:each) do
    logout
    @response = request(@url, :method => @method || "GET")
  end
  
  it "returns a 401" do
    @response.status.should == 401
  end
  
  it "has a login form" do
    @response.should have_selector("input[type='text'][name='login']")
    @response.should have_selector("input[type='password'][name='password']")
  end
end

shared_examples_for "a form for entering title and body" do
  it "responds successfully" do
    @response.should be_successful
  end
  
  it "has a field for entering the title" do
    @response.should have_selector(
      "form label:contains('Title') + input[type='text'][name*='title']")
  end
  
  it "has a field for entering the body" do
    @response.should have_selector(
      "form label:contains('Body') + textarea[name*='body']")
  end
  
  it "has a submit button" do
    @response.should have_selector("form input[type='submit']")
  end
end

shared_examples_for "a form with potentially invalid details" do
  describe "without a title" do
    before(:each) do
      @paragraph = /[:paragraph:]/.gen
      fill_in      "Title", :with => ""
      fill_in      "Body",  :with => @paragraph
      @response = click_button @button_name
    end
    
    it "re-renders the text with errors" do
      @response.should have_selector("div.error h2:contains('Form submission failed')")
      @response.should have_selector("div.error li:contains('Title')")
    end
  end
  
  describe "without a body" do
    before(:each) do
      fill_in      "Title", :with => "Hello world"
      fill_in      "Body",  :with => ""
      @response = click_button @button_name
    end
    
    it "re-renders the text with errors" do
      @response.should have_selector("div.error h2:contains('Form submission failed')")
      @response.should have_selector("div.error li:contains('Body')")
    end
  end
  
  describe "without a title or body" do
    before(:each) do
      fill_in      "Title", :with => ""
      fill_in      "Body",  :with => ""
      @response = click_button @button_name
    end
    
    it "re-renders the text with errors" do
      @response.should have_selector("div.error h2:contains('Form submission failed')")
      @response.should have_selector("div.error li:contains('Title')")
      @response.should have_selector("div.error li:contains('Body')")
    end
  end  
end