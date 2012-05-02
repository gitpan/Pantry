use v5.14;
use warnings;

package Pantry::App::Command;
# ABSTRACT: Pantry command superclass
our $VERSION = '0.002'; # VERSION

use App::Cmd::Setup -command;

sub opt_spec {
  my ($class, $app) = @_;
    return (
    # Universal
    [ 'help' => "This usage screen" ],
    # Selectors/qualifiers
    [ 'recipe|r=s@' => "A recipe" ],
    [ 'default|d=s@' => "Default attribute" ],
    $class->options($app),
  )
}
 
sub validate_args {
  my ( $self, $opt, $args ) = @_;
  die $self->_usage_text if $opt->{help};
  $self->validate( $opt, $args );
}

sub pantry {
  my $self = shift;
  require Pantry::Model::Pantry;
  $self->{pantry} ||= Pantry::Model::Pantry->new;
  return $self->{pantry};
}

1;


# vim: ts=2 sts=2 sw=2 et:

__END__
=pod

=head1 NAME

Pantry::App::Command - Pantry command superclass

=head1 VERSION

version 0.002

=head1 DESCRIPTION

This internal implementation class defines common command line options
and provides methods needed by all command subclasses.

=for Pod::Coverage pantry

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

