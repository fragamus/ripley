class Rec < ActiveRecord::Base





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
namestuff_array.each{|term|
	if whereclause.length > 0
		whereclause = whereclause + " AND "
	end
	whereclause = whereclause + "name LIKE ?"
	terms[terms.length] = "%"+term+"%"
}

ssnstuff = ssnstuff.strip
ssnstuff_array = ssnstuff.split(/\s+/)
ssnstuff_array.each{|term|
	if whereclause.length > 0
		whereclause = whereclause + " AND "
	end
	whereclause = whereclause + "ssn LIKE ?"
	terms[terms.length] = "%"+term+"%"
}

otherstuff = otherstuff.strip
otherstuff_array = otherstuff.split(/\s+/)
otherstuff_array.each{|term|
	if whereclause.length > 0
		whereclause = whereclause + " AND "
	end
	whereclause = whereclause + "yaml LIKE ?"
	terms[terms.length] = "%"+term+"%"
}


		find(:all, :conditions => [whereclause, terms].flatten, :order => "name,ssn,r,mdbhash", :limit => 10000 )

	end	



























end
