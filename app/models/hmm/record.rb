class Record < ActiveRecord::Base





	def self.find_r(r)

		whereclause = ""
		terms = []

		whereclause = whereclause + "r = ?"
		terms[terms.length] = r

		find(:all, :conditions => [whereclause, terms].flatten)
	end



	def self.find_gonzo(namestuff, ssnstuff, otherstuff)



if namestuff.nil?
	namestuff = ""
end

if ssnstuff.nil?
	ssnstuff = ""
end

if otherstuff.nil?
	otherstuff = ""
end




namestuff = namestuff.gsub(/[^a-zA-Z\s]/," ") #change all non-alpha non-space to space
namestuff = namestuff.downcase

ssnstuff = ssnstuff.gsub(/[^0-9\s]/," ") #change all non-digit non-space to space

whereclause = ""
terms = []

# factor this code someday

namestuff = namestuff.strip
namestuff_array = namestuff.split(/\s+/)
start=true
namestuff_array.each{|term|
	if whereclause.length > 0
		whereclause = whereclause + " AND "
	end
	if start # do obtain the speed we like, we assume the first thing in the name field is the last name and then search differently with that
		start=false 
		whereclause = whereclause + "name LIKE ?"
		terms[terms.length] = term+"%"
	else
		whereclause = whereclause + "name LIKE ?"
		terms[terms.length] = "%"+term+"%"
	end

}

ssnstuff = ssnstuff.strip
ssnstuff_array = ssnstuff.split(/\s+/)
ssnstuff_array.each{|term|
	if whereclause.length > 0
		whereclause = whereclause + " AND "
	end
	
	if term.length == 9
		whereclause = whereclause + "ssn = ?"
		terms[terms.length] = term
	else
		whereclause = whereclause + "ssn LIKE ?"
		terms[terms.length] = "%"+term+"%"
	end
}



		find(:all, :conditions => [whereclause, terms].flatten, :order => "name,ssn,r,mdbhash", :limit => 10000 )

	end	



























end
