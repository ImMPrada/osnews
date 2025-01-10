require 'rails_helper'

RSpec.describe Guild, type: :model do
  context 'when validating' do
    subject { build(:guild) }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:channel_id) }

    describe 'uniqueness validation' do
      let(:existing_guild) { create(:guild) }
      let(:new_guild) { build(:guild, external_id: existing_guild.external_id, channel_id: existing_guild.channel_id) }

      it 'is not valid with duplicate external_id and channel_id' do
        expect(new_guild).not_to be_valid
      end

      it 'adds error message for duplicate external_id' do
        new_guild.valid?
        expect(new_guild.errors[:external_id]).to include('has already been taken')
      end
    end
  end
end
