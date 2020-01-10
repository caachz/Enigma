class Enigma
  def key(random_number)
    key = {}
    key[:a] = random_number[0..1].join.to_i
    key[:b] = random_number[1..2].join.to_i
    key[:c] = random_number[2..3].join.to_i
    key[:d] = random_number[3..4].join.to_i
    key
  end
end
