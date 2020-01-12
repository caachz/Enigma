require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/enigma'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_creates_a_randomly_generated_key
    enigma = mock("enigma")
    enigma.stubs(:random_number).returns("02715")
    rand_num = enigma.random_number
    assert_equal "02715", rand_num

    assert_equal ({:a => 02, :b => 27, :c => 71, :d => 15}), @enigma.key_hash(rand_num)
  end

  def test_it_creates_a_hash_from_date
    assert_equal ({:a => 1, :b => 0, :c => 2, :d => 5}), @enigma.offset_hash("040895")
  end

  def test_it_creates_a_final_shift_hash
    assert_equal ({:a => 3, :b => 27, :c => 73, :d => 20}), @enigma.combined_hash({:a => 02, :b => 27, :c => 71, :d => 15}, {:a => 1, :b => 0, :c => 2, :d => 5})
  end

  def test_shifted_letter_returns_the_correct_shifted_letter
    assert_equal "e", @enigma.letter_shifter("h", 3, false)
    assert_equal "w", @enigma.letter_shifter("d", 73, true)
    assert_equal "r", @enigma.letter_shifter("o", 3, true)
    assert_equal "d", @enigma.letter_shifter("l", 73)
  end

  def test_string_hash_with_letter_as_key_and_shift_amount_as_value
    assert_equal ({"h0" => 3, "e1" => 27, "l2" => 73, "l3" => 20,"o4" => 3, " 5" => 27, "w6" => 73, "o7" => 20, "r8" => 3, "l9" => 27, "d10" => 73}), @enigma.final_hash("Hello World", {:a => 3, :b => 27, :c => 73, :d => 20})
  end

  def test_returns_final_encoded_message
    assert_equal "keder ohulw", @enigma.coded_message({"h0" => 3, "e1" => 27, "l2" => 73, "l3" => 20,"o4" => 3, " 5" => 27, "w6" => 73, "o7" => 20, "r8" => 3, "l9" => 27, "d10" => 73}, true)
  end

  def test_it_calculates_a_random_key_if_not_given_one
    assert_equal 5, @enigma.random_key_generator.length
  end

  def test_it_calcualtes_todays_date_if_not_given_a_date
    assert_equal 6, @enigma.date_generator.length
  end

  def test_it_fully_encripts_a_message
    assert_equal ({encryption: "keder ohulw", key: "02715", date: "040895"}), @enigma.encrypt("hello world", "02715", "040895")

    assert_equal ({:encryption=>"nib udmcxpu", :key=>"02715", :date=>"110120"}), @enigma.encrypt("hello world", "02715")

    assert_equal 11, @enigma.encrypt("hello world")[:encryption].length
    assert_equal 5, @enigma.encrypt("hello world")[:key].length
    assert_equal 6, @enigma.encrypt("hello world")[:date].length
  end

  def test_decrypt_message
    assert_equal ({decryption: "hello world", key: "02715", date: "040895"}), @enigma.decrypt("keder ohulw", "02715", "040895")
  end

  def test_it_returns_an_array_of_4_digits_to_crack
    assert_equal [5,5,14,19], @enigma.code_to_crack("vjqtbeaweqihssi")
  end

  def test_it_produces_a_hash_with_amount_shifted
    assert_equal ({v14: 14, j13: 5, q12: 5, t11: 19, b10: 14, e9: 5, a8: 5, w7: 19, e6: 14, q5: 5, i4: 5, h3: 19, s2: 14, s1: 5, i0: 5}), @enigma.cracked_shifter("vjqtbeaweqihssi", [5,5,14,19])
  end

  def test_it_returns_cracked_message
    assert_equal "hello world", @enigma.craked_code
  end

  def test_it_calculates_the_key_from_the_code_to_crack
    assert_equal "08304", @enigma.key_cracker("291018", "hello world end")
  end
end
