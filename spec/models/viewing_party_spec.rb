# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ViewingParty, type: :model do
  describe 'relationships' do
    it { should have_many :user_viewing_parties }
    it { should have_many(:users).through(:user_viewing_parties) }
  end

  describe '#invitees' do
    it "returns an array of user viewing party objects with the names and id's of users attending the viewing party with id matching to the returned objects" do
      user_1 = User.create!(name: 'Jamie', email: '34@gmail.com', password: '12345')
      user_2 = User.create!(name: 'Katie', email: '34997@gmail.com', password: '12345')
      user_3 = User.create!(name: 'George', email: 'george@gmail.com', password: '12345')
      viewing_party_1 = ViewingParty.create!(duration: 180, date: '2023-05-04', start_time: '07:00:00', movie_id: 238,
                                             host_user_id: user_2.id)
      UserViewingParty.create!(user: user_1, viewing_party: viewing_party_1)
      UserViewingParty.create!(user: user_3, viewing_party: viewing_party_1)

      query = viewing_party_1.invitees.map do |party|
        { name: party.name, id: party.id }
      end

      expect(query).to eq([{ name: user_1.name.to_s, id: user_1.id }, { name: user_3.name.to_s, id: user_3.id }])
    end
  end
end
