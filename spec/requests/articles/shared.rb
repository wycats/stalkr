require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

given "a article exists" do
  Article.all.destroy!

  @article = Article.make.attributes
  
  request(resource(:articles), :method => "POST", :params => { :article => @article })
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