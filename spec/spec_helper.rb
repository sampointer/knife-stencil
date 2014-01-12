$:.unshift File.expand_path('../../lib', __FILE__)
require 'chef'
require 'chef/knife/stencil_server_create'
require 'chef/knife/stencil_server_explain'
require 'chef/knife/stencil_server_delete'

# Clear config between each example
# to avoid dependencies between examples
RSpec.configure do |c|
  c.before(:each) do
    Chef::Config.reset
    Chef::Config[:knife] ={}
  end
end
