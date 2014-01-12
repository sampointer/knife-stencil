# Introduction

![OpsUnit Logo][99]

`knife-stencil` is a plugin for the command-line client of [Chef][6]. It enables teams to launch hosts in multiple clouds simply by following their own naming convention. It is brought to you by the folks at [OpsUnit][1].

## Description

When provisioning infrastructures with Chef, traditionally one has invoked a long command containing multiple switches. In larger teams, or teams with tiers of engineers this unfortunately leads to errors, as nodes are launched on the incorrect instance size or in incorrect security groups, and also means that there are some aspects of your infrastructure that you cannot recreate from source control.

Whilst tools such as [spiceweasel][2] and [ironfan][3] variously provide ways to serialize and orchestrate Chef infrastructures above the level of individual nodes, our current and prior experience with client implementations calls for a way of solving these problems with more flexibility than the former, and in a simpler and less opinionated manner than the latter.

`knife-stencil` expresses knife configuration options using a system of templates (stencils) that can inherit and override each other. Stencils are selected based on user-defined regexes that describe various potential node names, as befits your existing site naming convention.

The upshot of all of this is that the plugin enables:

* Launching hosts with the correct configuration options simply by following your local naming convention
* The capture in source control of node meta-data such as availability zone, volume persistence and cloud provider (more on this below).
* Easy operational integration with your existing site, conventions and infrastructure

## Low Friction Operation across multiple cloud providers

The plugin also works with most knife-cloud plugins automatically. With the correct stencil configuration it is simple to launch hosts in multiple clouds as selected for by their name. Adding new clouds is simply a matter of configuring the appropriate credentials and installing the corresponding knife plugin gem.

## What does this enable me to do?

Some examples of what can be achieved with `knife-stencil` are:

* **Launch hosts in different clouds depending on their environment:** launch development nodes on a local Openstack farm, DR servers in HP's cloud and production servers in Amazon EC2.
* **Ensure hosts land in the correct availability zone depending on some aspect of their role:** ensure all slave database servers are in a different AZ to the masters
* **Dynamically determine host instance type based on client:** client bigcorp has a premium contract, launch their database servers as an m2.4xlarge, otherwise launch as m1.xlarge
* **Split teams into "tooling" and "operational" streams:** avoid resorting to runbooks to capture knowledge; reproduce it programatically and versioned over time
* **Enforce legal juristiction restrictions:** all hosts containing "backup" for client "bigcorp" should be in the EU region

# How does it work?

Stencils take the general form:

    {
      "matches": "^[00-99]+\.production\.bigclient\.mycompany\.com$",
      "inherits": [
        "environments/production.json",
        "clients/bigclient.json"
      ],
      "options": {
        ":availability_zone": "us-west-1a"
      }

Invoking the plugin to launch a new node: `knife stencil server create -N 1380211968.production.bigclient.mycompany.com` will cause all stencil files under ~/.chef/stencils (configurable via `:stencil_root` in your knife.rb) to be evaluated.

Those that express a `matches` regular expression will be compared to the passed node name and ranked in order of strength of match. Once a "root" stencil has been selected any stencils specified through `inherits` will also be evaluated. This continues sequentially and iteratively until a final configuration is arrived upon, at which point the correct cloud server creation class will be instantiated and run.

Where options are expressed through inherited stencils exist for which there is already a configuration value, that value will be overwritten. The inhertence tree of a stencil is evaluated in **reverse** order. That is to say, the further away the inherited stencil from the matching "root" stencil the more generic it is intended to be.

Not all stencils need express `matches` - nor do they need to inherit anything or express an option. You may choose to create stencils whos job it is to provide a convenient point to aggregate many other stencils, for example.

If all this sounds complicated you may find the [examples][4] directory helps to clear things up. You can also invoke `knife stencil server explain live-pretendtown-app00` to have the plugin show you a non-destructive "query plan" of how it arrived at the configuration it would launch the node with. Try this with `:stencil_root` pointing at the 'deadfish' subdirectory of the examples directory.

You are free to organise your stencils, their names and the directory structure they are stored under as you wish. The [examples][4] directory provides just that.

## Launching across multiple clouds

If the final `:options` hash of a server that is being launched via knife-stencil contains the key `:plugin`, `knife-stencil` will attempt to load and instantiate classes from a similarly-named knife plugin. For example a value of `ec2` will have `knife-stencil` look for the `knife-ec2` plugin and the class `Chef::Knife::Ec2ServerCreate` with which to launch the node. Likewise `hp` with `knife-hp` and `Chef::Knife::HpServerCreate` and so-on for all plugins that follow this standard convention.

Given that the cloud plugin to use is expressed via the options hash, which is overridden as inherited stencils are parsed, it is nearly as trivial to provision in other clouds as it is to specify security groups or EBS retention policies or instance size.

## Specifying Configuration Options
Options are specified using the form they take in the cloud plugin's `options` hash. The easiest way to locate the option you are looking for is:

1. `knife hp server create --help` (note switch)
2. Execute `gem environment` to find the root of the GEM_PATH into which your gems are being installed
3. Locate the cloud gem and move into lib/chef/knife
4. Grep or otherwise locate the option stanza (there may be more than one) for the option you are concerned with
5. Take the symbol from the `option' and use that in the configuration:

For example, the following options stanza:

     option :rackspace_servicelevel_wait,
       :long => "--rackspace-servicelevel-wait",
       :description => "Wait until the Rackspace service level automation setup is complete before bootstrapping chef",
       :boolean => true,
       :default => false

Yields the following option:

    "options": {
      "rackspace_servicelevel_wait": true,
    }

# Installing and getting started

1. Install the gem

    `gem install knife-stencil`

2. Configure knife.rb to point `:stencil_root` to your preferred location, or create ~/.chef/stencils

    `mkdir -p ~/.chef/stencils`

    OR

    add `knife[:stencil_root] = "/alternative/location"` to `~/.chef/knife.rb`

3. Use the [examples][4] to start building your stencils and `knife stencil server explain HOSTNAME` to debug and explore. Try copying them into `~/.chef/stencils`.

4. Manage ~/.chef/stencils using your source control workflow

## The Deletion Caveat
At the time of writing only the knife-ec2 plugin from version 0.6.6 supports deletion via `:chef_node_name`. Most other plugins require an instance-id or similar parameter to be passed to delete a server. This is in counterpoint to how the stencil plugin would like to work. If the other plugins supported [this kind of thing][5] deletion would be a unified interface, like the creation of servers.

## Known Problems

* The plugin will not work with chef/knife 11.8.0 or above, due to changes in the internal options parsing code at that point.

## Development

[![Build Status](https://travis-ci.org/opsunit/knife-stencil.png?branch=master)](https://travis-ci.org/opsunit/knife-stencil)

The gem and its dependencies are tested against the following ruby versions:

* 1.9.3
* 2.0.0
* 2.1.0

[1]: http://www.opsunit.com
[2]: https://github.com/mattray/spiceweasel/
[3]: https://github.com/infochimps-labs/ironfan
[4]: https://github.com/opsunit/knife-stencil/tree/master/examples
[5]: https://github.com/opscode/knife-ec2/commit/169350ab0dcf11e7e5c224a1c2333707f0364c54
[6]: http://www.getchef.com/
[99]: http://opsunit.com/assets/images/opsunit-logo-large.png
