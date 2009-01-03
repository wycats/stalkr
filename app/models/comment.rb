class Comment
  include DataMapper::Resource
  
  property :id, Serial

  property :body, Text
  property :author, String

end
