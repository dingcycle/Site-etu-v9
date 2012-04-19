# encoding: utf-8
class VotesController < ApplicationController
  load_and_authorize_resource

  def create
    @vote.user = current_user

    if @vote.save
      redirect_to @vote.answer.poll, :notice => t('c.votes.create')
    else
      render :action => "new"
    end
  end

  def destroy
    @vote.destroy

    redirect_to @vote.answer.poll
  end
end
