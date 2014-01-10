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
require 'chef/knife/stencil_monkey_patch'
require 'chef/knife/stencil_node'
require 'chef/knife/stencil_base'

class Chef
  class Knife
    
    # Knife-plugin boilerplate class for the 'explain' sub-command
    class StencilServerExplain < Knife

      include Knife::StencilBase

      banner "knife stencil server explain -N HOSTNAME"

      option :chef_node_name,
        :short => "-N NAME",
        :long =>  "--node-name",
        :description => "The Chef node name for your new node",
        :proc => Proc.new { |key| Chef::Config[:knife][:chef_node_name] = key },
        :required => true

      def run
        stencil_node = Chef::Knife::StencilNode.new(locate_config_value(:chef_node_name), config)
      end

    end
  end
end
