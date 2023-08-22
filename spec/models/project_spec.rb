# rubocop: disable all

require 'rails_helper'

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

  describe '.ordered_by_id_desc' do
    it 'orders backlogs by id in descending order' do
      project1 = create(:project)
      project2 = create(:project)
      project3 = create(:project)
      ordered_backlogs = Project.ordered_by_id_desc
      expect(ordered_backlogs).to eq([project3, project2, project1])
    end
  end

  describe 'scopes' do
    let!(:project) { create(:project) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }

    before do
      project.users << user1
      project.users << user2
    end

    context '.not_in_project' do
      it 'returns users not in the given project' do
        users_not_in_project = User.not_in_project(project)

        expect(users_not_in_project).to include(user3)
        expect(users_not_in_project).not_to include(user1, user2)
      end
    end

    context '.with_username_query' do
      it 'returns users with usernames matching the query within the project' do
        user1.update(username: 'john_doe')
        user2.update(username: 'jane_doe')
        user3.update(username: 'bob_smith')

        users_with_query = User.with_username_query(project, 'doe')
        expect(users_with_query).not_to include(user3)
      end
    end
  end

  describe '#custom_password_validation' do
    context 'when password meets the requirements' do
      let(:user) { build(:user, password: 'P@ssw0rd') }

      it 'does not add any errors' do
        user.valid?
        expect(user.errors[:password]).to be_empty
      end
    end

    context 'when password does not meet the requirements' do
      let(:user) { build(:user, password: 'weak') }

      it 'adds an error message' do
        user.valid?
        expect(user.errors[:password]).to include(
          "must be at least 8 characters long and include at least one uppercase letter,\n                 one lowercase letter, and one special character"        )
      end
    end

    context 'when password is nil' do
      let(:user) { build(:user, password: nil) }
    end

    context 'when password is blank' do
      let(:user) { build(:user, password: '') }

      it 'does not add any errors' do
        user.valid?
        expect(user.errors[:password]).to be_empty
      end
    end
  end
end
