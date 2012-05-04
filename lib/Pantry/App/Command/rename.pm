use v5.14;
use warnings;

package Pantry::App::Command::rename;
# ABSTRACT: Implements pantry rename subcommand
our $VERSION = '0.004'; # VERSION

use Pantry::App -command;
use autodie;

use namespace::clean;

sub abstract {
  return 'Rename an item in a pantry (nodes, roles, etc.)';
}

sub command_type {
  return 'DUAL_TARGET';
}

sub valid_types {
  return qw/node/
}

sub _rename_node{
  my ($self, $opt, $name, $dest) = @_;

  my $node = $self->pantry->node( $name );
  my $dest_path = $self->pantry->node( $dest )->path;
  if ( ! -e $node->path ) {
    die( "Node '$name' doesn't exist\n" );
  }
  elsif ( -e $dest_path ) {
    die( "Node '$dest' already exists. Won't over-write it.\n" );
  }
  else {
    $node->save_as( $dest_path );
    unlink $node->path;
  }

  return;
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::rename - Implements pantry rename subcommand

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

