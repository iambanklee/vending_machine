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

  describe '#purchase' do
    subject { vending_machine.purchase(item_name) }

    context 'given an item is selected' do
      context 'when the appropriate amount of money is inserted' do
        let(:item_name) { 'Green Tea' }

        it 'return the correct product' do
          expect(Kernel).to receive(:gets).and_return('50p', '20p')
          expect{subject}.to output(/Please collect your Green Tea/).to_stdout
          expect{subject}.not_to output(/Please remember to collect your change/).to_stdout

          is_expected.to eq('Green Tea')
        end

        it 'deduct the item stock' do
          expect(Kernel).to receive(:gets).and_return('50p', '20p')

          expect{subject}.to change { vending_machine.item_inventory.stock_of(item_name) }.from(10).to(9).and output(/Green Tea now has 9 in stock/).to_stdout
        end
      end

      context 'when too much money is provided' do
        let(:item_name) { 'Black Tea' }

        it 'return the correct product' do
          expect(Kernel).to receive(:gets).and_return('50p', '20p')
          expect{subject}.to output(/Please collect your Black Tea/).to_stdout

          is_expected.to eq('Black Tea')
        end

        it 'return the correct change' do
          expect(Kernel).to receive(:gets).and_return('50p', '20p')
          expect{subject}.to output(/Please remember to collect your change: \[\"10p\", \"1p\"\]/).to_stdout

          is_expected.to eq('Black Tea')
        end

        context 'and incorrect coin inserted' do
          it 'reject that coin with error message' do
            expect(Kernel).to receive(:gets).and_return('50p', '30p', '20p')
            expect{subject}.to output(/This machine doesn't accept 30p/).to_stdout

            is_expected.to eq('Black Tea')
          end
        end
      end
    end
  end

  describe '#amount_to_change' do
    subject { vending_machine.amount_to_change(amount) }

    context '79p' do
      let(:amount) { 79 }
      it { is_expected.to eq(%w[50p 20p 5p 2p 2p]) }
    end

    context '21p' do
      let(:amount) { 21 }
      it { is_expected.to eq(%w[20p 1p]) }
    end

    context '128p' do
      let(:amount) { 128 }
      it { is_expected.to eq(%w[£1 20p 5p 2p 1p]) }
    end
  end
end