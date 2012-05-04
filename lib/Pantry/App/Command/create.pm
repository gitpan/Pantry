use v5.14;
use warnings;

package Pantry::App::Command::create;
# ABSTRACT: Implements pantry create subcommand
our $VERSION = '0.004'; # VERSION

use Pantry::App -command;
use autodie;

use namespace::clean;

sub abstract {
  return 'Create items in a pantry (nodes, roles, etc.)';
}

sub command_type {
  return 'CREATE';
}

sub valid_types {
  return qw/node/
}

sub _create_node {
  my ($self, $opt, $name) = @_;

  my $node = $self->pantry->node( $name );
  if ( -e $node->path ) {
    $self->usage_error( "Node '$name' already exists" );
  }
  else {
    $node->save;
  }

  return;
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::create - Implements pantry create subcommand

=head1 VERSION

version 0.004

=head1 SYNOPSIS

  $ pantry create node foo.example.com

=head1 DESCRIPTION

This class implements the C<pantry create> command, which is used to create a new node data file
in a pantry.

=for Pod::Coverage options validate

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

