# require 'net/imap'
# imap = Net::IMAP.new('imap.zhaw.ch', ssl: true)
# imap.authenticate('LOGIN', 'grak@zhaw.ch', 'haw!!lareunioN')

require 'exchanger'
Exchanger.configure do |config|
  config.endpoint = "https://mail.zhaw.ch/EWS/Exchanger.asmx"
  config.username = "grak@zhaw.ch"
  config.password = "haw!!lareunioN"
  config.debug = true # show Exchange request/response info
end

folder = Exchanger::Folder.find(:calendar, "grak@zhaw.ch")
mailboxes = Exchanger::Mailbox.search("grak")
