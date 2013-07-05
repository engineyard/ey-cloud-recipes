Jenkins on Engine Yard Cloud
============================

Caveats
-------

Because of the following considerations, we recommend running Jenkins on its own environment (with no other non-Jetty applications) with the application database set to "None".

* Our Jetty install renders haproxy and nginx unusable for any purpose other than serving Jetty applications
* Jenkins does not support high-availability via multiple application servers, accordingly it is only installed on solo instances or the app master. 
* Jenkins' default configuration does not use any RDBMS

Installation
------------

Create an application using this repo https://github.com/engineyard/ey-jenkins-app.git. This application is really just a placeholder that doesn't do anything, but you still need to have one on our cloud platform. Do *not* specify a domain. Because passenger doesn't spin up until there is work to be done, select passenger (it will never have work to do).

Then you will need to fork our custom recipes repo found here https://github.com/engineyard/ey-cloud-recipes.git, and enable the jenkins recipe by uncommenting the `include_recipe "jenkins"` line in cookbooks/main/recipes/default.rb.

Upload and apply the custom cookbooks via `ey recipes upload -e $NAMEOFYOURENVIRONMENT` and `ey recipes apply -e $NAMEOFYOURENVIRONMENT`

Log in to your new Jenkins instance by adding /jenkins to the instance id (should look something like this http://ec2-23-22-232-133.compute-1.amazonaws.com/jenkins)

Enjoy!

Build Slaves
------------

This recipe includes a Swarm configuration to automatically add slaves by adding utility instances. To use this recipe enable the swarm plugin in your Jenkins installation via the Manage Plugins page.

To add build slaves, simply click the Add button in your Jenkins environment, and add a utility instance. 

To remove the slaves, run "sudo monit stop swarm" either via ssh, or ey ssh and specify the utility instances. You can also utilize the server labels to bring down entire groups of build slaves. For example:

`ey ssh "sudo monit stop swarm" --environment  jenkins --utilities test_build_slaves`

After stopping swarm, feel free to terminate the utility instance. If you terminate the instance before stopping swarm, you will have to manually remove the build node in Jenkins after termination.

