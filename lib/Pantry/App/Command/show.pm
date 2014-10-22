use v5.14;
use warnings;

package Pantry::App::Command::show;
# ABSTRACT: Implements pantry show subcommand
our $VERSION = '0.005'; # VERSION

use Pantry::App -command;
use autodie;
use File::Slurp qw/read_file/;

use namespace::clean;

sub abstract {
  return 'Show items in a pantry (nodes, roles, etc.)';
}

sub command_type {
  return 'TARGET';
}

sub valid_types {
  return qw/node role/
}

sub _show_node {
  my ($self, $opt, $name) = @_;
  return $self->_show_obj($opt, 'node', $name);
}

sub _show_role {
  my ($self, $opt, $name) = @_;
  return $self->_show_obj($opt, 'role', $name);
}

sub _show_obj {
  my ($self, $opt, $type, $name) = @_;
  my $obj = $self->_check_name($type, $name);
  my $path = $obj->path;
  if ( -e $path ) {
    print scalar read_file($path);
  }
  return;
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::show - Implements pantry show subcommand

=head1 VERSION

version 0.005

=head1 SYNOPSIS

  $ pantry show node foo.example.com

=head1 DESCRIPTION

This class implements the C<pantry show> command, which is used to
display the JSON data for a node.

=for Pod::Coverage options validate

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

