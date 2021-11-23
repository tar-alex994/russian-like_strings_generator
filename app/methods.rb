def rl_str_gen    #russian-like string generator
  base_string
end


def base_string
  x = [*1040..1103, 1105, 1025]  
  arr = Array.new(rand(3..250)) { x.sample }

  index = rand(1..15)

  while index < arr.size
    arr[index] = 32
    index += rand(2..16)
  end

  arr.pack("U*")
end


def plan_words
  arr    = Array.new(rand(2..15)) {{}}
  #arr[0] = {case:           :down_case, 
  #          multi_syllable: true, 
  #          dash:           true, 
  #          one_letter:     false
  #        }

  arr.each do |el|
    case rand(10)
    when 0 
      el[:case] = :acronym
    when 1
      el[:case] = :capital
    else
      el[:case] = :down_case
    end

    if el[:case] != :acronym
      el[:multi_syllable] = rand(5) == 0 ? false : true
    end

    if el[:multi_syllable] == true
      el[:dash] = rand(20) == 0 ? true : false
    elsif el[:multi_syllable] == false
      if rand(2) == 0 ? true : false
        el[:one_letter] = true
        el[:case]       = :down_case
      else
        el[:one_letter] = false
      end
    end
  end
end

def words_gen(arr)
  arr.map do |el|
    case el[:case]
    when :acronym
      make_acronym
    when :down_case
      make_common_word(el)     #el.make_common_word
    when :capital
      digital_capitalize(make_common_word(el))
    end
  end
end


def make_acronym
  letters = [*1040..1048, *1050..1065, *1069..1071, 1025]
  Array.new(rand(2..5)) { letters.sample }
end


def make_comon_word(hash)
  #'should not allow words starting with ь, ъ, ы'
  'should not allow one-letter words whith a capital letter'
  'should allways have a vowel after й at the begining of the word'
  'should allow only particular letters after й insider words'
  'should allways be a vowel in 2- and 3- letter words'
  'should allow only particular one letter words'
  'should not allow more than 4 consonant letters in a row'
  'should not allow more than 2 vowel letters in a raw' 
  'should not allow more than 2 same consonant letters in a raw'
  'should contain atleast 40% vowels in multi-syllable word'
  'should contain 5 or less consonants in a single-syllable word'
  "should not allow a vowel at the begining of the word"\
     "in a single-syllable word if they have 3 or more letters"

  'should allow only я, е, ё, ю after ъ'

  if hash[:multi_syllable]
    word = generate_multi_syllable_word
  elsif hash[:one_letter]
    word = [1072, 1103, 1074, 1086, 1091, 1080, 1082, 1089].sample
  else
    word = generate_single_syllable_word
  end

  word = add_dash(word) if hash[:dash]

  word
end


def digital_capitalize(arr)
  if arr[0] == 1105
    arr[0] = 1025
  elsif arr[0] > 1071
    arr[0] -= 32
  end

  arr
end