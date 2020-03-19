# Enigma

## Background and Description

1 week solo sprint project to to build a tool for encrypting, decrypting and cracking an encryption algorithm based on the Turing machine.

# Key Learnings:
OOP, understanding of encryption algorithms, code organization using modules.

### Implementation Instructions
To set up locally:
 * Clone down the repository.
 
 To encrypt:
 * Open the message.txt file and write your message to encrypt
 * Run this command in your terminal. 
 ```ruby
  $ ruby ./lib/encrypt.rb message.txt encrypted.txt
```
 * You will receive this message with the key and date used to encrypt your message. The encrypted message will be shown 
 printed in the encrypted.txt file.
    * "Created encrypted.txt with the key 50816 and date 190320" 
    
To decrypt: 
* Put an encrypted message in your decrypted.txt file.
* Run this command in your terminal. 
 * Make sure you have the key and date to pass in to the dycryption file.
 ```ruby
  $ ruby ./lib/decrypt.rb encrypted.txt decrypted.txt 82648 240818
```

To crack: 
* Put an encrypted message in your decrypted.txt file.
* Run this command in your terminal. 
 * Make sure you have date to pass in to the dycryption file or it will default to using today's date.
 ```ruby
  $ ruby ./lib/crack.rb encrypted.txt cracked.txt 240818
```
