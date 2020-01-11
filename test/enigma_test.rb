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
    enigma.stubs(:random_number).returns([0,2,7,1,5])
    rand_num = enigma.random_number
    assert_equal [0,2,7,1,5], rand_num

    assert_equal ({:a => 02, :b => 27, :c => 71, :d => 15}), @enigma.key_hash(rand_num)
  end

  def test_it_creates_a_hash_from_date
    assert_equal 1025, @enigma.offset_code("040895")

    assert_equal ({:a => 1, :b => 0, :c => 2, :d => 5}), @enigma.offset_hash("040895")
  end

  def test_it_creates_a_final_shift_hash
    assert_equal ({:a => 3, :b => 27, :c => 73, :d => 20}), @enigma.shift({:a => 02, :b => 27, :c => 71, :d => 15}, {:a => 1, :b => 0, :c => 2, :d => 5})
  end

  def test_shifted_letter_returns_the_correct_shifted_letter
    assert_equal "e", @enigma.letter_shifter("h", 3, false)
    assert_equal "w", @enigma.letter_shifter("d", 73, true)
    assert_equal "r", @enigma.letter_shifter("o", 3, true)
    assert_equal "d", @enigma.letter_shifter("l", 73)
  end

  def test_string_hash_with_letter_as_key_and_shift_amount_as_value
    assert_equal ({"h0" => 3, "e1" => 27, "l2" => 73, "l3" => 20,"o4" => 3, " 5" => 27, "w6" => 73, "o7" => 20, "r8" => 3, "l9" => 27, "d10" => 73}), @enigma.message_to_encode("Hello World", {:a => 3, :b => 27, :c => 73, :d => 20})
  end

  def test_returns_final_encoded_message
    assert_equal "keder ohulw", @enigma.encoded_message({"h0" => 3, "e1" => 27, "l2" => 73, "l3" => 20,"o4" => 3, " 5" => 27, "w6" => 73, "o7" => 20, "r8" => 3, "l9" => 27, "d10" => 73})
  end

  def test_it_calculates_a_random_key_if_not_given_one
    assert_equal 5, @enigma.random_key_generator.length
  end

  def test_it_calcualtes_todays_date_if_not_given_a_date
    assert_equal 6, @enigma.date_generator.length
  end

  def test_it_fully_encripts_a_message
    assert_equal ({encryption: "keder ohulw", key: "02715", date: "040895"}), @enigma.encrypt("hello world", "02715", "040895")

    assert_equal ({encryption: "keder ohulw", key: "02715", date: "040895"}), @enigma.encrypt("hello world", "02715")

    assert_equal 11, ({encryption: "keder ohulw", key: "02715", date: "040895"}), @enigma.encrypt("hello world")[encryption:].length
    assert_equal 5, @enigma.encrypt("hello world")[key:].length
    assert_equal 6, @enigma.encrypt("hello world")[date:].length
  end
end
