require 'find'
require 'set'
require 'time'

require 'rubygems'
require 'rio'
require 'yaml'

require 'mdb'




def filenameescaper(i)
        o=i
        o = o.gsub(/&/,"\\\\&")
        o = o.gsub(/\ /,"\\ ")
        o = o.gsub(/\(/,"_")
        o = o.gsub(/\)/,"_")
        o
end



def a_file_in_dir(dir)
        file_name = "no_file"
        Find.find(dir) do |path|

                if !FileTest.directory?(path)
                        file_name = path.split("/")[-1] if  ( path.split("/")[-1])  =~ /\.tif$/
                end

        end

        file_name

end

namespace :utils do
	desc "haul data"
	task(:hauler => :environment) do




stop_set = Set.new(["/media","/media/floppy"])


while true do










	        Find.find("/media") do |path|

                if FileTest.directory?(path)

                        if !stop_set.include?(path)

				sleep 3 #**********************************************
				#sleep 30

                                puts "copying #{path} which has this file: #{a_file_in_dir(path)}" 
				

				newdir = "#{path.split("/")[-1]}_#{a_file_in_dir(path)}"
        			newdir = newdir.gsub(/\ /,"_")

				path2 = "/home/atpa/atpa/autocopy/#{newdir}"



				#`mkdir -p #{path2}`
				command = "cp -R #{filenameescaper(path)} #{path2}"
				command = "mv #{filenameescaper(path)} #{path2}"
                                `#{command}`





                                result = "blah"
	

				results = []
				ts = []

				done = false
				while !done do 


					puts "sometimes we get stuck because the directory remains so we will try to clean that up now..."
					result = `rm -rf #{path}`

                                        puts "attempting to eject..."
                                        result = `eject sr1`

					sleep 1
                                        puts "result = '#{result}'"

					results << result
					ts << Time.now


					if results.length > 5 && ts[-1]-ts[-2] < 2 && ts[-2]-ts[-3] < 2 && ts[-3]-ts[-4] < 2 && ts[-4]-ts[-5] < 2 && ts[-5]-ts[-6] < 2 && results[-1] == "" && results[-2] == "" && results[-3] == "" && results[-4] == "" && results[-5] == "" then


# perhaps if we add something that checks if the /media directory is clean


						done = true
						puts "detected done"
					end 

				
				end

				# the disc has been ejected successfully












temp = "/tmp/hashes_of_data_files"
t = rio(temp)

begin
puts "removing "+t.to_s
t.rmtree
rescue
end

puts "hashing..."
command = "find #{path2} -type f -name \"*.tif\" -o -name \"*.TIF\"    -exec openssl dgst {} \\\; > "+t.to_s
command = "find #{path2} -type f -exec openssl dgst {} \\\; > "+t.to_s
puts command
o=`#{command}`
puts "done hashing"



puts "creating things..."
        count = 0
        File.open(t.to_s).each { |line|
                count = count+1
                puts count if count % 1000 == 0

                e = line.split("=")
                path = e[0].split("(")[1].split(")")[-1].strip
                h = e[1].strip

                filename = nil
                begin
                        a = path.split("/")
                        filename = a.last
                rescue
                end

                imgpath = nil

                hasImgPath = path.split("/").map{|x|!(x =~ /^Img\d+/).nil?}.any?


                if hasImgPath then
                        begin
                                a = path.split("/")
                                # consume the portion up to but not including the Img...
                                while (a.first =~ /^Img\d+/).nil?
                                        a.shift
                                end
                                imgpath = a.first
                        rescue
                        end
                end
                r = (imgpath.to_s+"/"+filename.to_s)
                Thing.create(:path => path, :h => h, :r => r)

        }

puts "done creating things"














puts "finding mdb files..."

        count = 0


        #rio is too slow and memory intensive...
        rio(path2).all.files['*.mdb'].each{|m|

puts "found this mdb:"

                puts filenameescaper(m.to_s)


                command = "openssl dgst -md5 "+filenameescaper(m.to_s)
                z = `#{command}`
                mdbhash = z.split("=")[1].strip

                puts mdbhash



                mdb=Mdb.open(m.to_s)
                if mdb.tables.include?("ATPA_Auto") then 
                    recs=mdb[:ATPA_Auto] 
                elsif mdb.tables.include?("ATPAAuto") then 
                    recs=mdb[:ATPAAuto] 
                end

                aor = recs



100.times{ puts "The number of records in this mdb is #{aor.length}" }


                # iterate over each record
                aor.each{|rec|



                        ssn = nil
                        begin
                                ssn = rec[:SSN]

                                if ssn.nil?
                                        ssn = rec[:ssn]
                                end

                                if not ssn.nil?
                                        ssn = ssn.gsub(/[^0-9]/,"")
                                end
                        rescue
                        end

                        name = nil
                        begin
                                name = rec[:Name]
                                if name.nil?
                                        name = rec[:NAME]
                                end
                                if name.nil?
                                        name = rec[:name]
                                end

                                if not name.nil?
                                        name = name.downcase
                                        name = name.gsub(/[^a-z\s]/,"")
                                end
                        rescue
                        end



                        path = nil
                        begin
                                path = rec[:Document_Path]
                        rescue
                        end



                        filename = nil
                        begin
                                a = path.split("\\")
                                filename = a.last
                        rescue
                        end


                        hasImgPath = path.split("\\").map{|x|!(x =~ /^Img\d+/).nil?}.any?

                        imgpath = nil
                        if hasImgPath
                          begin
                                a = path.split("\\")
                                # consume the portion up to but not including the Img...
                                while (a.first =~ /^Img\d+/).nil?
                                        a.shift
                                end
                                imgpath = a.first
                          rescue
                          end
                        else
                          puts "um no imgpath for #{rec}"
                        end


                        hasImgPath = m.to_s.split("\\").map{|x|!(x =~ /^Img\d+/).nil?}.any?
                        if hasImgPath && (imgpath.nil? || imgpath == "")
                                begin
                                        a = m.to_s.split("/")
                                        # consume the portion up to but not including the Img...
                                        while (a.first =~ /^Img\d+/).nil?
                                                a.shift
                                        end
                                        imgpath = a.first
                                rescue
                                end
                        end

                        r = imgpath.to_s+"/"+filename.to_s

                        rec[:r] = r



                        rec[:m]=m.to_s
                        rec[:mdbhash]=mdbhash




                        newrec = Hash.new
                        rec.keys.each{|key|

                                newkey = key.to_s.gsub(/[^a-zA-Z0-9]/,"").downcase.to_sym
                                if newkey == :id
                                        newrec[:id2] = rec[key]
                                elsif newkey == :m
                                else
                                        newrec[newkey]=rec[key]
                                end
                        }

                        newrec[:name]=name
                        newrec[:ssn]=ssn

                        if newrec[:r]=="/"
                                if !newrec[:fileid].nil? && newrec[:fileid] != ""
                                        newrec[:r] = "/"+newrec[:fileid]+".tif"
                                else
                                        puts "*****************couldn't produce r:"
                                        p newrec
                                end
                        end




filtered_rec=Hash.new
[:documentstatus,
:filetype,
:boxdesc1,
:pagecount,
:documentpath,
:documentid,
:boxdesc2,
:employernumber,
:batchid,
:filedesc1,
:filestatus,
:filedesc2,
:employername,
:boxretentiondate,
:dsfile,
:account,
:documentdesc1,
:workorder,
:migrated,
:documentdesc2,
:boxstatus,
:pickupdate,
:dsbox,
:document,
:scandate,
:documenttype,
:fileretentiondate,
:documentretentiondate,
:boxlocation,
:filehash,
:cisfile,
:name,
:ssn,
:id2,
:ocrpath,
:docid,
:database,
:cisbox,
:documentretetiondate,
:fileid,
:toboxdesc,
:fromboxdesc,
:employercity,
:employerdate,
:version4notsupported,
:batchdate,
:batchnumber,
:batchcreatedatetime,
:order,
:pudate,
:mdbhash,
:r].each{|allowed_key|

	filtered_rec[allowed_key] = newrec[allowed_key] if !(newrec[allowed_key].nil?)

}

                        if count % 1000 == 0
                                p count
                                p filtered_rec
                        end
                        count = count + 1




                        Record.create(filtered_rec)



                }
        }
































                        end
                end
        end
        sleep 5
end










	end
end
