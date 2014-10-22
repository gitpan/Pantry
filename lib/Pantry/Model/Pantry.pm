use v5.14;
use warnings;

package Pantry::Model::Pantry;
# ABSTRACT: Pantry data model for a pantry directory
our $VERSION = '0.008'; # VERSION

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

sub _env_dir {
  my ($self, $env) = @_;
  $env //= '_default';
  my $path = $self->path->subdir("environments", $env);
  $path->mkpath;
  return $path;
}

sub _role_dir {
  my ($self) = @_;
  my $path = $self->path->subdir("roles");
  $path->mkpath;
  return $path;
}

sub _cookbook_dir {
  my ($self) = @_;
  my $path = $self->path->subdir("cookbooks");
  $path->mkpath;
  return $path;
}

sub _role_path {
  my ($self, $role_name) = @_;
  return $self->_role_dir->file("${role_name}.json");
}

sub _node_path {
  my ($self, $node_name, $env) = @_;
  return $self->_env_dir($env)->file("${node_name}.json");
}

sub _cookbook_path {
  my ($self, $cookbook_name) = @_;
  return $self->_cookbook_dir->subdir("${cookbook_name}");
}


sub all_nodes {
  my ($self, $env) = @_;
  my @nodes = sort map { s/\.json$//r } map { $_->basename }
              $self->_env_dir($env)->children;
  return @nodes;
}


sub node {
  my ($self, $node_name, $options ) = @_;
  $options //= {};
  $node_name = lc $node_name;
  require Pantry::Model::Node;
  my $path = $self->_node_path( $node_name );
  if ( -e $path ) {
    return Pantry::Model::Node->new_from_file( $path );
  }
  else {
    return Pantry::Model::Node->new( name => $node_name, _path => $path, %$options );
  }
}


sub find_node {
  my ($self, $pattern) = @_;
  return map { $self->node($_) } grep { $_ =~ /^\Q$pattern\E/ } $self->all_nodes;
}


sub all_roles {
  my ($self, $env) = @_;
  my @roles = sort map { s/\.json$//r } map { $_->basename }
              $self->_role_dir->children;
  return @roles;
}


sub role {
  my ($self, $role_name, $env) = @_;
  $role_name = lc $role_name;
  require Pantry::Model::Role;
  my $path = $self->_role_path( $role_name );
  if ( -e $path ) {
    return Pantry::Model::Role->new_from_file( $path );
  }
  else {
    return Pantry::Model::Role->new( name => $role_name, _path => $path );
  }
}


sub find_role {
  my ($self, $pattern) = @_;
  return map { $self->role($_) } grep { $_ =~ /^\Q$pattern\E/ } $self->all_roles;
}


sub cookbook {
  my ($self, $cookbook_name, $env) = @_;
  $cookbook_name = lc $cookbook_name;
  require Pantry::Model::Cookbook;
  my $path = $self->_cookbook_path( $cookbook_name );
  return Pantry::Model::Cookbook->new( name => $cookbook_name, _path => $path );
}

1;



__END__
=pod

=head1 NAME

Pantry::Model::Pantry - Pantry data model for a pantry directory

=head1 VERSION

version 0.008

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

=head2 find_node

  my @nodes = $pantry->find_node( $leading_part );

Finds one or more node matching a leading part.  For example, given
nodes 'foo.example.com' and 'bar.example.com' in a pantry, use
C<<$pantry->find_node("foo")>> to get 'foo.example.com'.

Returns a list of node objects if any are found.

=head2 all_roles

  my @roles = $pantry->all_roles;

In list context, returns a list of roles.  In scalar context, returns
a count of roles.

=head2 C<role>

  my $node = $pantry->role("web");

Returns a L<Pantry::Model::Role> object corresponding to the given role.
If the role exists in the pantry, it will be loaded from the saved role file.
Otherwise, it will be created in memory (but will not be persisted to disk).

=head2 find_role

  my @roles = $pantry->find_role( $leading_part );

Finds one or more role matching a leading part.  For example, given roles 'web'
and 'mysql' in a pantry, use C<<$pantry->find_role("my")>> to get 'mysql'.

Returns a list of role objects if any are found.

=head2 C<cookbook>

  my $node = $pantry->cookbook("myapp");

Returns a L<Pantry::Model::Cookbook> object corresponding to the given cookbook.

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

