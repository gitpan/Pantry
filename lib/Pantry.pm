use v5.14;
use warnings;

package Pantry;
# ABSTRACT: Configuration management tool for chef-solo
our $VERSION = '0.004'; # VERSION

# This file is a namespace placeholder and gives a default place to find
# documentation for the 'pantry' program.

# Pod for this file is generated from the pod/ directory in the source
# repository using the 'AppendExternalData' dzil plugin

1;

# vim: ts=2 sts=2 sw=2 et:



__END__
=pod

=head1 NAME

Pantry - Configuration management tool for chef-solo

=head1 VERSION

version 0.004

=head1 SYNOPSIS

  $ mkdir my-project
  $ cd my-project
  $ pantry init
  $ pantry create node foo.example.com
  $ pantry list nodes
  $ pantry apply node foo.example.com --recipe nginx
  $ pantry apply node foo.example.com --default nginx.port=80
  $ pantry sync node foo.example.com

=head1 DESCRIPTION

C<pantry> is a utility to make it easier to manage a collection of
computers with the configuration management tool
chef-solo L<http://wiki.opscode.com/display/chef/Chef+Solo>

=head1 USAGE

Arguments to the C<pantry> command line tool follow a regular structure:

  $ pantry VERB [[NOUN] [ARGUMENTS...]]

See the following sections for details and examples by topic.

=head2 Pantry setup and introspection

=head3 init

  $ pantry init

This initializes a pantry in the current directory.  Currently, it just
creates some directories for use storing cookbooks, node data, etc.

=head3 list

  $ pantry list nodes

Prints to STDOUT a list of nodes managed within the pantry.

=head2 Managing nodes

In this section, when a node NAME is required, the name is
expected to be a valid DNS name or IP address.  The name
will be converted to lowercase for consistency.

Also, whenever a command takes a single 'node NAME' target,
you may give a single dash ('-') as the NAME and the command
will be run against a list of nodes read from STDIN.

You can combine this with the C<pantry list> command to do
batch operations.  For example, to sync all nodes:

  $ pantry list nodes | pantry sync node -

=head3 create

  $ pantry create node NAME

Creates a node configuration file for the given C<NAME>.

=head3 rename

  $ pantry rename node NAME DESTINATION

Renames a node to a new name.  The old node data file
is renamed.  The C<NAME> must exist.

=head3 delete 

  $ pantry delete node NAME

Deletes a node. The C<NAME> must exist. Unless the C<--force>
or C<-f> options are given, the user will be prompted to confirm
deletion.

=head3 show

  $ pantry show node NAME

Prints to STDOUT the JSON data for the given C<NAME>.

=head3 apply

  $ pantry apply node NAME --recipe nginx --default nginx.port=80

Applies recipes or attributes to the given C<NAME>.

To apply a recipe to the node's C<run_list>, specify C<--recipe RECIPE> or C<-r
RECIPE>.  May be specified multiple times to apply more than one recipe.

To apply an attribute to the node, specify C<--default KEY=VALUE> or C<-d
KEY=VALUE>.  If the C<KEY> has components separated by periods (C<.>), they will
be interpreted as subkeys of a multi-level hash.  For example:

  $ pantry apply node NAME -d nginx.port=80

will be added to the node's data structure like this:

  {
    ... # other node data
    nginx => {
      port => 80
    }
  }

If the C<VALUE> contains commas, the value will be split and serialized as
an array data structure.  For example:

  $ pantry apply node NAME -d nginx.port=80,8080

will be added to the node's data structure like this:

  {
    ... # other node data
    nginx => {
      port => [80, 8080]
    }
  }

Both C<KEY> and C<VALUE> support periods and commas (respectively) to be
escaped by a backslash.

=head3 strip

  $ pantry strip node NAME --recipe nginx --default nginx.port

Strips recipes or attributes from the given C<NAME>.

To strip a recipe to the node's C<run_list>, specify C<--recipe RECIPE> or C<-r
RECIPE>.  May be specified multiple times to strip more than one recipe.

To strip an attribute from the node, specify C<--default KEY> or C<-d KEY>.
The C<KEY> parameter is interpreted and may be escaped just like in C<apply>,
above.

=head3 sync

  $ pantry sync node NAME

Copies cookbooks and configuration data to the C<NAME> node and invokes
C<chef-solo> via C<ssh> to start a configuration run.  After configuration,
the latest run-report for the node is updated in the 'reports' directory
of the pantry.

=head3 edit

  $ pantry edit node NAME

Invokes the editor given by the environment variable C<EDITOR> on
the configuration file for the C<name> node.

The resulting file must be valid JSON in a form acceptable to Chef.  Generally,
you should use the C<apply> or C<strip> commands instead of editing the node
file directly.

=head2 Getting help

=head3 commands

  $ pantry commands

This gives a list of all pantry commands with a short description of each.

=head3 help

  $ pantry help COMMAND

This gives some detailed help for a command, including the options and
arguments that may be used.

=head1 AUTHENTICATION

C<pantry> relies on OpenSSH for secure communications with managed nodes,
but does not manage keys itself.  Instead, it expects the user to manage
keys using standard OpenSSH configuration and tools.

The user should specify SSH private keys to use in the ssh config file.  One
approach would be to use the C<IdentityFile> with a host-name wildcard:

  IdentityFile ~/.ssh/identities/id_dsa_%h

This would allow a directory of host-specific identities (which could all be
symlinks to a master key).  Another alternative might be to create a master key
for each environment:

  IdentityFile ~/.ssh/id_dsa_dev
  IdentityFile ~/.ssh/id_dsa_test
  IdentityFile ~/.ssh/id_dsa_prod

C<pantry> also assumes that the user will unlock keys using C<ssh-agent>.
For example, assuming that ssh-agent has not already been invoked by a
graphical shell session, it can be started with a subshell of a terminal:

  $ ssh-agent $SHELL

Then private keys can be unlocked in advance of running C<pantry> using
C<ssh-add>:

  $ ssh-add ~/.ssh/id_dsa_test
  $ pantry ...

See the documentation for C<ssh-add> for control over how long keys
stay unlocked.

=head1 ROADMAP

In the future, I hope to extend pantry to support some or all of the following:

=over 4

=item *

Chef role creation and application

=item *

environments

=item *

tagging nodes

=item *

searching nodes based on configuration

=item *

data bags

=item *

cookbook download from Opscode community repository

=item *

bootstrapping Chef over ssh

=back

If you are interested in contributing features or bug fixes, please let me
know!

=head1 SEE ALSO

Inspiration for this tool came from similar chef-solo management tools.
In addition to being implemented in different languages, each approaches
the problem in slightly different ways, neither of which fit my priorities.
Nevertheless, if you use chef-solo, you might consider them as well:

=over 4

=item *

littlechef L<http://github.com/tobami/littlechef> (Python)

=item *

pocketknife L<http://github.com/igal/pocketknife> (Ruby)

=back

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/dagolden/pantry/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/dagolden/pantry>

  git clone https://github.com/dagolden/pantry.git

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

