# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::User do
  describe 'adding a new user' do
    let(:new_user_payload) { file_fixture('new_user_payload.json').read }
    let(:parsed_payload) do
      {
        github_user_id: 583_231,
        source: Oj.dump(Oj.load(new_user_payload)['member'])
      }
    end

    it 'should return the parsed payload' do
      expect(described_class.call(new_user_payload)).to eq(parsed_payload)
    end
  end

  describe 'updating a user' do
    let(:edited_user_payload) { file_fixture('edited_user_payload.json').read }
    let(:parsed_payload) do
      {
        github_user_id: 583_231,
        source: Oj.dump(Oj.load(edited_user_payload)['member'])
      }
    end

    it 'should return the parsed payload' do
      expect(described_class.call(edited_user_payload)).to eq(parsed_payload)
    end
  end

  describe 'receiving a delete payload' do
    let(:deleted_user_payload) { file_fixture('deleted_user_payload.json').read }

    it 'should return nil' do
      expect(described_class.call(deleted_user_payload)).to eq(nil)
    end
  end
end
