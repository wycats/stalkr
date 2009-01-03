class Article
  include DataMapper::Resource
  
  property :id, Serial

  property :body,  Text,   :nullable => false
  property :title, String, :nullable => false
  timestamps :at
end
