# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should validate_presence_of(:email)}
    it { should validate_uniqueness_of(:email)}
    it { should validate_presence_of(:password)}
    it { should have_many :user_viewing_parties }
    it { should have_many(:viewing_parties).through(:user_viewing_parties) }
  end

  describe '#user_host_name' do
    it 'can return the name of a user given their id' do
      user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')

      query = User.user_host_name(user_1.id)

      expect(query).to eq('Jamie')
    end
  end

  describe '#all_users_except_self' do
    it 'can return a list of all users excluding user argument' do
      user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
      user_2 = User.create!(name: 'Katie', email: '34997@gmail.com', password: '12345')
      user_3 = User.create!(name: 'George', email: 'george@gmail.com', password: '12345')

      query = User.all_users_except_self(user_1)

      expect(query).to eq([user_2, user_3])
    end
  end
end
