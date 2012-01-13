
use strict;
use warnings;

use 5.014000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Configuration management tool for chef-solo",
  "AUTHOR" => "David Golden <dagolden\@cpan.org>",
  "BUILD_REQUIRES" => {
    "App::Cmd::Tester" => 0,
    "Capture::Tiny" => 0,
    "File::Find" => 0,
    "File::pushd" => "1.00",
    "Scalar::Util" => 0,
    "Test::More" => "0.92",
    "strict" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Pantry",
  "EXE_FILES" => [
    "bin/pantry"
  ],
  "LICENSE" => "apache",
  "NAME" => "Pantry",
  "PREREQ_PM" => {
    "App::Cmd::Setup" => "0.311",
    "File::Basename" => 0,
    "File::Path" => 0,
    "File::Slurp" => 0,
    "File::Temp" => "0.22",
    "IPC::Cmd" => 0,
    "JSON" => 0,
    "Net::OpenSSH" => 0,
    "autodie" => 0,
    "namespace::clean" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.001",
  "test" => {
    "TESTS" => "t/*.t t/create/*.t t/edit/*.t t/init/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



