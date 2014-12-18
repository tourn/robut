# A simple plugin that replies with "pong" when messaged with ping
class Robut::Plugin::D20
  include Robut::Plugin

  DIE_PATTERN = /(?<count>[1-9]\d*)d(?<die>[1-9]\d*)(?<bonus>[+-][1-9]\d*)?([^d]|$)/i
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

  class Roll
    def initialize(match)
      count = match[0].to_i
      die = match[1].to_i
      bonus = match[2].to_i

      @string = "#{count}d#{die}"
      @string += "+#{bonus}" if bonus > 0
      @string += "#{bonus}" if bonus < 0
      @string += ": "
      if count > DIE_CAP || die > DIE_CAP
        @string += "Nope"
      else
        dice = count.times.collect do
          Die.new(die)
        end
        dice.sort!
        @total = dice.reduce(0) { |sum, die| sum + die.result }
        @total += bonus
        @string += "#{@total} (#{dice.join(", ")})"
      end
    end

    def to_s
      @string
    end

    def to_i
      @total
    end
  end

  def usage
    "NdX[+B] - rolls N dice of size X, optionally adds B as static bonus"
  end

  def handle(time, sender_nick, message)
    match = message.scan(DIE_PATTERN)
    if match.size == 1
      reply "#{sender_nick} rolled " + Roll.new(match.first).to_s
    elsif match.size > 1
      msg = "#{sender_nick} rolled: "
      total = 0
      match.each do |m|
        r = Roll.new(m)
        total += r.to_i
        msg += "\n  #{r}"
      end
      msg += "\n----\n#{total}"
      reply msg
    end
  end

end
