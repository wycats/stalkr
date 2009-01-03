class Comment
  include DataMapper::Resource
  
  # Database schema
  property   :id,     Serial
  property   :body,   Text
  property   :author, String
  timestamps :at

  # Relationships
  belongs_to :article

end
