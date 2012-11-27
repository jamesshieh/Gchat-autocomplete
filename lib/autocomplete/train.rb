file = File.open('../../data/training_data.txt','r')

text = file.readlines
text = text.join
text.gsub!(/me\n\: /, '< ')
text.gsub!(/\w*?\n\: /, '> ')
text.gsub!(/\d*? minutes/, '')
text.gsub!(/\&\#39\;/, '\'')
text.gsub!(/\&quot\;/, '"')
text.gsub!(/\n/, ' ')
chat_lines = text.scan(/(?<=\<).*?(?=\>)/m)
chat_lines.map!{ |line| line.split(" ")}
chat_lines.flatten!
chat_lines
