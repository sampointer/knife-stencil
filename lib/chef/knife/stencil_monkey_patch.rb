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
require 'chef/knife/stencil_collection'

class Chef
  class Knife

    include Knife::StencilBase

    def merge_configs
      # Apply config file settings on top of mixlib-cli defaults
      combined_config = default_config.merge(config_file_settings)
      # Apply user-supplied options on top of the above combination
      combined_config = combined_config.merge(config)
      # replace the config hash from mixlib-cli with our own.
      # Need to use the mutate-in-place #replace method instead of assigning to
      # the instance variable because other code may have a reference to the
      # original config hash object.
      config.replace(combined_config)

      # If the stencil plugin has been invoked, parse some additional configuration
      # from the stencils.
      if invoked_as_stencil?
        new_config = config
        stencil_collection = Knife::StencilCollection.new

        stencil_collection.for_name(locate_config_value(:chef_node_name)).each do |stencil|
          new_config.merge!(stencil.options)
        end

        config.replace(new_config)
        combined_config = config
        config.each_pair do |k,v|
          Chef::Config[:knife][k.to_sym] = v
        end
      end

    end

    def config
      return Chef::Config[:knife]
    end

  end
end
