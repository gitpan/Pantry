use v5.14;
use warnings;

package Pantry::App::Command::list;
# ABSTRACT: Implements pantry list subcommand
our $VERSION = '0.002'; # VERSION

use Pantry::App -command;
use autodie;
use Path::Class::Rule;

use namespace::clean;

sub abstract {
  return 'list information about pantry contents';
}

sub options {
  return;
}

sub validate {
  my ($self, $opts, $args) = @_;
  my ($type) = @$args;

  # validate type
  if ( ! length $type ) {
    $self->usage_error( "This command requires a target type and name" );
  }
  elsif ( $type !~ /nodes?/ ) {
    $self->usage_error( "Invalid type '$type'" );
  }

  return;
}

sub execute {
  my ($self, $opt, $args) = @_;

  my ($type) = shift @$args;

  $self->_list_node;

  return;
}

#--------------------------------------------------------------------------#
# Internal
#--------------------------------------------------------------------------#

sub _list_node {
  my ($self) = @_;
  my $pcr = Path::Class::Rule->new->file->name("*.json");
  say $_->basename for $pcr->all("environments/_default");
}
1;



# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::list - Implements pantry list subcommand

=head1 VERSION

version 0.002

=head1 SYNOPSIS

  $ pantry list nodes

=head1 DESCRIPTION

This class implements the C<pantry list> command, which is used to generate a list
of items in a pantry directory.

Supported types are:

=over 4

=item *

C<node>, C<nodes> -- list nodes

=back

=for Pod::Coverage options validate

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

