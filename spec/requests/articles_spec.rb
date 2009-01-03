require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a article exists" do
  Article.all.destroy!

  @article = Article.make.attributes
  
  request(resource(:articles), :method => "POST", :params => { :article => @article })
end

describe "resource(:articles)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:articles))
      @response_slash = request("/")
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of articles" do
      @response.should have_selector("ul")
    end
    
  end
  
  describe "GET", :given => "a article exists" do
    before(:each) do
      @response = request(resource(:articles))
      @response_slash = request("/")
    end
    
    it "has a list of articles" do
      @response.should have_selector("ul li")
    end
    
    it "has articles that contain a title" do
      @response.should have_selector("ul li:contains('#{@article[:title]}')")
    end

    it "truncates the body after 150 characters" do
      @response.should_not have_selector("ul li:contains('#{@article[:body][151..200]}')")
    end
    
    it "has a 'read more' link when the body is longer than 150 characters" do
      @response.should have_selector(
        "ul li a:contains('read more')[href='#{resource(Article.first)}']")
    end
    
    it "supplies a delete link for the article" do
      @response.should have_selector(
        "ul li a[href='#{resource(Article.first, :delete)}']:contains('[delete]')")
    end
    
    it "is identical to visiting '/'" do
      @response.body.to_s.should == @response_slash.body.to_s
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Article.all.destroy!
      @response = request(resource(:articles), :method => "POST", 
        :params => { :article => { :id => nil }})
    end
    
    it "redirects to resource(:articles)" do
      @response.should redirect_to(resource(Article.first), :message => {:notice => "article was successfully created"})
    end
    
  end
end

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

describe "resource(:articles, :new)" do
  before(:each) do
    @response = request(resource(:articles, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
  
  it "has a form that points to resource(:articles)" do
    @response.should have_selector("form[action='#{resource(:articles)}'][method='post']")
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
  
  describe "when submitting the form" do
    before(:each) do
      @paragraph = /[:paragraph:]/.gen
      fill_in      "Title", :with => "A glorious title"
      fill_in      "Body",  :with => @paragraph
      @response = click_button "Create"
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

describe "resource(@article, :edit)", :given => "a article exists" do
  before(:each) do
    @response = request(resource(Article.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

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

