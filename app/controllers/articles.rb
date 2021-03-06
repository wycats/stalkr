class Articles < Application
  provides :json
  before :ensure_authenticated, :exclude => [:index, :show]

  def index
    @articles = Article.all
    display @articles
  end

  def show(id)
    @article = Article.get(id)
    raise NotFound unless @article
    display @article
  end

  def new
    only_provides :html
    @article = Article.new
    display @article
  end

  def edit(id)
    only_provides :html
    @article = Article.get(id)
    raise NotFound unless @article
    display @article
  end

  def create(article)
    @article = Article.new(article)
    if @article.save
      redirect resource(@article), :message => {:notice => "Article was successfully created"}
    else
      message[:error] = "Article failed to be created"
      render :new
    end
  end

  def update(id, article)
    @article = Article.get(id)
    raise NotFound unless @article
    if @article.update_attributes(article)
       redirect resource(@article), :message => {:notice => "Article was successfully updated"}
    else
      display @article, :edit
    end
  end

  def delete(id)
    # display uses the current action_name, so display @article in edit will
    # render delete.html.erb
    edit(id)
  end

  def destroy(id)
    @article = Article.get(id)
    raise NotFound unless @article
    if @article.destroy
      if content_type == :json
        display(:notice => "Article was successfully deleted")
      else
        redirect resource(:articles), :message => {:notice => "Article was successfully deleted"}
      end
    else
      raise InternalServerError
    end
  end

end # Articles
