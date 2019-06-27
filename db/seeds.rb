# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

xyenon = User.create(username: 'XYenon', email: 'register@xyenon.bid', password: '12345678', password_confirmation: '12345678', admin: true)

users = []
(1..100).each do |n|
  users.append(User.create(username: 'User' + n.to_s, email: n.to_s + '@xyenon.bid', password: '12345678', password_confirmation: '12345678', gravatar: false))
end

tag1 = Tag.create(name: 'init')
tag2 = Tag.create(name: 'test')
tag3 = Tag.create(name: '1')
tag4 = Tag.create(name: 'English')
tags = [tag1, tag2, tag3, tag4]
article = Article.create(title: 'Hello World!', text: '<div>The first article</div>', user: xyenon, tags: tags)
Comment.create(body: '<div>The first comment</div>', user: xyenon, article: article)
Comment.create(body: '<div>The second comment</div>', user: xyenon, article: article)
Comment.create(body: '<div>The third comment</div>', user: users[0], article: article)

tag3 = Tag.create(name: '2')
tag4 = Tag.create(name: '中文')
tags = [tag1, tag2, tag3, tag4]
article = Article.create(title: '二', text: '<div>第二篇文章</div>', user: xyenon, tags: tags)
Comment.create(body: '<div>第一条评论</div>', user: xyenon, article: article)
Comment.create(body: '<div>第二条评论</div>', user: users[0], article: article)
Comment.create(body: '<div>第三条评论</div>', user: users[0], article: article)

tag3 = Tag.create(name: '3')
tag4 = Tag.create(name: 'emoji🆗️️')
tags = [tag1, tag2, tag3, tag4]
article = Article.create(title: '3️⃣', text: '<div>第3️⃣篇文章🤣</div>', user: xyenon, tags: tags)
Comment.create(body: '<div>第1️⃣条评论</div>', user: users[0], article: article)
Comment.create(body: '<div>第2️⃣条评论</div>', user: users[0], article: article)
Comment.create(body: '<div>第3️⃣条评论</div>', user: xyenon, article: article)

tag3 = Tag.create(name: '4')
tag4 = Tag.create(name: '富文本')
tags = [tag1, tag2, tag3, tag4]
article = Article.create(title: "富文本测试", text: '<h1>标题 Heading</h1><div><br><strong>加粗 Bold<br></strong><em>斜体 Italic<br></em><del>删除线 Strikethrough<br></del><a href="https://xyenon.bid">超链接</a><br><br></div><blockquote>引用<br>Quote</blockquote><div><br></div><pre>代码块
Code</pre><ul><li><br></li><li>无序列表a</li><li>无序列表b</li><li>无序列表c</li><li>无序列表d</li></ul><div><br></div><ol><li>有序列表1</li><li>有序列表2</li><li>有序列表3</li><li>有序列表4</li></ol>', user: xyenon, tags: tags)
Comment.create(body: '<h1>标题 Heading</h1><div><br><strong>加粗 Bold<br></strong><em>斜体 Italic<br></em><del>删除线 Strikethrough<br></del><a href="https://xyenon.bid">超链接</a><br><br></div><blockquote>引用<br>Quote</blockquote><div><br></div><pre>代码块
Code</pre><ul><li><br></li><li>无序列表a</li><li>无序列表b</li><li>无序列表c</li><li>无序列表d</li></ul><div><br></div><ol><li>有序列表1</li><li>有序列表2</li><li>有序列表3</li><li>有序列表4</li></ol>', user: xyenon, article: article)

ar = []
tag3 = Tag.create(name: 'useless')
tags = [tag1, tag3]
(1..100).each do |n|
  ar.append({title: n, text: "<div>The #{n}th useless article</div>", user: users[n - 1], tags: tags})
end
articles = Article.create(ar)

articles.each_index do |n|
  cr = []
  (1..100).each do |m|
    cr.append({body: "<div>Comment #{m} for #{n + 1}th article</div>", user: users[m - 1], article: articles[n]})
  end
  Comment.create(cr)
end
