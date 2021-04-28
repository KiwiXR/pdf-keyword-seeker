# frozen_string_literal: true

# Requirements: gem 'pdf-reader'
# Usage: $ruby pdfseeker.rb [filename.pdf]
# Parameters:
# 	Keywords could be inserted into array #keywords
# 	File Name could be filled in #pdf_name, or emitted if to be provided in CL

require 'pdf-reader'

pdf_name = '' # filename here
keywords = %w[] # keywords here

pdf_name = ARGV[0].to_s if pdf_name.strip.empty?
ARGV.clear
reader = PDF::Reader.new(pdf_name)

# Match the keywords in file pdf_name
# input keywords from terminal is not supported due to encoding problems
match = []
reader.pages.each.with_index do |page, pid|
  lines = page.to_s.split(/[\r\n]/).reject { |s| s.strip.empty? }
  lines.each do |line|
    items = line.split
    match.append(line) if keywords.all? { |key| items.any? { |x| x =~ /.*#{key}.*/ } }
  end
  printf("Processing: page %d / %d done.\n", pid, reader.page_count)
end
match.each do |res|
  puts res
end
puts "number of result(s): #{match.size}"
