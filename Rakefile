desc 'create new post args: type post, title, future (# of days)'
# rake new type=post future=0 title="New post title goes here" slug="slug-override-title"
task :new do
  require 'rubygems'

  type = ENV["type"] || "post"
  title = ENV["title"] || "New Title"
  future = ENV["future"] || 0
  slug = ENV["slug"].gsub(' ','-').downcase || title.gsub(' ','-').downcase

  if type == "bit"
    TARGET_DIR = "_bits"
  elsif future.to_i < 3
    TARGET_DIR = "_posts"
  else
    TARGET_DIR = "_drafts"
  end

  if future.to_i.zero?
    filename = "#{Time.new.strftime('%Y-%m-%d')}-#{slug}.md"
  end
  path = File.join(TARGET_DIR, filename)
  post = <<-HTML
---
layout: TYPE
title: "TITLE"
date: DATE
---
HTML
  post.gsub!('TITLE', title).gsub!('DATE', Time.new.to_s).gsub!('TYPE', type)
  File.open(path, 'w') do |file|
    file.puts post
  end
  puts "new #{type} generated in #{path}"
end

desc 'upload images to cloudfront'
task :cloudfront do
  puts 'uploading images in ~/Desktop/new_post/ to cf'
  post_dir = "/Users/rvanniekerk/Desktop/new_post/"
  month = Time.new.strftime("%m")
  year = Time.new.strftime("%Y")
  sh "s3cmd put --acl-public --guess-mime-type #{post_dir}* s3://iamnayr.com/#{year}/#{month}/"

  # create URLs for handy copying
  # detect large version of same image and link it to smaller version
  # or just provide img src to orphan if no larger version
  # works b/c Dir.glob returns files alpha by extension
  # yes I know THIS IS DIRTY, I'll refactor later...
  puts "Uploaded. Here are your CF URLs \n\n"
    Dir.chdir(post_dir)
  img_urls = ''
  images = Dir.glob("*.{png,gif,jpg}")
  images.each_with_index do |image, index|
    cur = image
    desc = cur.gsub('pstam_','').gsub('_',' ')[0...-4].capitalize
    if !images[index+1].nil?
      nxt = images[index+1]
      if cur.gsub(/_1[0-9]00/,'')[0...-4] == nxt.gsub(/_1[0-9]00/,'')[0...-4]
        if /_1[0-9]00/.match(image)
          large = cur
          small = nxt
        elsif /_1[0-9]00/.match(nxt)
          large = nxt
          small = cur
        end
        img_urls += <<-HTML
<div class="center"><a href="http://cdn.iamnayr.com/#{year}/#{month}/#{large}" title="#{desc}"><img src="http://cdn.iamnayr.com/#{year}/#{month}/#{small}" alt="#{desc}"/></a></div>\n
HTML
      elsif !(/_1[0-9]00/.match(image))
        img_urls += <<-HTML
<div class="center"><img src="http://cdn.iamnayr.com/#{year}/#{month}/#{cur}" alt="#{desc}"/></div>\n
HTML
      end
    else
      # if last
      img_urls += <<-HTML
<div class="center"><img src="http://cdn.iamnayr.com/uploads/#{year}/#{month}/#{cur}" alt="#{desc}"/></div>\n
HTML
    end
  end
  puts img_urls
  filename = (0...8).map{65.+(rand(25)).chr}.join + "_imgurls_tmp.txt"
  path = File.join("/tmp", filename)
  File.open(path, 'w') do |file|
    file.puts img_urls
  end
  system "cat #{path} | pbcopy"
end

