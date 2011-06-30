class NewsController < ApplicationController
  load_and_authorize_resource
  before_filter :verify_sender, :only => :daymail

  # GET /news
  # GET /news.xml
  def index
    @news = News.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /news/1
  # GET /news/1.xml
  def show
    @news = News.find(params[:id])
    @comments = @news.comments
    @documents = @news.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /news/daymail
  def daymail
    system '/var/lib/gems/1.8/bin/rake daymail &'
    flash[:notice] = "Daymail envoyé"
    redirect_to :root
  end

  # GET /news/new
  # GET /news/new.xml
  def new
    @news = News.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /news/1/edit
  def edit
    @news = News.find(params[:id])
  end

  # POST /news
  # POST /news.xml
  def create
    @news = News.new(params[:news])
    @news.user = current_user

    respond_to do |format|
      if @news.save
        format.html { redirect_to(@news, :notice => "La news a été créée") }
        format.xml  { render :xml => @news, :status => :created, :location => @news }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @news.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /news/1
  # PUT /news/1.xml
  def update
    @news = News.find(params[:id])

    respond_to do |format|
      if @news.update_attributes(params[:news])
        format.html { redirect_to(@news, :notice => 'La news a été mise à jour') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.xml
  def destroy
    @news = News.find(params[:id])
    @news.destroy

    respond_to do |format|
      format.html { redirect_to(news_index_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def verify_sender
      authenticate_or_request_with_http_basic('Alors comme ça du veux envoyer le Daymail ?') do |username, password|
        username == 'daymailsender' and password == 'jesuisuncron'
      end
    end
end
