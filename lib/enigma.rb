class Enigma
  def key(random_number)
    key = {}
    key[:a] = random_number[0..1].join.to_i
    key[:b] = random_number[1..2].join.to_i
    key[:c] = random_number[2..3].join.to_i
    key[:d] = random_number[3..4].join.to_i
    key
  end

  def offset_code(date)
    squared = date.to_i ** 2
    squared.to_s[-4..-1].to_i
  end

  def offset_hash(date)
    code = offset_code(date)
    offset = {}
    offset[:a] = code.to_s[0].to_i
    offset[:b] = code.to_s[1].to_i
    offset[:c] = code.to_s[2].to_i
    offset[:d] = code.to_s[3].to_i
    offset
  end

  def shift(key, offset)
    key.merge(offset) {|key, oldval, newval| oldval + newval}
  end

  def letter_shifter(letter, number_to_shift, direction)
    alphabet = ("a".."z").to_a
    alphabet << " "
    number_to_shift = number_to_shift %  27
    letter_index = alphabet.find_index(letter)
    letter_index = letter_index += number_to_shift if direction
    letter_index = letter_index += number_to_shift if !direction
    alphabet[letter_index]
  end
end
