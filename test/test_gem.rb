require 'test/unit'
require 'gem_example'

class GemExampleTest < Test::Unit::TestCase
  def test_english_hello
    assert_equal "hello world", GemExample.hi("english")
  end
    
  def test_spanish_hello
    assert_equal "hola mudo", GemExample.hi("spanish")
  end

  def test_chinese_hello
    assert_equal "ni hao shi jie", GemExample.hi("chinese")
  end

  def test_any_hello
    assert_equal "hello world", GemExample.hi("ruby")
  end
end

