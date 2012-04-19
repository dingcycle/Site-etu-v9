# encoding: utf-8
class PollsController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @polls }
    end
  end

  def show
    # Récupére le vote de l'utilisateur actuel
    @vote = @poll.voted_by?(current_user) ? @poll.vote_of(current_user) : nil

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @poll }
    end
  end

  def new
    5.times { @poll.answers.build } # Permet de créer 5 réponses d'un coup
  end

  def edit
    # Au moins un formulaire de réponse
    @poll.answers.build
    if @poll.answers.size < 5
      (5 - @poll.answers.size).times { @poll.answers.build }
    end
  end

  def create
    @poll.user = current_user

    if @poll.save
      redirect_to @poll, :notice => t('c.create')
    else
      render :action => "new"
    end
  end

  def update
    if @poll.update_attributes(params[:poll])
      redirect_to @poll, :notice => t('c.update')
    else
      render :action => "edit"
    end
  end

  def destroy
    @poll.destroy

    redirect_to polls_url
  end
end
