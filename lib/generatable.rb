module Generatable

  def random_key_generator
    number = ""
    5.times do
      number += rand(9).to_s
    end
    number
  end

  def date_generator
    Date.today.strftime("%d%m%y")
  end
end
