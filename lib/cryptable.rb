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

end
