class Comment
  include DataMapper::Resource
  
  # Database schema
  property   :id,     Serial
  property   :body,   Text, :lazy => false
  property   :author, String
  property   :twitter_name, String
  timestamps :at

  # Relationships
  belongs_to :article

end
