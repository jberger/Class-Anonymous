use v5.10;
use strict;
use warnings;

use Class::Anonymous;
use Class::Anonymous::Utils 'method';

my %hash = (
  foo => 'bar',
  baz => 'fuzz',
);

my $ro_hash = class {
  my ( $self, %hash ) = @_;
  for my $key ( keys %hash ) {
    method $key => sub { $hash{$key} };
  }
};
my $obj = $ro_hash->new( %hash );

say $obj->foo;
say $obj->baz;

