class GchatImporter

  def initialize(username, password)
    @config = {
      :host     => 'imap.gmail.com',
      :username => username,
      :password => password,
      :port     => 993,
      :ssl      => true
    }
    @raw_chat_emails = []
    @current_heading = 'initialize'
    @flag = 0
    @messages = []
    @date = Date.today
  end

  def train_x_days(days)
    load_date = (@date - days).strftime("%d-%b-%Y")
    puts "Fetching chats.... this may take a while"
    fetch_chats(load_date)
    puts "Parsing..."
    parse_raw_chat_emails
    puts "Exporting..."
    export_training_data
    puts "Done!"
  end

  private

  def fetch_chats(load_date)
    imap = Net::IMAP.new( @config[:host], @config[:port], @config[:ssl] )
    imap.login( @config[:username], @config[:password] )
    imap.select('[Gmail]/Chats')
    imap.search(["SINCE", load_date]).each do |id|
      subject = imap.fetch(id, '(BODY[HEADER.FIELDS (SUBJECT)])')[0].attr["BODY[HEADER.FIELDS (SUBJECT)]"].chomp
      print "Fetched: #{subject}"
      msg = imap.fetch(id, "BODY[TEXT]")[0].attr["BODY[TEXT]"]
      @raw_chat_emails << msg
    end
    imap.logout
  end
 
  def parse_raw_chat_emails
    @raw_chat_emails.each do |body|
      body.split("\r\n").each do |line|
        @flag = 0 unless line.scan(/\-\-\-\-\-\-\=.*\-\-/).empty?
        @messages << line if @flag == 1
        @flag = 1 if line == @current_heading
        @current_heading = line unless line.scan(/\-\-\-\-\-\-\=.*/).empty?
      end
    end
    @messages.map!{ |line| line.scan(/(?<=\>).*?(?=\<)/).delete_if(&:empty?)}
    @messages.each{ |line| line.map!{ |chat| chat if chat.scan(/\&nbsp\;/).empty? }}
  end

  def export_training_data(filename = 'training_data.txt')
    file = File.new(filename, "w+")
    pry
    @messages.each do |line|
      file.puts(line) unless line.empty?
    end
  end
end
