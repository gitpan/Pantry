use v5.14;
use warnings;

package Pantry::Model::Pantry;
# ABSTRACT: Pantry data model for a pantry directory
our $VERSION = '0.004'; # VERSION

use Moose 2;
use MooseX::Types::Path::Class::MoreCoercions 0.002 qw/AbsDir/;
use namespace::autoclean;

use Path::Class;
use Path::Class::Rule;


has path => (
  is => 'ro',
  isa => AbsDir,
  coerce => 1,
  default => sub { dir(".")->absolute }
);

sub _env_path {
  my ($self, $env) = @_;
  $env //= '_default';
  my $path = $self->path->subdir("environments", $env);
  $path->mkpath;
  return $path;
}

sub _node_path {
  my ($self, $node_name, $env) = @_;
  return $self->_env_path($env)->file("${node_name}.json");
}


sub all_nodes {
  my ($self, $env) = @_;
  my @nodes = sort map { s/\.json$//r } map { $_->basename }
              $self->_env_path($env)->children;
  return @nodes;
}


sub node {
  my ($self, $node_name, $env) = @_;
  $node_name = lc $node_name;
  require Pantry::Model::Node;
  my $path = $self->_node_path( $node_name );
  if ( -e $path ) {
    return Pantry::Model::Node->new_from_file( $path );
  }
  else {
    return Pantry::Model::Node->new( name => $node_name, _path => $path );
  }
}

1;



__END__
=pod

=head1 NAME

Pantry::Model::Pantry - Pantry data model for a pantry directory

=head1 VERSION

version 0.004

=head1 SYNOPSIS

  my $pantry = Pantry::Model::Pantry->new;
  my $node = $pantry->node("foo.example.com");

=head1 DESCRIPTION

Models a 'pantry' -- a directory containing files used to manage servers with
Chef Solo by Opscode.

=head1 ATTRIBUTES

=head2 C<path>

Path to the pantry directory. Defaults to the current directory.

=head1 METHODS

=head2 all_nodes

  my @nodes = $pantry->all_nodes;

In list context, returns a list of nodes.  In scalar context, returns
a count of nodes.

=head2 C<node>

  my $node = $pantry->node("foo.example.com");

Returns a L<Pantry::Model::Node> object corresponding to the given node.
If the node exists in the pantry, it will be loaded from the saved node file.
Otherwise, it will be created in memory (but will not be persisted to disk).

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

