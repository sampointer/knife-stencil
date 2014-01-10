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

class Chef
  class Knife

    # A node (server/host)
    class StencilNode

      include Knife::StencilBase

      attr_accessor :name, :config

      def initialize(name, config, options={})
	@name = name
        @config = config
        explain("Configuration #{config}")
      end

      # Create that node in the appropriate cloud
      def create
        klass = build_plugin_klass(config[:plugin], :server, :create)
        obj = klass.new
        obj.run
      end

      # Remove that node from the appropriate cloud
      def delete
        klass = build_plugin_klass(config[:plugin], :server, :delete)
        obj = klass.new
        obj.run
      end

    end
  end
end
