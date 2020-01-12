require 'date'
require './lib/generatable'

class Enigma
  include Generatable

  def encrypt(message, key = random_key_generator, date = date_generator)
    key_hash = key_hash(key)
    date_hash = offset_hash(date)
    combined_hash = combined_hash(key_hash, date_hash)
    final_hash =  final_hash(message, combined_hash)
    new_message = coded_message(final_hash, true)
    {:encryption=> new_message, :key => key, :date => date}
  end

  def decrypt(message, key, date = date_generator)
    key_hash = key_hash(key)
    date_hash = offset_hash(date)
    combined_hash = combined_hash(key_hash, date_hash)
    final_hash =  final_hash(message, combined_hash)
    new_message = coded_message(final_hash, false)
    {:decryption=> new_message, :key => key, :date => date}
  end

  def key_hash(key_input)
    key = {}
    key[:a] = key_input[0..1].to_i
    key[:b] = key_input[1..2].to_i
    key[:c] = key_input[2..3].to_i
    key[:d] = key_input[3..4].to_i
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

  def letter_shifter(letter, number_to_shift, direction = true)
    alphabet = ("a".."z").to_a
    alphabet << " "
    letter_index = alphabet.find_index(letter)
    rotated_alphabet = alphabet.rotate(number_to_shift) if direction
    rotated_alphabet = alphabet.rotate(-number_to_shift) if !direction
    rotated_alphabet[letter_index]
  end

  def final_hash(message, combined_hash)
    message = message.downcase.split(//)
    acc = {}
    message.each_with_index do |letter, index|
        acc[letter + index.to_s] = combined_hash.values[index % 4]
    end
    acc
  end

  def coded_message(final_hash, direction)
    encoded = final_hash.reduce("") do |acc, (letter, shift)|
      acc += letter_shifter(letter[0], shift, direction)
      acc
    end
  end

  def code_to_crack(message)
    last_four = message[-4..-1].split(//)
    matching = ([" ", "e", "n", "d"])
    alphabet = ("a".."z").to_a
    alphabet << " "
    code =  []
    matching_index = 0
    last_four.each do |letter|
      index = alphabet.find_index(letter)
      place_counter = 0
      until alphabet[index] == matching[matching_index] do
        alphabet = alphabet.rotate(-1)
        place_counter += 1
      end
      matching_index += 1
      code << place_counter
    end
    code.reverse
  end

  def cracked_shifter(message, amounts_shifted)
    message = message.split(//)
    unique_identifier = 0
    message.reverse.reduce({}) do |acc, letter|
      acc[letter += unique_identifier.to_s] = amounts_shifted[0]
      unique_identifier += 1
      amounts_shifted = amounts_shifted.rotate
      acc
    end
  end

  def crack_message(cracked_shifter)
    cracked_message = cracked_shifter.reduce("") do |acc, (letter, shift_amount)|
      acc += letter_shifter(letter[0], shift_amount, false)
      acc
    end
    cracked_message.reverse
  end
end
