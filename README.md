# ECDSA Breaker
This tool, written in Ruby, allows to guess the private key of the ECDSA when there is a flaw into the signature function. In particular, if the value k of this function is not random and it is used more then one time, the private key can be retrieved.

S = k^-1 (z + dA *R)

- S = Signature
- k = Random number
- z = Message hash
- dA = Private key
- R = Group

If you want go deeper, I suggest you to read [this](http://kakaroto.homelinux.net/2012/01/how-the-ecdsa-algorithm-works/).

## Requirements
This tool uses [ecdsa](https://rubygems.org/gems/ecdsa) library and can be installed with:

`gem install ecdsa`

## Usage
You need to edit 4 variables before running the script:

- `msghash1_hex` and `msghash2_hex` are the SHA2 hashes of the plaintext.
- `sig1_base64` and `sig2_base64` are the signatures of the messages encoded in base64.
- `group` is the elliptic curve group

## Credits
Thanks to [DavidEGrayson](https://github.com/DavidEGrayson/) for his [ruby_ecdsa](https://github.com/DavidEGrayson/ruby_ecdsa) repository where I found some code snippets and other useful things for this script.
