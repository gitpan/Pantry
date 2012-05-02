use v5.14;
use warnings;

package Pantry::Model::Role;
# ABSTRACT: Pantry data model for Chef roles
our $VERSION = '0.003'; # VERSION

use Moose 2;
use List::AllUtils qw/uniq first/;
use namespace::autoclean;

# new_from_file, save_as
with 'Pantry::Role::Serializable';

# in_run_list, append_to_runliset
with 'Pantry::Role::Runlist';

#--------------------------------------------------------------------------#
# static keys/values required by Chef
#--------------------------------------------------------------------------#

has chef_type => (
  is => 'bare',
  isa => 'Str',
  default => 'role',
  init_arg => undef,
);

has json_class => (
  is => 'bare',
  isa => 'Str',
  default => 'Chef::Role',
  init_arg => undef,
);

#--------------------------------------------------------------------------#
# Chef role attributes
#--------------------------------------------------------------------------#

has name => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has description => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_description {
  my $self = shift;
  return "The " . $self->name . " role";
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::Model::Role - Pantry data model for Chef roles

=head1 VERSION

version 0.003

=head1 DESCRIPTION

Under development.

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

