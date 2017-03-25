require 'ecdsa'
require 'base64'

msghash1_hex = 'EDIT'
msghash2_hex = 'EDIT'

sig1_base64 = ECDSA::Format::SignatureDerString.decode(Base64.decode64('EDIT'))
sig2_base64 = ECDSA::Format::SignatureDerString.decode(Base64.decode64('EDIT'))

sig1 = ECDSA::Signature.new(sig1_base64.r, sig1_base64.s)
sig2 = ECDSA::Signature.new(sig2_base64.r, sig2_base64.s)

group = ECDSA::Group::Secp256k1

def hex_to_binary(str)
  str.scan(/../).map(&:hex).pack('C*')
end

msghash1 = hex_to_binary(msghash1_hex)
msghash2 = hex_to_binary(msghash2_hex)

r = sig1.r
puts 'sig r: %#x' % r
puts 'sig1 s: %#x' % sig1.s
puts 'sig2 s: %#x' % sig2.s

# Step 1: k = (z1 - z2)/(s1 - s2)
field = ECDSA::PrimeField.new(group.order)
z1 = ECDSA::Format::IntegerOctetString.decode(msghash1)
z2 = ECDSA::Format::IntegerOctetString.decode(msghash2)

k_candidates = [
  field.mod((z1 - z2) * field.inverse(sig1.s - sig2.s)),
  field.mod((z1 - z2) * field.inverse(sig1.s + sig2.s)),
  field.mod((z1 - z2) * field.inverse(-sig1.s - sig2.s)),
  field.mod((z1 - z2) * field.inverse(-sig1.s + sig2.s)),
]

puts "\n"

private_key = nil
k_candidates.each do |k|
  private_key_maybe = field.mod(field.mod(sig1.s * k - z1) * field.inverse(r))
  puts 'Private key: %#x' % private_key_maybe
  public_key = group.generator.multiply_by_scalar(private_key_maybe)
  puts 'Public key: '
  puts '  X: %#x' % public_key.x
  puts '  Y: %#x' % public_key.y
  next
end
