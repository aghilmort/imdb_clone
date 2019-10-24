require 'rails_helper'

RSpec.describe Rating, type: :model do

	describe 'associations' do
		it { should belong_to(:user) }
		it { should belong_to(:movie) }
	end

	describe 'validations' do
    it { should validate_presence_of(:score) }
    it { should validate_presence_of(:movie) }
    it { should validate_presence_of(:user) }
  end

end