use v5.14;
use strict;
use warnings;
use autodie;
use Test::More 0.92;

use File::pushd 1.00 qw/tempd/;
use File::Slurp qw/read_file/;
use JSON;
use Scalar::Util qw/reftype/;

use App::Cmd::Tester;
use Pantry::App;

#--------------------------------------------------------------------------#
# create single node
#--------------------------------------------------------------------------#-

my $empty = {
  default => {},
  override => {},
  normal => {},
  automatic => {},
  run_list => [],
};


{
  my $wd = tempd;

  my $result = test_app( 'Pantry::App' => [qw(init)] );
  $result->error and BAIL_OUT("could not initialize pantry in $wd");
  pass( "created test pantry" );

  my $node_file = 'environments/_default/foo.example.com.json';
  ok( ! -e $node_file, "no node file exists yet" );
  $result = test_app( 'Pantry::App' => [qw(create node foo.example.com)] );
  is( $result->error, undef, "ran 'pantry create node ...' without error" )
    or diag $result->output;
  ok( -f $node_file, "node file has been created" );

  my $data = eval { decode_json( scalar read_file( $node_file ) ) };
  ok( $data, "node file is valid JSON" ) or diag $@;

  is( $data->{name}, "foo.example.com", "name field correct" );

  for my $k ( sort keys %$empty ) {
    my $field = $data->{$k};
    ok( defined $field && reftype($field) eq reftype($empty->{$k}),
      "$k field correct type"
    );
    is( scalar((reftype($field) eq 'HASH') ? %$field : @$field), 0,
      "$k field is empty"
    );
  }

}

done_testing;
#
# This file is part of Pantry
#
# This software is Copyright (c) 2011 by David Golden.
#
# This is free software, licensed under:
#
#   The Apache License, Version 2.0, January 2004
#
