module BootStrap
  module_function
  
  def generate_articles
    DataMapper.auto_migrate!

    Article.fixture {{
      :title => /[:sentence:]/.gen[0..49],
      :body => /[:paragraph:]/.gen
    }}

    10.times do
      Article.gen
    end
  end
end