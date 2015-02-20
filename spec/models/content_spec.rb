require "rails_helper"

RSpec.describe Content, :type => :model do

  describe 'Saving' do

    it 'prepare tags before create' do
      content = FactoryGirl.build(:content)
      content.tags = 'ruby rails'
      content.save
      expect(content.tags).to eq(' ruby rails ')
    end

  end

end