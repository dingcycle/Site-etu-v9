class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  # GET /users.xml
  def index
    if params[:q].nil?
      @users = User.all
    else
      query = '%' + params[:q].split.join('%') + '%'
      @users = User.where('login LIKE :query', {:query => query})
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def password_reset
    if params[:email]
      user = User.find_by_email(params[:email])
      if user.nil?
        flash[:alert] = "Mauvaise adresse email"
      else
        UserMailer.password_reset(user)
        flash[:notice] = "Mail envoyé, vous devez cliquer sur le lien dedans"
      end
    elsif params[:token]
      user = User.find_by_perishable_token(params[:token])
      if user.nil?
        flash[:alert] = "Le jeton donné est expiré ou mauvais"
      else
        user.password = ActiveSupport::SecureRandom.hex(2) 
        user.password_confirmation = user.password
        user.save
        redirect_to :root, :notice => "Votre nouveau mot de passe est : #{user.password}. Evitez de l'oublier ;)."
      end
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @authorizations = @user.authorizations
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => "L'utilisateur a été créé") }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => "L'utilisateur à été mis à jour") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
