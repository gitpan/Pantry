use v5.14;
use warnings;

package Pantry::App::Command::apply;
# ABSTRACT: Implements pantry apply subcommand
our $VERSION = '0.004'; # VERSION

use Pantry::App -command;
use autodie;

use namespace::clean;

sub abstract {
  return 'Apply recipes or attributes to a node'
}

sub command_type {
  return 'TARGET';
}

sub options {
  my ($self) = @_;
  return $self->data_options;
}

sub valid_types {
  return qw/node/
}

sub _apply_node {
  my ($self, $opt, $name) = @_;
  my $node = $self->pantry->node( $name )
    or $self->usage_error( "Node '$name' does not exist" );

  if ($opt->{recipe}) {
    $node->append_to_run_list(map { "recipe[$_]" } @{$opt->{recipe}});
  }

  if ($opt->{default}) {
    for my $attr ( @{ $opt->{default} } ) {
      my ($key, $value) = split /=/, $attr, 2; # split on first '='
      if ( $value =~ /(?<!\\),/ ) {
        # split on unescaped commas, then unescape escaped commas
        $value = [ map { s/\\,/,/gr } split /(?<!\\),/, $value ];
      }
      $node->set_attribute($key, $value);
    }
  }

  $node->save;
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::apply - Implements pantry apply subcommand

=head1 VERSION

version 0.004

=head1 SYNOPSIS

  $ pantry apply node foo.example.com --recipe nginx --default nginx.port=8080

=head1 DESCRIPTION

This class implements the C<pantry apply> command, which is used to apply recipes or attributes
to a node.

=for Pod::Coverage options validate

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

