DataMapper.setup( :default, 
                  :adapter => "mysql", 
                  :encoding => "utf8", 
                  :database => "legacy-blog", 
                  :username => "root",
                  :host     => "localhost" )
                  
class Article
  include DataMapper::Resource

  # name of the table
  storage_names[:default] = 'wp_ojqdyw_posts'
  
  property :id,         Serial
  property :title,      String,   :field => 'post_title'
  property :body,       Text,     :field => 'post_content'
  property :created_at, DateTime, :field => 'post_date'
  property :updated_at, DateTime, :field => 'post_modified'
  
  has n, :comments
end

class Comment
  include DataMapper::Resource
  
  # name of the table
  storage_names[:default] = 'wp_ojqdyw_comments'
  
  property :id,         Serial,   :field => 'comment_ID'
  property :article_id, Integer,  :field => 'comment_post_ID'
  property :author,     String,   :field => 'comment_author'
  property :body,       Text,     :field => 'comment_content'
  property :created_at, DateTime, :field => 'comment_date'
  property :updated_at, DateTime, :field => 'comment_date'
  
  belongs_to :article
end
