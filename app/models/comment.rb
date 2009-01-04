class Comment
  include DataMapper::Resource
  
  # Database schema
  property   :id,     Serial
  property   :body,   Markdown
  property   :author, String
  timestamps :at

  # Relationships
  belongs_to :article

end
