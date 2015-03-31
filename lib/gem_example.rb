require 'gem_example/translator'

class GemExample
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi
  end
end
