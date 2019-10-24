require 'rails_helper'

RSpec.describe User, type: :model do
	
	describe 'associations' do
		it { should have_many(:ratings) }
	end

	describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:password) }

    it { should validate_inclusion_of(:role).in_array(['admin', 'member']) }
  end

end