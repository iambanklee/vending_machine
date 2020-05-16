require 'vending_machine'

RSpec.describe VendingMachine do
  let(:vending_machine) { described_class.new(items, changes) }

  let(:items) do
    {
      "Green Tea": {
        price: 79,
        stock: 10
      },
      "Milk Tea": {
        price: 99,
        stock: 10
      },
      "Black Tea": {
        price: 59,
        stock: 10
      },
    }.to_json
  end

  let(:changes) do
    {
      '1p': 10,
      '2p': 10,
      '5p': 10,
      '10p': 10,
      '20p': 10,
      '50p': 10,
      '£1': 10,
      '£2': 10,
    }.to_json
  end

  xcontext 'There should be a way of reloading either products or change at a later point' do

  end

  xcontext 'The machine should keep track of the products and change that it contains'

  describe '#select_item' do
    subject { vending_machine.select_item(name) }

    context 'when item exist and has stock' do
      let(:name) { 'Green Tea'}

      it 'returns the order price' do
        is_expected.to eq(79)
      end
    end
  end

  describe '#insert_money' do
    subject { vending_machine.insert_money(coin) }

    let(:coin) { '50p' }

    it 'return inserted money' do
      is_expected.to eq(50)
    end
  end

  describe '#outstanding_money' do
    subject { vending_machine.outstanding_money }

    context 'when appropriate amount of money is inserted' do
      it 'returns zero' do
        is_expected.to eq(0)
      end
    end
  end

  describe '#purchase' do
    subject { vending_machine.purchase(item_name) }

    context 'given an item is selected' do
      let(:item_name) { 'Green Tea' }

      context 'when the appropriate amount of money is inserted' do
        it 'the vending machine should return the correct product' do
          expect(Kernel).to receive(:gets).and_return('50p', '50p')
          expect(vending_machine).to receive(:outstanding_money).and_return(79, 29, -21)

          is_expected.to eq('Green Tea')
        end
      end
    end
  end

  describe '#return_changes' do
    subject { vending_machine.return_changes(amount) }

    context '79p' do
      let(:amount) { 79 }
      it { is_expected.to eq(%w(50p 20p 5p 2p 2p)) }
    end

    context '21p' do
      let(:amount) { 21 }
      it { is_expected.to eq(%w(20p 1p)) }
    end

    context '128p' do
      let(:amount) { 128 }
      it { is_expected.to eq(%w(£1 20p 5p 2p 1p)) }
    end
  end
end