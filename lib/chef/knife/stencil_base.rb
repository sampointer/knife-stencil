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

    # This module is included everywhere, as per the conventions for
    # knife plugins. It includes various helper methods.

    module StencilBase

      # This is used seemingly at random inside knife. Force our values.
      def locate_config_value(key)
        key = key.to_sym
        config[key] || Chef::Config[:knife][key]
      end

      # Return true if the stencil plugin has been invoked
      def invoked_as_stencil?
        if $*[0].downcase == 'stencil'
          return true
        end

        return false
      end

      # Determine where to look for stencils
      def stencil_root
        stencil_root = '/'
        unless Chef::Config[:knife][:stencil_root] && Dir.exist?(Chef::Config[:knife][:stencil_root]) && stencil_root = Chef::Config[:knife][:stencil_root]
          [ '/etc/chef/stencils', "#{File.join(ENV['HOME'], '.chef/stencils')}" ].each do |directory|
            stencil_root = directory if Dir.exist?(directory)
          end
        end

        return stencil_root
      end

      # Do exactly that
      def normalize_path(path, root)
        unless path[0] == File::SEPARATOR	# FIXME: This will probably make this nasty on Windows
          return File.join(root, path).to_s
        else
          return path
        end
      end

      # Return a real Class built from the options given. Used to build EC2ServerCreate, for example
      def build_plugin_klass(plugin, command, action)
        begin
          klass = Object.const_get('Chef').const_get('Knife').const_get(plugin.to_s.capitalize + command.to_s.capitalize + action.to_s.capitalize)
          klass.respond_to?(:new)
        rescue NameError, NoMethodError => e
          puts("I can't find the correct gem for plugin #{config[:plugin]}, it does not declare class #{klas}, or that class does not repsond to 'new'. #{e}")
          puts("Try: gem install knife-#{config[:plugin]}")
        end

        return klass
      end

      # Output method for explanation sub-command. Very basic at present.
      def explain(string)
        if $*[2].to_s.downcase == "explain"
          puts "EXPLAIN: #{string}"
        end
      end

    end
  end
end
