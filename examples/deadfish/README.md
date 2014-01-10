# Requirements
In order to use the examples in this directory you will need to install the following gems:

* knife-ec2
* knife-hp

You will also need the [`hello_world`][2] cookbook.

If you use [Berkshelf][1] you can install the cookbook requirements from within this directory with:

```bash
berks install
berks upload
```

You will need accounts on at least one of [AWS][3] or [HP Cloud][4] , preferably both.

[1]: http://berkshelf.com/
[2]: http://community.opscode.com/cookbooks/hello_world
[3]: http://aws.amazon.com
[4]: http://www.hpcloud.com/
