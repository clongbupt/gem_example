## gem_example

通过`rubygem`内置的工具可以轻松地把代码打包成`gem`。下面创建一个简单的`gem_example`案例.

### 开始
首先，新建一个目录，并创建一个`gem_example.ruby`和`gem_example.gemspec`的文件，具体的目录结构如下:
```
    -gem_example.gemspec
    `--lib
        `--gem_example.rb
```
*注意*
1. 代码一般放在`lib`目录中
2. 约定俗成，`lib`内有一个文件的文件名与`gem`名称一样

下面开始在`lib/gem_example.rb`中编写一点内容，具体如下:
```
class GemExample
  def self.hi
    puts "Hello world!"
  end
end
```
最后，介绍一下`gemspec`。其内部主要定义改`gem`的版本、依赖等。示例如下：
```
Gem::Specification.new do |s|
  s.name              = 'gem_example'
  s.version           = '0.0.1'
  s.date              = '2015-02-24'
  s.summary           = "An Simple Gem Example!"
  s.description       = "A simple example of introducing how to use gem"
  s.authors           = ["Changlong Wu"]
  s.email             = 'clongbupt@gmail.com'
  s.files             = ["lib/gem_example.rb", "lib/gem_example/translator.rb"]
  s.executables << 'gem_example' 
  s.homepage          = 
    'http://github.com/clongbupt/gem_example'
  s.license           = 'MIT'
end
```
`gem build`会读取`gemspec`，并以此标识和分发`gem`。具体命令如下：
```
gem build gem_example.gemspec
```
控制台输出的结果为:
```
$ gem build gem_example.gemspec
  Successfully built RubyGem
  Name: gem_example
  Version: 0.0.1
  File: gem_example-0.0.1.gem
```
在`irb`中可以对其进行测试。示例如下：
```
irb 
require ‘gem_example’ 
true 
GemExample.hi
```
输出结果为`hello world`。

### 发布

发布之前，首先要配置登录到`rubygem`的信息:
```
> curl -u yourusername_on_rubygem
https://rubygems.org/api/v1/api_key.yaml >
~/.gem/credentials; chmod 0600 ~/.gem/credentials

Enter host password for user 'yourusername_on_rubygem':
```
如果系统限制等,无法使用`curl`，`openssl`等,可以通过浏览器访问链接`https://rubygems.org/api/v1/api_key.yaml`,它会让你登录的,
成功则会下载一个认证信息文件`api_key.yaml`,完了直接把它放到`~/.gem/`文件夹下,重命名为**credentials**
一切设置妥当之后,就可以`push`你的`gem`了。具体示例如下：
```
gem push hola-0.0.0.gem
    Pushing gem to RubyGems.org...
    Successfully registered gem: hola (0.0.0)
```
上传成功后，你就可以通过下面命令`check`到自己的`gem`了:
```
gem list -r gem_example
```
然后尝试安装:
```
gem install gem_example
```

### 进阶

修改文件`lib/gem_example.rb`中的内容为：
```
class GemExample
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi
  end
end

class GemExample::Translator
  def initialize(language)
    @language = language
  end

  def hi
    case @language
    when "spanish"
      "hola mundo"
    else
      "hello world"
    end
  end
end
```
其中，可以将`Translator`进行拆分。一般推荐把目录结构调整为如示例所示样子:
```
    ├── gem_example.gemspec
    └── lib
        ├── gem_example
        │   └── translator.rb
        └── gem_example.rb
```
接着，修改`lib/gem_example.rb`文件:
```
    require 'lib/translator'
    class GemExample
        def self.hi(language = "english")
            translator = Translator.new(language)
            translator.hi
      end
    end
```
*注意*同时还需要修改`gemspec`文件, 把新添加的目录和文件索引进去, 否则打包时无法找到新文件。
```
Gem::Specification.new do |s|
  s.name              = 'gem_example'
  s.version           = '0.0.1'
  s.date              = '2015-02-24'
  s.summary           = "An Simple Gem Example!"
  s.description       = "A simple example of introducing how to use gem"
  s.authors           = ["Changlong Wu"]
  s.email             = 'clongbupt@gmail.com'
  s.files             = ["lib/gem_example.rb", "lib/gem_example/translator.rb"]
  s.executables << 'gem_example' 
  s.homepage          = 
    'http://github.com/clongbupt/gem_example'
  s.license           = 'MIT'
end
```

### 添加可执行文件

在与`lib/`目录同级的地方新建`bin/`目录。然后在`gemspec`里添加他们。具体操作如下：
```
mkdir bin
touch bin/gem_example
chmod a+x bin/gem_example
```
在文件中添加如下代码。
```
#!/usr/bin/env ruby

require 'gem_example'
puts GemExample.hi(ARGV[0])    
```
之后在`gemspec`文件里添加可执行的文件配置说明:
```
  s.name        = 'gem_example'
  s.version     = '0.0.1'
  s.executables << 'gem_example'  #可执行文件
```

### 测试

TEST YOUR GEM!
一般会用`TEST::Unit`。它是`ruby`内置的测试框架，有很多的教程在网上可以找到。
首先创建文件`Rakefile`和文件夹`test`，如下所示：
```
    .
    ├── Rakefile
    ├── bin
    │   └── gem_example
    ├── gem_example.gemspec
    ├── lib
    │   ├── gem_example
    │   │   └── translator.rb
    │   └── gem_example.rb
    └── test
        └── test_gem_example.rb
```
编辑test_gem_example.rb。
```
require 'test/unit'
require 'gem_example'

class GemExampleTest < Test::Unit::TestCase
  def test_english_hello
    assert_equal "hello world",
      GemExample.hi("english")
  end

  def test_any_hello
    assert_equal "hello world",
      GemExample.hi("ruby")
  end

  def test_spanish_hello
    assert_equal "hola mundo",
      GemExample.hi("spanish")
  end
end
```

在`Rakefile`里添加一些简单的测试用例。
```
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
```
之后执行命令`rake test`或者直接`rake`，执行结果如下：
```
    % rake test
    Loaded suite
    Started
    ....
    Finished in 0.000943 seconds.

    4 tests, 4 assertions, 0 failures, 0 errors, 0 skips

    Test run options: --seed 15331
```

## 文档

大部分的gem会使用默认内建RDoc来生成文档.有很多的教程可以学习.

```
class GemExample
  # Say hi to the world!
  #
  # Example:
  #   >> Hola.hi("spanish")
  #   => hola mundo
  #
  # Arguments:
  #   language: (String)

  def self.hi(language = "english")
    translator = Translator.new(language)
    puts translator.hi
  end
end
```

## 参考资料

> 1. http://guides.rubygems.org/gems-with-extensions/ 
> 2. http://qiita.com/xiangzhuyuan/items/7d3659bcebbaf52a1f12
