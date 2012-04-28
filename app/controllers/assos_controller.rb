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
    @joinable_roles = Asso::DEFAULT_ROLES.collect do |role|
      if can? :join, @asso and !current_user.has_role? role, @asso
        [t("model.role.roles.#{role}", default: role), role]
      end
    end.compact
    @disjoinable_roles = @asso.roles.map(&:name).collect do |role|
      if can? :disjoin, @asso and current_user.has_role? role, @asso
        [t("model.role.roles.#{role}", default: role), role]
      end
    end.compact

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asso }
    end
  end

  def join
    role = params[:asso][:roles]
    if @asso.has_user? current_user, role
      redirect_to @asso, :notice => t('c.assos.already_joined', role: t("model.role.roles.#{role}", default: role))
    else
      @asso.add_user current_user, role
      redirect_to @asso, :notice => t('c.assos.joined', role: t("model.role.roles.#{role}", default: role))
    end
  end

  def disjoin
    role = params[:asso][:roles]
    unless @asso.has_user? current_user, role
      redirect_to @asso, :notice => t('c.assos.already_disjoined', role: t("model.role.roles.#{role}", default: role))
    else
      @asso.remove_user current_user, role
      redirect_to @asso, :notice => t('c.assos.disjoined', role: t("model.role.roles.#{role}", default: role))
    end
  end

  def new
  end

  def edit
  end

  def create
    @asso.owner = current_user

    if @asso.save
      redirect_to(@asso, :notice => t('c.created'))
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
      redirect_to(@asso, :notice => t('c.updated'))
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
