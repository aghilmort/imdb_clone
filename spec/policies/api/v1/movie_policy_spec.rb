require 'spec_helper'

RSpec.describe Api::V1::MoviePolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :index?, :show? do
    it 'grants access to everyone' do
      member = User.new(role: :member)
      admin = User.new(role: :admin)
      other = User.new(role: :else)

      expect(subject).to permit(member, admin, other)
    end
  end

  permissions :create?, :update?, :destroy? do
    it 'grants access if user is admin' do
      admin = User.new(role: :admin)

      expect(subject).to permit(admin)
    end

    it 'denies access if user is not admin' do
      member = User.new(role: :member)
      unprivileged = User.new(role: :else)

      expect(subject).not_to permit(member, unprivileged)
    end
  end
end
