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
require 'json'

class Chef
  class Knife

    # Objects of this class represent the contents of your various stencil files
    class StencilFile

      include JSON
      include Knife::StencilBase

      attr_accessor :path, :options, :inherits, :matches

      def initialize(path, options={})
        deserialized = JSON.parse(IO.read(path), :symbolize_names => true)

        @path = normalize_path(path, stencil_root)
        @options = deserialized[:options] || []
        @inherits = deserialized[:inherits] || []
        @matches = deserialized[:matches] || nil

      end

    end
  end
end
