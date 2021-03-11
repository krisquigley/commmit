# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stories', type: :feature do
  include AuthHelper

  before do
    log_in
  end

  context 'when creating a story' do
    describe 'with valid data' do
      it 'should create the story with just the goal'
    end
  end

  context 'when listing stories' do
    describe 'with a reason' do
      it 'should display it'
    end

    describe 'without a reason' do
      it 'should hide it'
    end

    it 'should not show completed stories'
  end
end
