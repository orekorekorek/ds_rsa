require 'prime'

class RSA
  FERMAT_NUMBERS = [17, 257, 65_537].freeze

  class NotPrimeError < StandardError; end

  def initialize(p, q)
    @p = p
    @q = q
    @errors = []

    check_numbers
  end

  def public_key
    { e: public_exponent, mod: mod }
  end

  def private_key
    { d: private_exponent, mod: mod }
  end

  def error_message
    return if errors.empty?

    errors.first
  end

  private

  attr_reader :p, :q, :errors

  def public_exponent
    @public_exponent ||= FERMAT_NUMBERS.shuffle.find { |n| n < euler_value }
  end

  def private_exponent
    @private_exponent ||= mult_inverted(public_exponent, euler_value)
  end

  def mult_inverted(e, fi)
    (0..fi).each do |step|
      k = (step * fi) + 1
      return k / e if (k % e).zero?
    end

    nil
  end

  def mod
    @mod ||= p * q
  end

  def euler_value
    @euler_value ||= (p - 1) * (q - 1)
  end

  def check_numbers
    if p == q
      errors << 'Numbers are equal'
    elsif !p.prime? || !q.prime?
      errors << 'Numbers are not prime'
    end
  end
end
