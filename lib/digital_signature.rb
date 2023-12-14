require 'digest'
require 'logger'
require_relative 'rsa'

class DigitalSignature
  def initialize(rsa)
    @rsa = rsa
    @logger = Logger.new($stdout)
  end

  def sign(message)
    logger.debug("I`m a private key : #{rsa.private_key}")

    m = hash(message).to_i(16)
    logger.info("I`m a message hash : #{m}")

    s = m.pow(rsa.private_key[:d], rsa.private_key[:mod])

    { m: message, s: s }
  end

  def check_signature(signed_message)
    logger.debug("I`m a public key: #{rsa.public_key}")

    proto = signed_message[:s].pow(rsa.public_key[:e], rsa.public_key[:mod])
    logger.debug("I`m a decrypted message hash from signature : #{proto}")

    proto == hash(signed_message[:m]).to_i(16) % rsa.public_key[:mod]
  end

  private

  attr_reader :rsa, :logger

  def hash(message)
    Digest::SHA256.hexdigest(message)
  end
end
