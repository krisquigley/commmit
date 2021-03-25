# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def create
    Tag.create(tag_params)

    redirect_back fallback_location: tags_path, notice: t('tags.notice.created')
  end

  def destroy
    tag = Tag.friendly.find(params[:id])

    redirect_back fallback_location: tags_path, notice: t('tags.notice.destroyed') if tag.destroy
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
