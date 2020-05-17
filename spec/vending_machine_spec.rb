require 'vending_machine'

RSpec.describe VendingMachine do
  let(:vending_machine) { described_class.new(items, changes) }

  let(:items) do
    {
      "Green Tea": {
        price: 70,
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

  describe '#purchase' do
    subject { vending_machine.purchase(item_name) }

    context 'given an item is selected' do
      context 'when the appropriate amount of money is inserted' do
        let(:item_name) { 'Green Tea' }

        it 'return the correct product' do
          expect(Kernel).to receive(:gets).and_return('50p', '20p')
          expect(vending_machine).to receive(:outstanding_amount).and_return(70, 70, 20, 20, 0, 0)

          expect{subject}.to output(/Please collect your Green Tea/).to_stdout
          expect{subject}.not_to output(/Please remember to collect your change/).to_stdout
          is_expected.to eq('Green Tea')
        end
      end

      context 'when too much money is provided' do
        let(:item_name) { 'Black Tea' }

        it 'return the correct product' do
          expect(Kernel).to receive(:gets).and_return('50p', '20p')
          expect(vending_machine).to receive(:outstanding_amount).and_return(59, 59, 9, 9, -11, -11, -11)

          expect{subject}.to output(/Please collect your Black Tea/).to_stdout
          is_expected.to eq('Black Tea')
        end

        it 'return the correct change' do
          expect(Kernel).to receive(:gets).and_return('50p', '20p')
          expect(vending_machine).to receive(:outstanding_amount).and_return(59, 59, 9, 9, -11, -11, -11)

          expect{subject}.to output(/Please remember to collect your change: \[\"10p\", \"1p\"\]/).to_stdout
          is_expected.to eq('Black Tea')
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