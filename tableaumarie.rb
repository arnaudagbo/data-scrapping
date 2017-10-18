require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "google_drive"

# Authenticate a session with your Service Account
# session = GoogleDrive::Session.from_service_account_key("config.json")

# Get the spreadsheet by its title
# spreadsheet = session.spreadsheet_by_title("tableaumairies")
# Get the first worksheet
# worksheet = spreadsheet.worksheets.first

# Get the first worksheet of the spreadsheet 
# spreadsheet = session.spreadsheet_by_title("tableaumairies").worksheets[0]

# Print out the first 2 columns of each row
# worksheet.rows.each { |row| puts row.first(2).join(" | ") }


def get_the_email_of_a_townhal_from_its_webpage(url)
	page = Nokogiri::HTML(open("#{url}"))
	email = page.xpath('//table/tr[3]/td/table/tr[1]/td[1]/table[4]/tr[2]/td/table/tr[4]/td[2]/p/font')
	email.text

end

def get_all_the_urls_of_herault_townhalls(url)
    session = GoogleDrive::Session.from_service_account_key("config.json")
    ws = session.spreadsheet_by_title("tableaumairies").worksheets[0]
	 towns_mail_list = Hash.new()
	 i = 3

	page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/herault.html"))
	page.xpath('//a[@class="lientxt"]').each do |town|
		town_name = town.text.downcase
		town_name = town_name.split(' ').join('-')
    proper_town_name = town_name.capitalize
		url = "http://annuaire-des-mairies.com/34/#{town_name}.html"
		towns_mail_list[proper_town_name] = get_the_email_of_a_townhal_from_its_webpage(url)
	end

	 towns_mail_list.each do |key, value|
			puts "#{key}: #{value} "
	   	 i += 3
		 ws[i, 1] = "#{key}"
		 ws[i, 2] = "#{value}"
		 ws.save	
	 end
	
		 obj = JSON.parse(json)
		 json = File.read('input.json')
		 pp obj
end



get_all_the_urls_of_herault_townhalls("http://www.annuaire-des-mairies.com/herault.html")