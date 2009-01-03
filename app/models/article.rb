class Article
  include DataMapper::Resource
  
  # Database schema
  property   :id,    Serial
  property   :body,  Text,   :nullable => false
  property   :title, String, :nullable => false
  timestamps :at
  
  # Relationships
  has n, :comments

end