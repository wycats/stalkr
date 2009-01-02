class Article
  include DataMapper::Resource
  
  property :id, Serial

  property :body, Text
  property :title, String
  timestamps :at
end
