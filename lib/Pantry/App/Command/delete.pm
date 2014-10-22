use v5.14;
use warnings;

package Pantry::App::Command::delete;
# ABSTRACT: Implements pantry delete subcommand
our $VERSION = '0.009'; # VERSION

use Pantry::App -command;
use autodie;
use IO::Prompt::Tiny;
use namespace::clean;

sub abstract {
  return 'Delete an item in a pantry (nodes, roles, etc.)';
}

sub command_type {
  return 'TARGET';
}

sub valid_types {
  return qw/node role environment/
}

sub options {
  my ($self) = @_;
  return (
    ['force|f', "force deletion without confirmation"],
  );
}

sub _delete_node {
  my ($self, $opt, $name) = @_;
  $self->_delete_obj($opt, "node", $name);
}

sub _delete_role {
  my ($self, $opt, $name) = @_;
  $self->_delete_obj($opt, "role", $name);
}

sub _delete_environment {
  my ($self, $opt, $name) = @_;
  $self->_delete_obj($opt, "environment", $name);
}

sub _delete_obj {
  my ($self, $opt, $type, $name) = @_;

  my $options;
  $options->{env} = $opt->{env} if $opt->{env};
  my $obj = $self->_check_name($type, $name, $options);

  unless ( $opt->{force} ) {
    my $confirm = IO::Prompt::Tiny::prompt("Delete $type '$name'?", "no");
    unless ($confirm =~ /^y(?:es)?$/i) {
      print "$name will not be deleted\n";
      exit 0;
    }
  }

  unlink $obj->path;

  return;
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command::delete - Implements pantry delete subcommand

=head1 VERSION

version 0.009

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

