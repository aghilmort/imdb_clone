require 'spec_helper'

RSpec.describe Api::V1::RatingPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :create?, :update? do
    it 'grants access if user is admin or member' do
      admin = User.new(role: :admin)
      member = User.new(role: :member)

      expect(subject).to permit(admin, member)
    end

    it 'denies access if user is not admin or member' do
      unprivileged = User.new(role: :else)

      expect(subject).not_to permit(unprivileged)
    end
  end
end
