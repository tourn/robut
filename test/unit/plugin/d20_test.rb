require 'test_helper'
require 'robut/plugin/d20'

class Robut::Plugin::D20Test < Test::Unit::TestCase

  def setup
    @connection = Robut::ConnectionMock.new
    @presence = Robut::PresenceMock.new(@connection)
    @plugin = Robut::Plugin::D20.new(@presence)
  end

  def test_1d20
    @plugin.handle(Time.now, "John", "Dex Check: 1d20!")
    assert_match /1d20: \d+/, @plugin.reply_to.replies.first
  end

  def test_1d20_4
    @plugin.handle(Time.now, "John", "Int Check: 1d20+4!")
    assert_match /1d20\+4: \d+/, @plugin.reply_to.replies.first
  end

  def test_20d20_44
    @plugin.handle(Time.now, "John", "Str Check: 20d20+44!")
    assert_match /20d20\+44: \d+/, @plugin.reply_to.replies.first
  end
  

end
