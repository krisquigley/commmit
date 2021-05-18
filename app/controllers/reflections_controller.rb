# frozen_string_literal: true

class ReflectionsController < ApplicationController
  def new
    @commmit = Commmit.find(params[:commmit_id])
    @reflection = @commmit.build_reflection
  end

  def create
    @commmit = Commmit.find(params[:commmit_id])
    @reflection = @commmit.build_reflection(reflection_params)

    if @reflection.save
      redirect_to commmits_path, notice: t('commmits.reflection.notice.created')
    else
      render :new
    end
  end

  def show
    @commmit = Commmit.includes(:reflection).find(params[:commmit_id])
    @reflection = @commmit.reflection

    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found unless @reflection
  end

  private

  def reflection_params
    params.permit(:notes, :happiness)
  end
end
