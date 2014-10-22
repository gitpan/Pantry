use v5.14;
use strict;
use warnings;
use autodie;
use Test::More 0.92;

use File::pushd 1.00 qw/tempd/;

use App::Cmd::Tester;
use Pantry::App;

use Capture::Tiny qw/capture/; # until App::Cmd::Tester::CaptureExtended

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

  $result = test_app( 'Pantry::App' => [qw(create node foo.example.com)] );
  $result->error and BAIL_OUT("could not create node foo.example.com");
  pass( "created test node" );

  local $ENV{VISUAL} = local $ENV{EDITOR} = "echo";
  my $node_file = 'environments/_default/foo.example.com.json';
  
  my ($stdout, $stderr) = capture {
    $result = test_app( 'Pantry::App' => [qw(edit node foo.example.com)] );
  };

  is( $result->error, undef, "ran 'pantry edit node ...' without error" )
    or diag $result->output;
  like( $stdout, qr/\Q$node_file\E/, "Editor invoked on node file" )
    or diag $stdout;
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
