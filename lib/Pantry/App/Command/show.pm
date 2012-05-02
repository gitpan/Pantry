use v5.14;
use warnings;

package Pantry::App::Command::show;
# ABSTRACT: Implements pantry show subcommand
our $VERSION = '0.002'; # VERSION

use Pantry::App -command;
use autodie;
use File::Slurp qw/read_file/;

use namespace::clean;

sub abstract {
  return 'show items in a pantry (nodes, roles, etc.)';
}

sub options {
  return;
}

sub validate {
  my ($self, $opts, $args) = @_;
  my ($type, $name) = @$args;

  # validate type
  if ( ! length $type ) {
    $self->usage_error( "This command requires a target type and name" );
  }
  elsif ( $type ne 'node' ) {
    $self->usage_error( "Invalid type '$type'" );
  }

  # validate name
  if ( ! length $name ) {
    $self->usage_error( "This command requires the name for the thing to display" );
  }

  return;
}

sub execute {
  my ($self, $opt, $args) = @_;

  my ($type, $name) = splice(@$args, 0, 2);

  if ($type eq 'node') {
    $self->_show_node($name);
  }

  return;
}

#--------------------------------------------------------------------------#
# Internal
#--------------------------------------------------------------------------#

sub _show_node {
  my ($self, $name) = @_;
  my $path = $self->pantry->node($name)->path;
  if ( -e $path ) {
    print scalar read_file($path);
  }
  else {
    $self->usage_error( "Node '$name' does not exist" );
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

version 0.002

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

