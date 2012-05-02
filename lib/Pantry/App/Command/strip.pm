use v5.14;
use warnings;

package Pantry::App::Command::strip;
# ABSTRACT: Implements pantry strip subcommand
our $VERSION = '0.002'; # VERSION

use Pantry::App -command;
use autodie;

use namespace::clean;

sub abstract {
  return 'strip recipes or attributes from a node'
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
    $self->usage_error( "This command requires the name for the thing to modify" );
  }

  return;
}

sub execute {
  my ($self, $opt, $args) = @_;

  my ($type, $name) = splice(@$args, 0, 2);

  if ( $type eq 'node' ) {
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
  }

  return;
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::strip - Implements pantry strip subcommand

=head1 VERSION

version 0.002

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

