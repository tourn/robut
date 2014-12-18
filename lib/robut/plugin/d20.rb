# A simple plugin that replies with "pong" when messaged with ping
class Robut::Plugin::D20
  include Robut::Plugin

  DIE_PATTERN = /(?<count>[1-9]\d*)d(?<die>[1-9]\d*)((?<bonus>[+-][1-9]\d*))?/i
  DIE_CAP = 999

  class Die
    attr_accessor :result

    def initialize(sides)
      raise "a d#{side} is kinda weird, no?" if sides < 1
      @result = rand(sides) + 1
    end

    def to_s
      @result.to_s
    end

    def <=> other
      @result - other.result
    end
  end

  def usage
    "NdX[+B] - rolls N dice of size X, optionally adds B as static bonus"
  end

  def handle(time, sender_nick, message)
    match = DIE_PATTERN.match(message)
    if match
      bonus = match['bonus'].to_i
      count = match['count'].to_i
      die = match['die'].to_i

      if count > DIE_CAP || die > DIE_CAP
        reply "Nope."
      else
        dice = count.times.collect do
          Die.new(die)
        end
        dice.sort!
        total = dice.reduce(0) { |sum, die| sum + die.result }
        total += bonus
        reply "#{sender_nick} rolled #{match}: #{total} (#{dice.join(", ")})"
      end
    end
  end
end
