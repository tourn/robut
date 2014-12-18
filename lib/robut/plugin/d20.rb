# A simple plugin that replies with "pong" when messaged with ping
class Robut::Plugin::D20
  include Robut::Plugin

  DIE_PATTERN = /(?<count>[1-9]\d*)d(?<die>[1-9]\d*)(?<bonus>[+-][1-9]\d*)?[^d]/i
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
    match = message.scan(DIE_PATTERN)
    if match.size == 1
      reply "#{sender_nick} rolled " + roll(match.first)
    elsif match.size > 1
      msg = "#{sender_nick} rolled: "
      match.each do |m|
        msg += "\n  #{roll(m)}"
      end
      reply msg
    end
  end

  def roll(match)
    count = match[0].to_i
    die = match[1].to_i
    bonus = match[2].to_i

    result = "#{count}d#{die}"
    result += "+#{bonus}" if bonus > 0
    result += "#{bonus}" if bonus < 0
    result += ": "
    if count > DIE_CAP || die > DIE_CAP
      result += "Nope"
    else
      dice = count.times.collect do
        Die.new(die)
      end
      dice.sort!
      total = dice.reduce(0) { |sum, die| sum + die.result }
      total += bonus
      result += "#{total} (#{dice.join(", ")})"
    end
  end

end
