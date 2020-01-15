require './lib/enigma'

enigma = Enigma.new

handle = File.open(ARGV[0], "r")

incoming_text = handle.read.gsub("\n", "")

handle.close

cracked_text = enigma.crack(incoming_text, ARGV[2])

writer = File.open(ARGV[1], "w")

writer.write(cracked_text[:decryption])

writer.close
puts "Created #{ARGV[1]} with the key #{cracked_text[:key]} and date #{cracked_text[:date]}"
