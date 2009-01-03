require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Article do

  it "is invalid without a title and body" do
    a = Article.new
    a.should_not be_valid
    a.errors.on(:body).should_not be_nil
    a.errors.on(:title).should_not be_nil
  end
  
  it "is invalid without a body" do
    a = Article.new(:title => "Hello world")
    a.should_not be_valid
    a.errors.on(:title).should be_nil
    a.errors.on(:body).should_not be_nil
  end
  
  it "is invalid with a very long title" do
    a = Article.new(:title => ("a" * 100))
    a.should_not be_valid
    a.errors.on(:title).should_not be_nil
  end

  it "gets a timestamp when it is valid" do
    a = Article.new(:title => "Lorem Ipsum", :body => "Dolor")
    a.should be_valid
    a.save
    a.created_at.should_not be_nil
    a.updated_at.should_not be_nil
  end

end