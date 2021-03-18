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

    describe 'with notes' do
      it 'should show the note icon'
    end

    describe 'that is repeatable' do
      it 'should show the repeat icon'
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
