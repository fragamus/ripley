class Thing < ActiveRecord::Base


	def self.find_things(rec)

		results = []
		if rec.fileid.nil? || rec.fileid == ""
			whereclause = ""
			terms = []

			whereclause = whereclause + "r = ?"
			terms[terms.length] = rec.r

puts "\n\nOLD QUERY"
p [whereclause, terms].flatten

			results = find(:all, :conditions => [whereclause, terms].flatten, :limit => 	10000 )
		else
			whereclause = ""
			terms = []

			whereclause = whereclause + "r like ?"
			terms[terms.length] = "/"+rec.fileid+"."+"%"

puts "\n\nNEW QUERY and the fileid is: \"#{rec.fileid}\" and the length of fileid is: #{rec.fileid.length}"
p [whereclause, terms].flatten


			results = find(:all, :conditions => [whereclause, terms].flatten, :limit => 	10000 )


		

		end





		results




	end


	def self.find_path_starting_with(pathstart)

		whereclause ="path LIKE ?"
		terms = []
		terms[0] = pathstart+"%"

		find(:all, :conditions => [whereclause, terms].flatten)


	end	













end
