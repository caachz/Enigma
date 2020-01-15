require 'date'
require './lib/generatable'
require './lib/cryptable'
require './lib/crackable'

class Enigma
  include Generatable
  include Cryptable
  include Crackable

  def encrypt(message, key = random_key_generator, date = date_generator)
    new_message = cryption(message, key, date, true)
    {:encryption=> new_message, :key => key, :date => date}
  end

  def decrypt(message, key, date = date_generator)
    new_message = cryption(message, key, date, false)
    {:decryption=> new_message, :key => key, :date => date}
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
