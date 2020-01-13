module Cryptable

  def key_hash(random_number)
    key = {}
    key[:a] = random_number[0..1].to_i
    key[:b] = random_number[1..2].to_i
    key[:c] = random_number[2..3].to_i
    key[:d] = random_number[3..4].to_i
    key
  end

  def offset_hash(date)
    squared = date.to_i ** 2
    code = squared.to_s[-4..-1].to_i
    offset = {}
    offset[:a] = code.to_s[0].to_i
    offset[:b] = code.to_s[1].to_i
    offset[:c] = code.to_s[2].to_i
    offset[:d] = code.to_s[3].to_i
    offset
  end

  def combined_hash(key_hash, date_hash)
    key_hash.merge(date_hash) {|key, oldval, newval| oldval + newval}
  end

  def message_hash(message, combined_hash)
    message = message.downcase.split(//)
    acc = {}
    message.each_with_index do |letter, index|
        acc[letter + index.to_s] = combined_hash.values[index % 4]
    end
    acc
  end

  def letter_shifter(letter, number_to_shift, direction = true)
    alphabet = ("a".."z").to_a
    alphabet << " "
    return letter if !alphabet.include?(letter)
    letter_index = alphabet.find_index(letter)
    rotated_alphabet = alphabet.rotate(number_to_shift) if direction
    rotated_alphabet = alphabet.rotate(-number_to_shift) if !direction
    rotated_alphabet[letter_index]
  end


  def coded_message(message_hash, direction)
    encoded = message_hash.reduce("") do |acc, (letter, shift)|
      acc += letter_shifter(letter[0], shift, direction)
      acc
    end
  end

  def cryption(message, key, date, de_or_encrypt)
    final_key = key_hash(key)
    date_hash = offset_hash(date)
    combined_hash = combined_hash(final_key, date_hash)
    message_hash =  message_hash(message, combined_hash)
    new_message = coded_message(message_hash, de_or_encrypt)
  end
end
