# CREATE DATABASE `legacy-blog` CHARACTER SET utf8 COLLATE utf8_general_ci;
# mysql5 -u root legacy-blog < legacy-blog.sql

require 'rubygems'
gem 'dm-core'
require 'dm-core'
$KCODE = "UTF8"

DataMapper.setup( :legacy, 
                  :adapter => "mysql", 
                  :encoding => "utf8", 
                  :database => "legacy-blog", 
                  :username => "root",
                  :host     => "localhost" )
                  
DataMapper.setup( :default,
                  :adapter =>  'sqlite3',
                  :database => './../../config/sample_development.db' )


# Monkey Patch DM Model#copy
module DataMapper
  module Model
    def copy(source, destination, query = {})
      repository(destination) do
        all(query.merge(:repository => repository(source))).each do |resource|
          create(resource.attributes)
        end
      end
    end
  end
end


class Article
  include DataMapper::Resource
    # name of the legacy table
    storage_names[:legacy] = 'wp_ojqdyw_posts'
    
    has n, :comments
    # Cannot find the child_model Comment for Article
    
    # common attributes
    property :id,           Serial
    property :title,        String
    property :body,         Text
    property :created_at,   DateTime
    property :updated_at,   DateTime
    
    repository(:legacy) do
      property :title,      String,   :field => 'post_title'
      property :body,       Text,     :field => 'post_content'
      property :created_at, DateTime, :field => 'post_date'
      property :updated_at, DateTime, :field => 'post_modified'
    end
    
end

class Comment
  include DataMapper::Resource
    # name of the legacy table
    storage_names[:legacy] = 'wp_ojqdyw_comments'
    
    belongs_to :article
    # common attributes
    property :id,           Serial
    property :article_id,   Integer
    property :author,       String
    property :body,         Text
    property :created_at,   DateTime
    property :updated_at,   DateTime
    
    repository(:legacy) do
      property :id,         Serial,   :field => 'comment_ID'
      property :article_id, Integer,  :field => 'comment_post_ID'
      property :author,     String,   :field => 'comment_author'
      property :body,       Text,     :field => 'comment_content'
      property :created_at, DateTime, :field => 'comment_date'
      property :updated_at, DateTime, :field => 'comment_date'
    end
    
end

DataMapper.auto_migrate!
Article.copy(:legacy, :default)
Comment.copy(:legacy, :default)