require 'rails_helper'

RSpec.describe Movie, type: :model do

	describe 'associations' do
		it { should belong_to(:category) }
		it { should have_many(:ratings) }
	end

	describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:category) }
  end

end