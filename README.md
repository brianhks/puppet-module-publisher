# puppet-module-publisher
This project uses librarian-puppet to download modules and dependencies and then publishes them to Nexus

# How to Use
1. Clone this project to your local machine.
2. Update [Puppetfile](https://github.com/rodjek/librarian-puppet#the-puppetfile) with the modules you want to publish to Nexus.
3. Update NEXUS_* variables in common.sh to match your Nexus install.
4. Run retrieve_modules.sh - this uses [librarian puppet](https://github.com/rodjek/librarian-puppet) to grab your modules and their dependencies.
5. Run publish_modules.sh - this publishes all modules in the modules/ directory to Nexus.

Retrieving and publishing modules is done as two separate steps because, you may
have to modify the module before publishing.  Publishing a module to Nexus
requires that it contain a metadata.json file, if the file is missing the publish
will throw an error.  You will need to add the metadata file and then re run the
publish script.

Read more about how the [Nexus Puppet plugin works](https://github.com/brianhks/nexus-puppet-forge-plugin)


