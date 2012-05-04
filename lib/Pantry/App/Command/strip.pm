use v5.14;
use warnings;

package Pantry::App::Command::strip;
# ABSTRACT: Implements pantry strip subcommand
our $VERSION = '0.004'; # VERSION

use Pantry::App -command;
use autodie;

use namespace::clean;

sub abstract {
  return 'Strip recipes or attributes from a node'
}

sub command_type {
  return 'TARGET';
}

sub valid_types {
  return qw/node/
}

sub options {
  my ($self) = @_;
  return $self->data_options;
}

sub _strip_node {
  my ($self, $opt, $name) = @_;

  my $node = $self->pantry->node( $name )
    or $self->usage_error( "Node '$name' does not exist" );

  if ($opt->{recipe}) {
    $node->remove_from_run_list(map { "recipe[$_]" } @{$opt->{recipe}});
  }

  if ($opt->{default}) {
    for my $attr ( @{ $opt->{default} } ) {
      my ($key, $value) = split /=/, $attr, 2; # split on first '='
      # if they gave a value, we ignore it
      $node->delete_attribute($key);
    }
  }

  $node->save;

  return;
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::strip - Implements pantry strip subcommand

=head1 VERSION

version 0.004

=head1 SYNOPSIS

  $ pantry strip node foo.example.com --recipe nginx --default nginx.port

=head1 DESCRIPTION

This class implements the C<pantry strip> command, which is used to strip recipes or attributes
from a node.

=for Pod::Coverage options validate

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

