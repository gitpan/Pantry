use v5.14;
use strict;
use warnings;
no warnings 'qw'; # separating words with commas
use autodie;
use Test::More 0.92;

use lib 't/lib';
use TestHelper;
use JSON;

my %templates = (
  node => {
    run_list => [],
  },
  role => {
    json_class => "Chef::Role",
    chef_type => "role",
    run_list => [],
    default_attributes => {},
    override_attributes => {},
  },
);

my @cases = (
  {
    type => "node",
    name => 'foo.example.com',
    new => sub { my ($p,$n) = @_; $p->node($n) },
    subtests => [
      {
        argv => [ qw/-r nginx/ ],
        expected => {
          run_list => [ 'recipe[nginx]' ],
        },
      },
      {
        argv => [ qw/-R web/ ],
        expected => {
          run_list => [ 'role[web]' ],
        },
      },
      {
        argv => [ qw/-r postfix -r iptables -R web/ ],
        expected => {
          run_list => [ qw/role[web] recipe[postfix] recipe[iptables]/ ],
        },
      },
      {
        argv => [ qw/-d nginx.port=80/ ],
        expected => {
          run_list => [],
          nginx => { port => 80 },
        },
      },
      {
        argv => [ qw/-d nginx.port=80,8080/ ],
        expected => {
          run_list => [],
          nginx => { port => [80,8080] },
        },
      },
      {
        argv => [ qw/-d nginx\.port=80,8000\,8080/ ],
        expected => {
          run_list => [],
          'nginx.port' => [80,'8000,8080'],
        },
      },
    ],
  },

  {
    type => "role",
    name => 'web',
    new => sub { my ($p,$n) = @_; $p->role($n) },
    subtests => [
      {
        argv => [ qw/-r nginx/ ],
        expected => {
          run_list => [ 'recipe[nginx]' ],
        },
      },
      {
        argv => [ qw/-R web/ ],
        expected => {
          run_list => [ 'role[web]' ],
        },
      },
      {
        argv => [ qw/-d nginx.port=80/ ],
        expected => {
          default_attributes => {
            nginx => { port => 80 },
          },
        },
      },
      {
        argv => [ qw/--override nginx.port=80/ ],
        expected => {
          override_attributes => {
            nginx => { port => 80 },
          },
        },
      },
      {
        argv => [ qw/-d nginx.port=80,8080/ ],
        expected => {
          default_attributes => {
            nginx => { port => [80,8080] },
          },
        },
      },
      {
        argv => [ qw/-d nginx\.port=80,8000\,8080/ ],
        expected => {
          default_attributes => {
            'nginx.port' => [80,'8000,8080'],
          },
        },
      },
    ],
  },
);

for my $c ( @cases ) {
  for my $st ( @{$c->{subtests}} ) {
    subtest "$c->{type} NAME @{$st->{argv}}" => sub {
      my ($wd, $pantry) = _create_pantry();
      my $obj = $c->{new}->($pantry, $c->{name});

      _try_command('create', $c->{type}, $c->{name});
      _try_command('apply', $c->{type}, $c->{name}, @{$st->{argv}}) ;

      my $data = _thaw_file( $obj->path );
      $st->{expected}{name} //= $c->{name};
      for my $k ( keys %{$templates{$c->{type}}} ) {
        $st->{expected}{$k} //= $templates{$c->{type}}{$k};
      }

      is_deeply( $data, $st->{expected}, "data file correct" )
        or diag explain $data;
    };
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
