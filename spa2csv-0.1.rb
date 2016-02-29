#!/usr/bin/ruby

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.


#This is a simple app to convert Thermo SPA file into plain text format (csv)
#To use this app just provide it with SPA file as an argument
#Like so: ruby spa2csv spectrum.spa
#It will create text file containing your data in text format 
#named like this: spectrum.spa.csv.
#Hope this app will be of some usage
#Written by ne0dim
#While using the code please keep the comments and the author's name

#Opening datafile in binary mode provided as 0 argument
if ARGV[0] != nil
    spectrum_spa_binary_string = IO.binread(ARGV[0])
else
    puts "No file provided"
    abort
end

#Searching for spectrum offset which is stored as 16bit
#unsigned number marked by x00x00x00x03x00
spectrum_offsets = spectrum_spa_binary_string.split("\x00\x00\x00\x03\x00")[1].unpack("S*")

#Saving spectrum offset
spectrum_offset = spectrum_offsets[0]

#Spectrum end offset is stored after x00x00
spectrum_end_offset = spectrum_offsets[2]

#Searching for spectrum range and unpacking it as float 32bit numbers.
#Couldn't find its offset anywhere in the file, so we search for it by pattern
#x00x00x00x03x00x00x00. Not sure that it will work for every spectra but with
#mine it works OK
spectrum_from_values = spectrum_spa_binary_string.split("\x00\x00\x00\x03\x00\x00\x00")[1].unpack("f*")

#Storing from and values for spectrum to get X axis coordinates
puts spectrum_from_value = spectrum_from_values[3]
puts spectrum_to_value = spectrum_from_values[4]

#Unpacking spectrum using the offset found earlier.
#The spectrum is just 32bit floats
spectrum = spectrum_spa_binary_string.byteslice(spectrum_offset, spectrum_end_offset)
spectrum_float = spectrum.unpack("f*")

#Making a new array for X axis values
spectrum_xaxis = Array.new(spectrum_float.length)

#Calculating X axis step. Maybe it's also somewhere in the file, just couldn't find it right away
spectrum_step = (spectrum_from_value.to_f - spectrum_to_value.to_f)/(spectrum_float.length-1)
puts spectrum_step = spectrum_step.abs

#Preparing the array for file output and later plotting
spectrum_full_string_array = Array.new(spectrum_float.length)
spectrum_full_string_array[0] = spectrum_xaxis[0].to_s + "," + spectrum_float[0].to_s

#Filling up the xaxis array
for i in 0..spectrum_float.length-1
    spectrum_xaxis[i] = spectrum_from_value.to_f - spectrum_step*i
end

#Filling up the array of strings for file output
for i in 0..spectrum_float.length-1
    spectrum_full_string_array[i] = spectrum_xaxis[i].to_s + "," + spectrum_float[i].to_s
end

#Writing a .csv file
File.open(ARGV[0].to_s + '.csv', "w+") do |f|
     f.puts("#Converted with spa2csv tool")
     f.puts(spectrum_full_string_array)
    #f.puts(spectrum_xaxis)
end
