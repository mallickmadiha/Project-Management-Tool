# frozen_string_literal: true

require 'rails_helper'

# rubocop: disable Metrics/BlockLength
RSpec.describe Project, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has and belongs to many users' do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq(:has_and_belongs_to_many)
    end

    it 'has many details with dependent destroy' do
      association = described_class.reflect_on_association(:details)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
  describe 'validations' do
    context 'positive test cases' do
      it 'is valid with valid attributes' do
        project = FactoryBot.build(:project, name: 'Valid Project', user: FactoryBot.create(:user))

        expect(project).to be_valid
      end
    end

    context 'positive test cases' do
      it 'is valid with valid attributes' do
        user = FactoryBot.create(:user)
        project = FactoryBot.build(:project, name: 'Valid Project', user:)

        expect(project).to be_valid
        expect(project.errors).to be_empty
      end

      it 'is valid with a name of minimum length' do
        user = FactoryBot.create(:user)
        project = FactoryBot.build(:project, name: 'abcde', user:)

        expect(project).to be_valid
        expect(project.errors).to be_empty
      end

      it 'is valid with a name of maximum length' do
        user = FactoryBot.create(:user)
        long_name = 'a' * 30
        project = FactoryBot.build(:project, name: long_name, user:)

        expect(project).to be_valid
        expect(project.errors).to be_empty
      end

      it 'is valid with a name containing underscores' do
        user = FactoryBot.create(:user)
        project = FactoryBot.build(:project, name: 'Awesome_Project', user:)

        expect(project).to be_valid
        expect(project.errors).to be_empty
      end

      it 'is valid with a name containing numbers' do
        user = FactoryBot.create(:user)
        project = FactoryBot.build(:project, name: 'Project123', user:)

        expect(project).to be_valid
        expect(project.errors).to be_empty
      end

      it 'is valid with a unique name for each user' do
        user1 = FactoryBot.create(:user)
        user2 = FactoryBot.create(:user)
        FactoryBot.create(:project, name: 'Unique Project', user: user1)
        project = FactoryBot.build(:project, name: 'Unique Project', user: user2)

        expect(project).to be_valid
        expect(project.errors).to be_empty
      end
    end

    context 'negative test cases' do
      it 'is not valid without a name' do
        project = FactoryBot.build(:project, name: nil, user: FactoryBot.create(:user))

        expect(project).not_to be_valid
        expect(project.errors[:name]).to include("can't be blank")
      end

      it 'is not valid if name is too short' do
        project = FactoryBot.build(:project, name: 'abc', user: FactoryBot.create(:user))

        expect(project).not_to be_valid
        expect(project.errors[:name]).to include('must be between 5 and 30 characters')
      end

      it 'is not valid if name is too long' do
        project = FactoryBot.build(:project, name: 'a' * 31, user: FactoryBot.create(:user))

        expect(project).not_to be_valid
        expect(project.errors[:name]).to include('must be between 5 and 30 characters')
      end

      it 'is not valid if name contains invalid characters' do
        project = FactoryBot.build(:project, name: 'Invalid@Project', user: FactoryBot.create(:user))

        expect(project).not_to be_valid
        expect(project.errors[:name]).to include('should start with letter & can contain letters, numbers, underscore')
      end

      it 'is not valid if the same name already exists for the same user' do
        user = FactoryBot.create(:user)
        FactoryBot.create(:project, name: 'Existing Project', user:)
        project = FactoryBot.build(:project, name: 'Existing Project', user:)

        expect(project).not_to be_valid
        expect(project.errors[:name]).to include('is already taken for this user')
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
