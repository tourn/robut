# A simple plugin that replies with "pong" when messaged with ping
class Robut::Plugin::D20
  include Robut::Plugin

  DIE_PATTERN = /(?<count>[1-9]\d*)d(?<die>[1-9]\d*)((?<bonus>[+-][1-9]\d*))?/i

  def usage
    "NdX[+B] - rolls N dice of size X, optionally adds B as static bonus"
  end

  def handle(time, sender_nick, message)
    match = DIE_PATTERN.match(message)
    unless match.nil?
      if match['bonus'].nil?
        total = 0
      else
        total = match['bonus'].to_i
      end
      (1..match['count'].to_i).each do
        total += rand(match['die'].to_i) + 1
      end
      reply "@#{sender_nick} #{match.to_s}: #{total}"
    end
  end
end
