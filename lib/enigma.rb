require 'date'
require './lib/generatable'
require './lib/cryptable'

class Enigma
  include Generatable
  include Cryptable

  def encrypt(message, key = random_key_generator, date = date_generator)
    final_key = key_hash(key)
    date_hash = offset_hash(date)
    combined_hash = combined_hash(final_key, date_hash)
    final_hash =  final_hash(message, combined_hash)
    new_message = coded_message(final_hash, true)
    {:encryption=> new_message, :key => key, :date => date}
  end

  def decrypt(message, key, date = date_generator)
    final_key = key_hash(key)
    date_hash = offset_hash(date)
    combined_hash = combined_hash(final_key, date_hash)
    final_hash =  final_hash(message, combined_hash)
    new_message = coded_message(final_hash, false)
    {:decryption=> new_message, :key => key, :date => date}
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
