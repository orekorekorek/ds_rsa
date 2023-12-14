require_relative 'lib/digital_signature'

DEFAULT_FAILURE_MESSAGE = '[FAILURE] The message being checked does not match the signed one'.freeze

puts 'Enter a message to sign: '
message = $stdin.gets.chomp

puts 'Enter the first prime number'
p = $stdin.gets.chomp.to_i

puts 'Enter the second prime number'
q = $stdin.gets.chomp.to_i

rsa = RSA.new(p, q)

signatured_message = DigitalSignature.new(rsa).sign(message)

puts "[INFO] Verifying correctness of #{signatured_message} signatured_message"

result = DigitalSignature.new(rsa).check_signature(signatured_message)

if result
  puts '[SUCCESS] The message being checked corresponds to the signed one'
else
  puts rsa.error_message || DEFAULT_FAILURE_MESSAGE
end
