#!/usr/bin/perl
# Script d'arrêt d'une Baie SAN de type DELL Equallogic

use strict;
use warnings;
use Net::SSH2;

my $host = '$ADRESSE-IP';
my $user = 'grpadmin';
my $pass = '$PASSWORD$';
my $debg = 0;
my $shut = 'yes';

my $ssh = Net::SSH2->new();
$ssh->connect( $host ) or die $!;

if( $ssh->auth_password( $user, $pass )){
  my $chan = $ssh->channel();
  $chan->shell();

  if( $debg ){
    while( <$chan> ){ print };
  }

  print $chan "shutdown\r\n";
  while( 1 ){
    my $line = <$chan>;
    next unless defined $line;
    print $line if $debg;
    last if $line =~ /\[no\]/;
  }

  print $chan "$shut\n";
  if( $debg ){
    while( <$chan> ){ print };
  }

  print $chan "logout\r\n";
}

else {
  print "Erreur d'authentification: $!.\n";
}
