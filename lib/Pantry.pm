use v5.14;
use warnings;

package Pantry;
# ABSTRACT: Configuration management tool for chef-solo
our $VERSION = '0.001'; # VERSION

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

version 0.001

=head1 SYNOPSIS

N.B. This program doesn't do much yet, but I'll expand this synopses
incrementally as features are added

  $ mkdir my-project
  $ cd my-project
  $ pantry init
  $ pantry create node foo.example.com
  $ pantry edit node foo.example.com
  $ pantry sync node foo.example.com

=head1 DESCRIPTION

C<pantry> is a utility to make it easier to manage a collection of
computers with the configuration management tool
L<chef-solo|http://wiki.opscode.com/display/chef/Chef+Solo>

=head1 USAGE

Arguments to the C<pantry> command line tool follow a regular structure:

  $ pantry VERB [[NOUN] [ARGUMENTS...]]

See the following sections for details and examples by topic.

=head2 Pantry setup

  $ pantry init

This initializes a pantry in the current directory.  Currently, it just
creates some directories for use storing cookbooks, node data, etc.

=head2 Managing nodes

  $ pantry create node NAME

Creates a node configuration file for the given C<NAME>.  The C<NAME>
must be a valid DNS name or IP address.

  $ pantry edit node NAME

Invokes the editor given by the environment variable C<EDITOR> on
the configuration file for the C<name> node.

  $ pantry sync node NAME

Copies cookbooks and configuration data to the C<NAME> node and invokes
C<chef-solo> via C<ssh> to start a configuration run.

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

=head1 SEE ALSO

Inspiration for this tool came from similar chef-solo management tools.
In addition to being implemented in different languages, each approaches
the problem in slightly different ways, neither of which fit my priorities.
Nevertheless, if you use chef-solo, you might consider them as well:

=over 4

=item *

L<littlechef|https://github.com/tobami/littlechef> (Python)

=item *

L<pocketknife|https://github.com/igal/pocketknife> (Ruby)

=back

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<http://github.com/dagolden/Pantry/issues>.
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

