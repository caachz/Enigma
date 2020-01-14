require 'date'
require './lib/generatable'
require './lib/cryptable'

class Enigma
  include Generatable
  include Cryptable

  def encrypt(message, key = random_key_generator, date = date_generator)
    new_message = cryption(message, key, date, true)
    {:encryption=> new_message, :key => key, :date => date}
  end

  def decrypt(message, key, date = date_generator)
    new_message = cryption(message, key, date, false)
    {:decryption=> new_message, :key => key, :date => date}
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

  def key_start_values(date, crack_message_hash)
    combined = []
    4.times do
      top = crack_message_hash.max_by do |letter, shifted|
        letter_placement = letter[1..-1].to_i
      end
      combined << top[1]
      crack_message_hash.delete(top[0])
    end
    offset = offset_hash(date)
    key_start_values = []
    key_start_values << combined[0] - offset[:a]
    key_start_values << combined[1] - offset[:b]
    key_start_values << combined[2] - offset[:c]
    key_start_values << combined[3] - offset[:d]
  end

  def key_cracker_options(start_values)
    options = start_values.reduce([]) do |acc, value|
      value_options = []
      4.times do
        value_options << value.to_s
        value += 27
      end
      acc << value_options
      acc
    end

    options = options.map do |option_array|
      option_array.map do |option|
        option = "0" + option if option.length == 1
        option
      end
    end
  end

  def narrow_down_keys(options, direction)
    final_array = []
    options.each do |option|
      inner_array = []
      comparison = options.find_index(option) + 1
      options[options.find_index(option)].each do |first_element|
        next if options.find_index(option) + 1 == 4
        options[comparison].each do |second_element|
          inner_array << first_element if first_element[1] == second_element[0] && direction
          inner_array << first_element if first_element[0] == second_element[1] && !direction
        end
        end
        final_array << inner_array
      end
    final_array
  end

  def combine_key_options(combined)
    result = combined.reduce([]) do |acc, key_options|
      if key_options[0].length == 0 || key_options[1].length == 0
        acc << (key_options[0] | key_options[1])
      else
        acc << (key_options[0] & key_options[1])
      end
      acc
    end
  end

  def cracked_keys(options)
    right_narrow = narrow_down_keys(options, true)
    left_narrow = narrow_down_keys(options.reverse, false).reverse
    combined = right_narrow.zip(left_narrow)
    result = combine_key_options(combined)
    right_result = narrow_down_keys(result, true)
    left_result = narrow_down_keys(result.reverse, false).reverse
    final_combined = left_result.zip(right_result)
    final_combined = combine_key_options(final_combined)
    final_combined.flatten
  end

  def cracked_keysarray_to_key(values)
    final = ""
    values.each do |value|
      final += value[0]
      final += value[1] if values[-1] == value
    end
    final
  end

  def crack(message, date = date_generator)
    shift = code_to_crack(message)
    message_hash = cracked_shifter(message, shift)
    message = crack_message(message_hash)

    key_start_values = key_start_values(date, message_hash)
    all_key_options = key_cracker_options(key_start_values)
    keys_array = cracked_keys(all_key_options)
    key = cracked_keysarray_to_key(keys_array)

    {:decryption => message, :date => date, :key => key}
  end
end
