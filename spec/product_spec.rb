require 'product'

RSpec.describe Product do
  let(:inventory) { described_class.new('Green Tea', 79) }

  describe '#name' do
    subject { inventory.name }
    it { is_expected.to eq('Green Tea') }
  end

  describe '#price' do
    subject { inventory.price }
    it { is_expected.to eq(79) }
  end
end