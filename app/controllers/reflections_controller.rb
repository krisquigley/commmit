# frozen_string_literal: true

class ReflectionsController < ApplicationController
  def new
    @commmit = Commmit.includes(:reflection, :story).find(params[:commmit_id])

    return redirect_to commmit_reflection_path(@commmit), alert: t('commmits.reflection.notice.already_exists') if @commmit.reflected?

    @reflection = @commmit.build_reflection
  end

  def create
    @commmit = Commmit.includes(:reflection).find(params[:commmit_id])

    return redirect_to commmit_reflection_path(@commmit), alert: t('commmits.reflection.notice.already_exists') if @commmit.reflected?

    @reflection = @commmit.build_reflection(reflection_params)

    if @reflection.save
      return redirect_to new_commmit_path, notice: t('commmits.reflection.notice.created') if params[:redirect].present?

      redirect_to commmits_path, notice: t('commmits.reflection.notice.created')
    else
      render :new
    end
  end

  def show
    @commmit = Commmit.includes(:reflection, :story).find(params[:commmit_id])
    @reflection = @commmit.reflection

    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found unless @reflection
  end

  private

  def reflection_params
    params.permit(:goal_met, :happiness, :notes)
  end
end
