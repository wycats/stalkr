DataMapper.auto_migrate!

DataMapper.setup( :legacy, 
                  :adapter => "mysql", 
                  :encoding => "utf8", 
                  :database => "legacy-blog", 
                  :username => "root",
                  :host     => "localhost" )
                  
class Article
  include DataMapper::Resource

  # name of the table
  storage_names[:legacy] = 'wp_ojqdyw_posts'
  
  property :id,           Serial
  property :title,        String
  property :body,         Text
  timestamps :at
  
  repository(:legacy) do
    property :title,      String,   :field => 'post_title'
    property :body,       Text,     :field => 'post_content'
    property :created_at, DateTime, :field => 'post_date'
    property :updated_at, DateTime, :field => 'post_modified'
  end
  
  has n, :comments
end

class Comment
  include DataMapper::Resource
  
  # name of the table
  storage_names[:legacy] = 'wp_ojqdyw_comments'

  property :id,           Serial
  property :article_id,   Integer
  property :author,       String
  property :body,         Text
  timestamps :at
  
  repository(:legacy) do
    property :id,         Serial,   :field => 'comment_ID'
    property :article_id, Integer,  :field => 'comment_post_ID'
    property :author,     String,   :field => 'comment_author'
    property :body,       Text,     :field => 'comment_content'
    property :created_at, DateTime, :field => 'comment_date'
    property :updated_at, DateTime, :field => 'comment_date'
  end
  
  belongs_to :article
end

Article.copy(:legacy, :default)
Comment.copy(:legacy, :default)