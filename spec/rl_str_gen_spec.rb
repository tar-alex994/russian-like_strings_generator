require 'rspec'
require_relative '../app/methods'

describe 'rl_str_gen_spec' do

  it 'should return a string' do 
    1000.times do 
      expect(rl_str_gen).to be_an_instance_of(String)
    end
  end


  it 'should  contain only valid symbols' do 
    1000.times do 
      expect(rl_str_gen.match /[^A-ЯЁ,\.:\-!\?\"; ]/i).to be_nil
    end
  end


  it 'should not be ower 300 symbols' do 
    100_000.times do 
      expect(rl_str_gen.size).to be <= 300
    end
  end


  it 'should contain from 2 to 15 words' do 
    1000.times do
      str = rl_str_gen

      expect(str.size).to be <= 300
      expect(str.gsub('- ', '').match?(/\A(?:[^ ]+ +){1,14}[^ ]+ *\z/)).to be true
    end
  end


  it 'should not contain words over 15 letters' do
    1000.times do 
      words = rl_str_gen.scan(/[А-ЯЁ]+(?:-[А-ЯЁ]+)?/i)
      expect(words.count { |el| el.size > 15}).to eq(0)
    end
  end


  it 'should allow only particular marks after words within sentence' do
    1000.times do 
      within = rl_str_gen.split.reject{ |el| el == '-' }[0..-2]

      expect(within.reject { |el| el.match? /[а-яё]\"?[,:;]?\z/i }
                   .size)
                   .to eq(0)
    end
  end


  it 'should allow only particular signs in the end of the sentence' do 
    1000.times do 
      expect(rl_str_gen.match?(/.*[а-яё]+\"?(\.|!|\?|\?!|\.\.\.)\z/))
                       .to be true
    end
  end


  it 'should not allow unwanted symbols inside words' do 
    1000.times do
      expect(rl_str_gen.match /[А-ЯЁ-][^А-ЯЁ -]+[А-ЯЁ-]/i).to be_nil
    end
  end


  it 'should unclude unwanted symbyls before words' do 
    1000.times do 
      expect(rl_str_gen.match /(?<![А-ЯЁ])[^ \"А-ЯЁ]+\b[А-ЯЁ]/i).to be_nil
    end
  end


  it 'should not allow multiple punctuation marks' do
    1000.times do 
      expect(rl_str_gen.match(/([^а-яё.]) *\1/i)).to be_nil
    end
  end


  it 'should correctly use quotation marks' do
    1000.times do 
      str = rl_str_gen
      expect(str.scan(/\"/).size.even?).to be true
      expect(str.scan(/\".+?\"/i)
                .reject {|el| el.match? /\"[а-яё].+[а-яё]\"/i }
                .size) 
                .to eq(0)
    end
  end


  it 'should not allow words starting with ь, ъ, ы' do 

  end


  it 'should not contain capital letters insider words if not an acronym' do 

  end


  it 'should allways have a vowel after й at the begining of the word' do

  end


  it 'should not allow more than 4 consonant letters in a row' do 

  end


  it 'should not allow more than 2 vowel letters in a raw' do 

  end


  it 'should not allow more than 2 same consonant letters in a raw' do 

  end


  it 'should contain vowels if more than 1 letter and not and acronym' do 

  end

end