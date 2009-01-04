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
end