# encoding: utf-8
class AssosController < ApplicationController
  before_filter :process_image, :only => [:create, :update]
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assos }
    end
  end

  def show
    @comments = @asso.comments
    @documents = @asso.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asso }
    end
  end

  def join
    if current_user.is_member_of? @asso
      redirect_to @asso, :notice => t('c.assos.already_join')
    else
      # Chaque asso a un rôle membre, une fois que l'utilisateur a ce rôle
      # il fait parti de l'asso
      current_user.roles << @asso.member
      current_user.save
      redirect_to @asso, :notice => t('c.assos.join')
    end
  end

  def disjoin
    unless current_user.assos.include?(@asso)
      redirect_to @asso, :notice => t('c.assos.already_disjoin')
    else
      # On retire tout les rôles de l'utilisateur dans l'asso
      @asso.delete_user(current_user)
      redirect_to @asso, :notice => t('c.assos.disjoin')
    end
  end

  def new
  end

  def edit
  end

  def create
    @asso.owner = current_user

    if @asso.save
      redirect_to(@asso, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    # Si la case "supprimer" est cochée, on supprime l'image
    if params[:image_delete]
      @asso.image = nil
    end

    if @asso.update_attributes(params[:asso])
      redirect_to(@asso, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @asso.destroy

    redirect_to(assos_url)
  end

  private
  # Permet de créer l'image à partir du fichier
  def process_image
    params[:asso][:image] = Image.new(:asset => params[:asso][:image])
  end
end
