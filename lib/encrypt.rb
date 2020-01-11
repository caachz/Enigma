require './lib/enigma'

enigma = Enigma.new

handle = File.open(ARGV[0], "r")

incoming_text = handle.read.gsub("\n", "")

handle.close

encrypted_text = enigma.encrypt(incoming_text, ARGV[2], ARGV[3])

writer = File.open(ARGV[1], "w")

writer.write(encrypted_text[:encryption])

writer.close

puts "Created #{ARGV[1]} with the key #{encrypted_text[:key]} and date #{encrypted_text[:date]}"
