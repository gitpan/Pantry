use v5.14;
use warnings;

package Pantry::App::Command::create;
# ABSTRACT: Implements pantry create subcommand
our $VERSION = '0.001'; # VERSION

use Pantry::App -command;
use autodie;
use File::Basename qw/dirname/;
use File::Path qw/mkpath/;
use File::Slurp qw/write_file/;
use JSON;

use namespace::clean;

sub abstract {
  return 'create items in a pantry (nodes, roles, etc.)';
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
    $self->usage_error( "This command requires the name for the thing to create" );
  }
  elsif ( -e $self->app->node_path($name) ) {
    $self->usage_error( "Node '$name' already exists" );
  }

  return;
}

sub execute {
  my ($self, $opt, $args) = @_;

  my ($type, $name) = splice(@$args, 0, 2);
  my $path = $self->app->node_path($name);
  my $data = $self->_node_guts($name);
  mkpath( dirname($path) );
  write_file( $path, { no_clobber => 1, binmode => ":raw" }, $data );
  return;
}

#--------------------------------------------------------------------------#
# Internal
#--------------------------------------------------------------------------#

sub _node_guts {
  my ($self, $name) = @_;

  my $data = {
    name => $name,
    default => {},
    override => {},
    normal => {},
    automatic => {},
    run_list => [],
  };

  my $json = eval {JSON->new->pretty(1)->utf8(1)->encode($data)};
  die "JSON encoding error: $@\n" if $@;

  return $json;
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::create - Implements pantry create subcommand

=head1 VERSION

version 0.001

=for Pod::Coverage options validate

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

