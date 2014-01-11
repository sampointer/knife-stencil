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

require 'chef/knife'

class Chef
  class Knife

    # This module provides shim classes for the knife-digital_ocean
    # plugin, as it breaks various naming conventions.
    module StencilDigitalOceanShim

    # Wrapper around non-conventional class name
    class DoServerCreate < Chef::Knife::DigitalOceanDropletCreate; end

    # Wrapper around non-conventional class name
    class DoServerDelete < Chef::Knife::DigitalOceanDropletDestroy; end

    end
  end
end
