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

    assert_equal ({:a => 02, :b => 27, :c => 71, :d => 15}), @enigma.key(rand_num)
  end

  def test_it_creates_a_hash_from_date
    assert_equal 1025, @enigma.offset_code("040895")

    assert_equal ({:a => 1, :b => 0, :c => 2, :d => 5}), @enigma.offset_hash("040895")
  end

  def test_it_creates_a_final_shift_hash
    assert_equal ({:a => 3, :b => 27, :c => 73, :d => 20}), @enigma.shift({:a => 02, :b => 27, :c => 71, :d => 15}, {:a => 1, :b => 0, :c => 2, :d => 5})
  end

  def test_shifted_letter_returns_the_correct_shifted_letter
    skip
    assert_equal "k", @enigma.shift("h", 3)
    assert_equal "w", @enigma.shift("d", 73)
    assert_equal "r", @enigma.shift("o", 3)
  end

  def test_string_hash_with_letter_as_key_and_shift_amount_as_value
    skip
    enigma = mock("enigma")
    enigma.stubs(:shift).returns({:a => 3, :b => 27, :c => 73, :d => 20})

    assert_equal ({"h1" => 3, "e2" => 27, "l3" => 73, "l4" => 20,"o5" => 3, " 6" => 27, "w7" => 73, "o8" => 20, "r9" => 3, "l1" => 27, "d2" => 73}), enigma.shiftable_alphabet(enigma.shift)
  end

  def test_returns_final_encoded_message
    skip
    assert_equal "keder ohulw", @enigma.encoded_message({"h1" => 3, "e2" => 27, "l3" => 73, "l4" => 20,"o5" => 3, " 6" => 27, "w7" => 73, "o8" => 20, "r9" => 3, "l1" => 27, "d2" => 73})
  end
end
