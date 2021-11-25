require 'rspec'
require_relative '../app/methods'

describe 'get_no_insert_range' do 
  it 'should correctly find 4 consonants in a row groups' do
    1000.times do 
      word  = Array.new(rand(12)) {rand(1072..1103)}
      check = word.chunk {|el| VOWELS.any?(el)}
                  .to_a
                  .select {|el| el[1].size > 3 and el[0] == false}
                  .map {|el| el[1][0..3]}

      my_test = get_no_insert_range(word).map {|r| word[r][0, 4]}

      expect(my_test).to eq(check)
    end
  end
end


describe 'Resulting sentence' do

  before(:all) do 
    @string = rl_str_gen
  end

  it 'should return a string' do 
    expect(@string).to be_an_instance_of(String)
  end


  it 'should  contain only valid symbols' do 
    expect(@string.match /[^A-ЯЁ,\.:\-!\?\"; ]/i).to be_nil
  end


  it 'should not be ower 300 symbols' do 
    expect(@string.size).to be <= 300
  end


  it 'should contain from 2 to 15 words' do 
    str = @string

    expect(str.size).to be <= 300
    expect(str.gsub('- ', '').match?(/\A(?:[^ ]+ +){1,14}[^ ]+ *\z/)).to be true
  end


  it 'should not contain words over 15 letters' do
    words = @string.scan(/[А-ЯЁ]+(?:-[А-ЯЁ]+)?/i)
    expect(words.count { |el| el.size > 15}).to eq(0)
  end


  it 'should allow only particular marks after words within sentence' do
    within = @string.split.reject{ |el| el == '-' }[0..-2]

    expect(within.reject { |el| el.match? /[а-яё]\"?[,:;]?\z/i }
                 .size)
                 .to eq(0)
  end


  it 'should allow only particular signs in the end of the sentence' do 
    expect(@string.match?(/.*[а-яё]+\"?(\.|!|\?|\?!|\.\.\.)\z/))
                     .to be true
  end


  it 'should not allow unwanted symbols inside words' do 
    expect(@string.match /[А-ЯЁ-][^А-ЯЁ -]+[А-ЯЁ-]/i).to be_nil
  end


  it 'should unclude unwanted symbyls before words' do 
    expect(@string.match /(?<![А-ЯЁ])[^ \"А-ЯЁ]+\b[А-ЯЁ]/i).to be_nil
  end


  it 'should not allow multiple punctuation marks' do
    expect(@string.match(/([^а-яё.]) *\1/i)).to be_nil
  end


  it 'should correctly use quotation marks' do
    str = @string
    expect(str.scan(/\"/).size.even?).to be true
    expect(str.scan(/\".+?\"/i)
              .reject {|el| el.match? /\"[а-яё].+[а-яё]\"/i }
              .size) 
              .to eq(0)
  end


  it 'should not allow words starting with ь, ъ, ы' do 
    expect(@string.match /\b[ьъы]/i).to be_nil
  end


  it 'should not contain capital letters insider words if not an acronym' do 
    @string
    .gsub(/[^А-ЯЁ ]/i, '')
    .split
    .each do |word|
      unless word.match? /\A[А-ЯЁ]{2,}\z/
        expect(word.match /\A.+[А-ЯЁ]/).to be_nil
      end
    end
  end


  it 'should allow acronyms only to 5 letters long' do 
    acr = @string.gsub(/[^А-ЯЁ ]/i, '').scan(/[А-ЯЁ]{2,}/)

    expect(acr.count{ |a| a.size > 5}).to eq(0)
  end


  it 'should not allow one-letter words whith a capital letter' do 
    expect(@string.match /\ \"?[А-ЯЁ]\b/).to be_nil
  end


  it 'should allways have a vowel after й at the begining of the word' do
    expect(@string.match /\bй[^ео]/i).to be_nil
  end


  it 'should allow only particular letters after й insider words' do 
    expect(@string.match /\Bй[ьъыёуиаэюжй]/i).to be_nil
  end


  it 'should allways be a vowel in 2- and 3- letter words' do 
    @string
    .gsub(/[^А-ЯЁ ]/i, '')
    .split
    .select { |el| el.size == 2 || el.size == 3 }
    .reject { |el| el.match?(/\A[А-ЯЁ]+\z/) }
    .each do |word|
      expect(word).to match(/[аоуеыиэюяё]/i)
    end
  end


  it 'should allow only particular one letter words' do 
    @string.scan(/\b[А-ЯЁ]\b/i).each do |word|
      expect(word).to match(/[ЯВОУИКСА]/i)
    end
  end


  it 'should not allow more than 4 consonant letters in a row' do 
    @string
    .gsub(/[^А-ЯЁ ]/i, '')
    .split
    .each do |word|
      unless word.match? /\A[А-ЯЁ]{2,}\z/
        expect(word.match /[^аоуеыиэюяё]{5,}/i).to be_nil
      end
    end
  end


  it 'should not allow more than 2 vowel letters in a raw' do 
    @string
    .gsub(/[^А-ЯЁ ]/i, '')
    .split
    .each do |word|
      unless word.match? /\A[А-ЯЁ]{2,}\z/
        expect(word.match /[аоуеыиэюяё]{3,}/i).to be_nil
      end
    end
  end


  it 'should not allow more than 2 same consonant letters in a raw' do 
    @string
    .gsub(/[^А-ЯЁ ]/i, '')
    .split
    .each do |word|
      unless word.match? /\A[А-ЯЁ]{2,}\z/
        expect(word.match /([^аоуеыиэюяё])\1\1/i).to be_nil
      end
    end
  end


  it 'should start with a capital letter' do 
    expect(@string).to match(/\A\"?[А-ЯЁ]/)
  end


  it 'should contain atleast 40% vowels in multi-syllable word' do 
    @string
    .gsub(/[^А-ЯЁ ]/i, ' ')
    .split
    .select { |w| w.match? /[аоуеыиэюяё].*[аоуеыиэюяё]/i }
    .each do |el|
      unless el.match? /\A[А-ЯЁ]{2,}\z/
        found = el.scan(/[аоуеыиэюяё]/i).size 
        calc  = ((el.size - el.scan(/[ьъ]/i).size) * 0.4).to_i
        res   = found >= calc ? ">= #{calc} vowels" : "#{found} vowels"

        expect([res, el]).to eq([">= #{calc} vowels", el]) 
      end
    end
  end


  it 'should contain 5 or less consonants in a single-syllable word' do 
    @string
    .gsub(/[^А-ЯЁ -]/i, '')
    .split
    .reject { |w| w.match?(/-|([аоуеыиэюяё].*[аоуеыиэюяё])/i) ||
                  w.match?(/\A[А-ЯЁ]{2,}\z/)}
    .each do |word|
      expect(word.size).to be <= 6
    end
  end


  it "should not allow a vowel at the begining of the word"\
   "in a single-syllable word if they have 3 or more letters" do 
    @string
    .gsub(/[^А-ЯЁ -]/i, '')
    .split
    .reject { |w| w.match?(/-|([аоуеыиэюяё].*[аоуеыиэюяё])/i) ||
                  w.match?(/\A[А-ЯЁ]{2,}\z/) || 
                  w.size < 3 }
    .each do |word|
      expect(word).to match(/\A[^аоуеыиэюяё]/i)
    end
  end


  it 'should allow only я, е, ё, ю after ъ' do 
    expect(@string.gsub(/\b[А-ЯЁ]{2,}\b/,'').match(/ъ[^яеёю]/i)).to be_nil
  end


  it 'should forbit Ь and Ъ in acronyms' do 
    expect(@string.match(/(?=\b[А-ЯЁ]{2,}\b)\b[А-ЯЁ]*[ЪЬ][А-ЯЁ]*\b/)).to be_nil
  end

end
