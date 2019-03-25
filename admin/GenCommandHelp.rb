### GenCommandHelp.rb -- Retrieve help for all cmake commands.

# Copyright (C) 2017-2019 Anders Lindgren

## Author: Anders Lindgren

## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

### Commentary:

## Retrieve help for all cmake commands.
##
## Usage:
##
##     ruby GenCommandHelp.rb PATH-TO-CMAKE

### Code:

def system_with_output(*args)
  cmd = args.join(" ")
  return `#{cmd}`.split("\n")
end

if ARGV.empty?
  puts "Usage: GenCommandHelp.rb PATH-TO-CMAKE

Generate help files for all CMake commands."
  exit 1
end

cmake = ARGV.shift

commands = system_with_output(cmake + " --help-command-list")

commands.each do |cmd|
  system("#{cmake} " + "--help-command " + cmd + " > " + cmd + ".rst")
end

# GenCommandHelp.rb ends here.
