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
    
    describe "new comment form" do
      it "supplies a form for creating new comments" do
        @response.should have_selector(
          "form[action='#{resource(Article.first, :comments)}']")
      end
      
      it "has a field for author name" do
        @response.should have_selector(
          "form input[type='text'][name*=author]")
      end
      
      it "has a field for body" do
        @response.should have_selector(
          "form textarea[name*=body]")
      end
      
      describe "submitting a comment with Markdown" do
        before(:each) do
          fill_in      "Author",  :with => "Awesome Dude"
          fill_in      "Twitter Name", :with => "osim_dude"
          fill_in      "Comment", :with => "What kind of *idiot* are you anyway?"
          @response = click_button "Submit"
        end
        
        it "shows the comment formatted in HTML" do
          @response.should have_selector(
            "ul.comments li em:contains('idiot')")
        end
      end
      
      describe "submitting a new comment" do
        before(:each) do
          fill_in      "Author",  :with => "Awesome Dude"
          fill_in      "Twitter Name", :with => "osim_dude"
          fill_in      "Comment", :with => "What kind of idiot are you anyway?"
          @response = click_button "Submit"
        end
        
        it "returns the user to the article's page" do
          @response.url.should =~ %r{#{resource(Article.first)}}
        end
        
        it "shows the title of the new comment that was created" do
          @response.should have_selector(
            "ul.comments li:contains('Awesome Dude')")
        end
        
        it "shows the twitter name of the author of the new comment" do
          @response.should have_selector(
            "ul.comments li a[href*='osim_dude']:contains('Follow Me on Twitter')")
        end
        
        it "shows the body of the new comment that was created" do
          @response.should have_selector(
            "ul.comments li:contains('What kind of idiot are you anyway?')")
        end
      end
    end
  end
  
end

