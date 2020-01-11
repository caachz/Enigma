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

  def letter_shifter(letter, number_to_shift, direction = true)
    alphabet = ("a".."z").to_a
    alphabet << " "
    letter_index = alphabet.find_index(letter)
    rotated_alphabet = alphabet.rotate(number_to_shift) if direction
    rotated_alphabet = alphabet.rotate(-number_to_shift) if !direction
    rotated_alphabet[letter_index]
  end

  def message_to_encode(message, shift)
    message = message.downcase.split(//)
    acc = {}
    message.each_with_index do |letter, index|
        acc[letter + index.to_s] = shift.values[index % 4]
    end
    acc
  end

  def encoded_message(message_to_encode)
    encoded = message_to_encode.reduce("") do |acc, (letter, shift)|
      acc += letter_shifter(letter[0], shift, true)
      acc
    end
  end
end
