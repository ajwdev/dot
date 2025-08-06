#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p "ruby.withPackages (ps: with ps; [ rugged ])"

# Pulled from (4/8/25)
# https://gist.github.com/schacon/a5da5f2e2e076eb2434f8775ac5ff55e

require 'rugged'

# Your specified file is the first argument
file_path = ARGV[0]

repo = Rugged::Repository.discover(File.dirname(file_path))
walker = Rugged::Walker.new(repo)
walker.push(repo.head.target.oid)
walker.sorting(Rugged::SORT_TOPO)

file_changes = Hash.new(0)

walker.each do |commit|
  files = []
  include_files = false
  # get all the changed files
  commit.diff.deltas.each do |delta|
    files << delta.new_file[:path] if delta.new_file[:path] != file_path
    include_files = true if delta.new_file[:path] == file_path
  end
  # if we saw our file, add all the related files to our list
  if include_files
    files.each do |path|
      file_changes[path] += 1
    end
  end
end

# Sort by frequency and take the top 5
top_files = file_changes.sort_by { |_, v| -v }.first(5)

# Print out the top 5 files and their frequencies
top_files.each do |file, count|
  puts "#{count} - #{file}"
end

