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
	desc "haul mdb"
	task(:m => :environment) do

path2 = "/data/target"

puts "finding mdb files..."

        count = 0

        seen_the_both_schmegegge = 0 
        seen_the_81744_schmegegge = 0 
        seen_the_81730_schmegegge = 0 
        seen_the_10004_schmegegge = 0 
        seen_the_yet_schmegegge = 0 
        seen_the_test_schmegegge = 0 

        #rio is too slow and memory intensive...
        rio(path2).all.files['*.mdb'].each{|m|

puts "found this mdb:"

                puts filenameescaper(m.to_s)


		if seen_the_both_schmegegge >= 2 and seen_the_81744_schmegegge >= 2 and seen_the_81730_schmegegge >= 2 and seen_the_10004_schmegegge >= 2 and seen_the_yet_schmegegge >= 2 and seen_the_test_schmegegge >= 1 then


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




                end

                if m.to_s.include?('both') then
                    seen_the_both_schmegegge = seen_the_both_schmegegge + 1 
                end
                if m.to_s.include?('81744') and  m.to_s.include?('project13cd2') and  m.to_s.include?('correction')then
                    seen_the_81744_schmegegge = seen_the_81744_schmegegge + 1 
                end
                if m.to_s.include?('81730') and  m.to_s.include?('apparent') and  m.to_s.include?('duplicate')then
                    seen_the_81730_schmegegge = seen_the_81730_schmegegge + 1 
                end
                if m.to_s.include?('oe') and  m.to_s.include?('pension-10004-project9cd1') and  m.to_s.include?('refile')then
                    seen_the_10004_schmegegge = seen_the_10004_schmegegge + 1 
                end
                if m.to_s.include?('yet') and  m.to_s.include?('another') and  m.to_s.include?('duplicate')then
                    seen_the_yet_schmegegge = seen_the_yet_schmegegge + 1 
                end

                if m.to_s.include?('original') and  m.to_s.include?('test') and  m.to_s.include?('data')then
                    seen_the_test_schmegegge = seen_the_test_schmegegge + 1 
                end

        }






                        end
                end



