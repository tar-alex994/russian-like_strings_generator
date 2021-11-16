require 'rspec'
require_relative '../app/methods'

describe 'rl_str_gen_spec' do

  it 'should contain from 2 to 15 words' do 
    1000.times do
      str = rl_str_gen

      expect(str.scan(/[А-ЯЁ]+/i).size).to be >= 2
      expect(str.scan(/[А-ЯЁ]+/i).size).to be <= 15
    end
  end

  it 'should not contain words over 15 letters' do
    1000.times do 
      str = rl_str_gen
      expect(str.scan(/[А-ЯЁ]+/i).count { |el| el.size > 15 }).to eq(0)
    end
  end

end