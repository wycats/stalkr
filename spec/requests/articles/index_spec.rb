require File.expand_path(File.join(File.dirname(__FILE__), "shared"))

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
    
    it "supplies an edit link for the article" do
      @response.should have_selector(
        "ul li a[href='#{resource(Article.first, :edit)}']:contains('[edit]')")
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