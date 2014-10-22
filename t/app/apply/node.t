use v5.14;
use strict;
use warnings;
use autodie;
use Test::More 0.92;

use lib 't/lib';
use TestHelper;

subtest "apply recipe" => sub {
  my ($wd, $pantry) = _create_node or return;

  _try_command(qw(apply node foo.example.com -r nginx));

  my $node = $pantry->node("foo.example.com");
  is_deeply( [$node->run_list], [ 'recipe[nginx]' ], "apply -r nginx successful" )
    or diag explain $node;
};

subtest "apply attribute" => sub {
  my ($wd, $pantry) = _create_node or return;
  _try_command(qw(apply node foo.example.com -d nginx.port=80));

  my $node = $pantry->node("foo.example.com")
    or BAIL_OUT "Couldn't get node for testing";
  is( $node->get_attribute('nginx.port'), 80, "attribute set successfully" )
    or _dump_node($node);
};

subtest "apply list attribute" => sub {
  no warnings 'qw'; # separating words with commas
  my ($wd, $pantry) = _create_node or return;
  _try_command(qw(apply node foo.example.com -d nginx.port=80,8080));

  my $node = $pantry->node("foo.example.com")
    or BAIL_OUT "Couldn't get node for testing";
  is_deeply( $node->get_attribute('nginx.port'), [80,8080], "list attribute set successfully" )
    or _dump_node($node);
};

subtest "apply attributes with escapes" => sub {
  no warnings 'qw'; # separating words with commas
  my ($wd, $pantry) = _create_node or return;
  _try_command(qw(apply node foo.example.com -d nginx\.port=80,8000\,8080));

  my $node = $pantry->node("foo.example.com")
    or BAIL_OUT "Couldn't get node for testing";
  is_deeply( $node->get_attribute('nginx\.port'), [80,'8000,8080'], "attributes with escapes set successfully" )
    or _dump_node($node);
};

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
