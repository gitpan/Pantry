use v5.14;
use warnings;

package Pantry::App::Command::list;
# ABSTRACT: Implements pantry list subcommand
our $VERSION = '0.009'; # VERSION

use Pantry::App -command;
use autodie;

use namespace::clean;

sub abstract {
  return 'List pantry objects of a particular type';
}

sub command_type {
  return 'TYPE';
}

sub options {
  my ($self) = @_;
  return ($self->selector_options);
}

sub valid_types {
  return qw/node nodes role roles environment environments/
}

sub _list_nodes {
  my ($self, $opt) = @_;
  say $_ for $self->pantry->all_nodes($opt);
}

*_list_node = *_list_nodes; # alias

sub _list_roles {
  my ($self, $opt) = @_;
  say $_ for $self->pantry->all_roles;
}

*_list_role = *_list_roles; # alias

sub _list_environments {
  my ($self, $opt) = @_;
  say $_ for $self->pantry->all_environments;
}

*_list_environment = *_list_environments; # alias

1;



# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::list - Implements pantry list subcommand

=head1 VERSION

version 0.009

=head1 SYNOPSIS

  $ pantry list nodes

=head1 DESCRIPTION

This class implements the C<pantry list> command, which is used to generate a list
of items in a pantry directory.

Supported types are:

=over 4

=item *

C<node>, C<nodes> -- list nodes

=back

=for Pod::Coverage options validate

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

