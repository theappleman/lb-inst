#!/usr/bin/env ruby
# Generate modified/translated G00 files from lbimages
# Needs 3 variables: base, vaconv and final.
# base is the root directory of the svn checkout (no trailing slash)
# vaconv is the full path to the vaconv binary
# final is the directory that you want the G00s to end up in (no trailing slash)
# if you are running windows, ensure any \'s are slash-escaped

# Begin configuration

base = ""
vaconv = ""
final = ""

# End configuration

exit if base == "" or final == "" or vaconv !~ /vaconv(\.exe)?$/
require 'fileutils'
temp = final + File::SEPARATOR + "temp"
Dir.mkdir(final) unless File.exists?(final) and File.directory?(final)
Dir.mkdir(temp) unless File.exists?(temp) and File.directory?(temp)
vaconvopts = "--g00=2"

dir = Dir.entries(base) - %w[. .. .svn .git .svn-index Templates Trial\ Edition]
dir.each { |e|
  full = base + File::SEPARATOR + e
  if File.directory?(full)
    sub = Dir.entries(full) - %w[. .. .svn .git .svn-index]
    sub.each { |l|
      if l =~ /\.png$/
	bm = full + File::SEPARATOR + l
	FileUtils.cp(bm, temp)
	bn = full + File::SEPARATOR + "xml" + File::SEPARATOR + l[/^(.*?)\.png/, 1] + ".xml"
	FileUtils.cp(bn, temp) if File.exists?(bn) and File.file?(bn) and File.readable?(bn)

	img = temp + File::SEPARATOR + l
	system vaconv, vaconvopts, "-d", final, img
      end
    }
  end
}
