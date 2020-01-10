require 'minitest/autorun'
require 'minitest/pride'
require './lib/enigma'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Engima, @enigma
  end

  def test_it_creates_a_randomly_generated_key
    skip
    enigma = mock("enigma")
    enigma.stubs(:random_number).returns([0,2,7,1,5])
    assert_equal [0,2,7,1,5], enigma.random_number

    assert_equal ({:a => 02, :b => 27, :c => 71, :d => 15}), enigma.key(enigma.random_number)
  end

  def test_it_creates_a_hash_from_date
    skip
    enigma = mock("enigma")
    enigma.stubs(:date).returns(040895)

    assert_equal 040895, enigma.date

    assert_equal 1672401025, enigma.date_squared(enigma.date)

    assert_equal 1025, engima.offset_code(engigma.date)

    assert_equal ({:a => 1, :b => 0, :c => 2, :d => 5}), enigma.offset(enigma.date)
  end

  def test_it_creates_a_final_shift_hash
    skip
    enigma = mock("enigma")
    enigma.stubs(:offset).returns({:a => 1, :b => 0, :c => 2, :d => 5})
    enigma.stubs(:key).returns({:a => 02, :b => 27, :c => 71, :d => 15})

    assert_equal ({:a => 3, :b => 27, :c => 73, d: => 20}) enigma.shift()
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
    enigma.stubs(:shift).returns({:a => 3, :b => 27, :c => 73, d: => 20})

    assert_equal ({"h" => 3, "e" => 27, "l" => 73, "l" => 20,"o" => 3, " " => 27, "w" => 73, "o" => 20, "r" => 3, "l" => 27, "d" => 73}), enigma.shiftable_alphabet(enigma.shift)
  end

  def test_returns_final_encoded_message
    skip
    assert_equal "keder ohulw", @enigma.encoded_message({"h" => 3, "e" => 27, "l" => 73, "l" => 20,"o" => 3, " " => 27, "w" => 73, "o" => 20, "r" => 3, "l" => 27, "d" => 73})
  end
end
