class GchatParser

  def initialize
    @file = File.open('data/training_data.txt','r')
  end

  def training_set
    @training_set ||= parse_sentences
  end

  private

  def parse_sentences
    text = @file.readlines
    text = text.join.downcase
    text.gsub!(/me\n\: /, '< ')
    text.gsub!(/\w+?\n\: /, '> ')
    text.gsub!(/\d+? minutes/, '')
    text.gsub!(/\&\#39\;/, '\'')
    text.gsub!(/\&quot\;/, '')
    text.gsub!(/[\.\,\;\:\?]/, '')
    chat_lines = text.scan(/(?<=\<).+?(?=\>)/m)
    chat_lines.map!{ |line| line.split(/\n/) }
    chat_lines.flatten!
    chat_lines.reject!{ |line| line == ""}
    chat_lines.map!{ |line| line.split(" ") }
  end
end
