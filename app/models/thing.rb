class Thing < ApplicationRecord

	def self.find_things(rec)
		if rec[:fileid].nil? || rec[:fileid] == ""
                        Thing.where("r = ?", rec[:r])
		else
                        Thing.where("r like ?", "/"+rec[:fileid]+"."+"%")
		end
	end

	def self.find_path_starting_with(pathstart)
	        Thing.where("path LIKE ?",pathstart+"%")
	end	

end
