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

class Chef
  class Knife

    # Knife-plugin boilerplate class for the 'delete' sub-command
    class StencilServerDelete < Knife

      include Knife::StencilBase

      deps do
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife stencil server delete -N HOSTNAME"

      option :chef_node_name,
        :short => "-N NAME",
        :long =>  "--node-name",
        :description => "The Chef node to delete",
        :proc => Proc.new { |key| Chef::Config[:knife][:chef_node_name] = key },
        :required => true

      option :purge,
        :short => "-P",
        :long => "--purge",
        :description => "Destroy corresponding node and client on the Chef Server, in addition to destroying the node itself.",
	:required => false

      def run
        stencil_node = Chef::Knife::StencilNode.new(locate_config_value(:chef_node_name), config)
        stencil_node.delete
      end
    end
  end
end
