class Translator
  def initialize(language)
    @language = language
  end
  
  def hi
    case @language
    when 'spanish'
      "hola mudo"
    when 'chinese'
      "ni hao shi jie"
    else
      "hello world"
    end
  end
end
