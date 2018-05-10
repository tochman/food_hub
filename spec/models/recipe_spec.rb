require 'rails_helper'

RSpec.describe Recipe, type: :model do
  recipe = FactoryBot.create(:recipe)

  describe 'Database table' do
    it {is_expected.to have_db_column :title}
    it { should validate_presence_of(:title) }
    it {is_expected.to have_db_column :description}
    it { should validate_presence_of(:description) }
    it {is_expected.to have_db_column :ingredients}
    it { should validate_presence_of(:ingredients) }
    it {is_expected.to have_db_column :directions}
    it { should validate_presence_of(:directions) }
  end

  describe 'Factory' do
    it 'can create a valid instance' do
      expect(recipe).to be_valid
    end
  end
end
