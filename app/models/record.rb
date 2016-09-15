class Record < ApplicationRecord

        def details
                self.to_json
        end

        def things 
                Thing.find_things(self)
        end

        def self.find_r(r)
                Record.where("r = ?", r)
        end

	def self.find_gonzo(namestuff, ssnstuff, otherstuff)

                namestuff = "" if namestuff.nil?
                ssnstuff = "" if ssnstuff.nil?
                otherstuff = "" if otherstuff.nil?

                namestuff = namestuff.gsub(/[^a-zA-Z\s]/," ").downcase
                ssnstuff = ssnstuff.gsub(/[^0-9\s]/," ")

                whereclause = ""
                terms = []

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
		
                Record.where(whereclause, *terms).order("name,ssn,r,mdbhash").limit(10000)

	end	









end
