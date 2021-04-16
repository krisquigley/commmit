# frozen_string_literal: true

class ValuesController < ApplicationController
  def index
    @values = Value.all.kept
  end

  def edit
    @value = Value.find(params[:id])
  end

  def update
    @value = Value.find(params[:id])

    if @value.update(value_params)
      redirect_to values_path, notice: t('values.notice.updated')
    else
      render :edit
    end
  end

  def create
    Value.create(value_params)

    redirect_back fallback_location: values_path, notice: t('values.notice.created')
  end

  def destroy
    value = Value.find(params[:id])

    redirect_to values_path, notice: t('values.notice.destroyed') if value.discard
  end

  private

  def value_params
    params.require(:value).permit(:name, :color)
  end
end
