require 'inventory'

RSpec.describe Inventory do
  let(:inventory) { described_class.new }

  describe '#add' do
    let(:name) { 'Green Tea' }
    let(:stock) { 100 }

    subject { inventory.add(name: name, stock: stock) }

    it { is_expected.to eq(100) }
  end

  describe '#stock' do
    let(:name) { 'Green Tea' }

    subject { inventory.stock_of(name) }

    context 'when item exist' do
      it 'return current stock' do
        inventory.add(name: name, stock: 20)

        is_expected.to eq(20)
      end
    end
  end

  describe '#reload_stock' do
    let(:list) do
      {
        'Green Tea': 10,
        'Milk Tea': 20,
        'Black Tea': 30,
      }.to_json
    end

    subject { inventory.reload_stock(list) }

    context 'when these items have no stock' do
      it 'return stock of these items' do
        is_expected.to eq(JSON.parse(list))
      end
    end

    context 'when items have stock' do
      let(:expected_result) do
        {
          'Green Tea' => 15,
          'Milk Tea' => 20,
          'Black Tea' => 30,
        }
      end

      it 'return new stock of these reloaded items' do
        inventory.add(name: 'Green Tea', stock: 5)
        inventory.add(name: 'Bottle water', stock: 10)

        is_expected.to eq(expected_result)
      end
    end
  end
end