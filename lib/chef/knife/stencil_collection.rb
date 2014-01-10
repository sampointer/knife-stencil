#
# Copyright 2013, OpsUnit Ltd.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require 'chef/knife/stencil_base'
require 'chef/knife/stencil_file'

class Chef
  class Knife

    # A collection of all StencilFile objects
    class StencilCollection < Array

      include Knife::StencilBase

      def initialize(options={})
        Dir.glob(File.join(stencil_root, "**/*.json")).each do |file|
          self << Knife::StencilFile.new(normalize_path(file, stencil_root))
        end
      end

      # Return stencil for a given name
      def for_name(name)
        collection = Array.new
        collection.push(best_match(name))

        collection.each do |stencil_file|

	  stencil_file.inherits.each do |path|
	    collection << self.stencil_for_path(normalize_path(path, stencil_root))
	  end

        end

        collection.reverse.each {|t| explain("#{t.path} overrides #{t.inherits} and supplies options #{t.options}")}
        return collection.reverse
      end

      # Return stencil that best matches a given node name
      def best_match(name)
        weight_stencil_file_map = Hash.new

        self.each do |stencil_file|
          if stencil_file.matches
            regex = Regexp.new(stencil_file.matches)
            if name.scan(regex).size > 0
              weight = ( name.scan(regex)[0].size || 0 )
	      weight_stencil_file_map[weight] = stencil_file
            end
          end
        end

        unless weight_stencil_file_map.keys.size > 0
          raise ArgumentError, 'No stencil can be found to match that name'
        end

        match = weight_stencil_file_map.sort_by{|k,v| k}.reverse.first[1]	# The StencilFile with the most matched chars
        explain("decision tree: #{weight_stencil_file_map.sort_by{|k,v| k}.reverse}")

	explain("determined #{match.path} to be the best matched root stencil via #{match.matches}")
        return match
      end

      # For a given path, determine which stencil matches
      def stencil_for_path(path)
        matched_stencil = nil

        self.each do |stencil_file|
          if stencil_file.path == path 
            matched_stencil = stencil_file
          end
        end

	if matched_stencil
	  return matched_stencil
	else
	  raise ArgumentError, "#{path} not found in StencilCollection"
	end
      end

    end
  end
end
