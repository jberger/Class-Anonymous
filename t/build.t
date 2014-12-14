use strict;
use warnings;

use Test::More;
use Class::Private;

my $class = class {
  my ($self, $name) = @_;
  $self->(greet => sub { "Hello, my name is $name" });
  $self->(yell  => sub { uc $_[1] });
  $self->(isa   => sub { $_[1] =~ /c/i }); # I am anything that contains a 'c'
};

my $instance = $class->new('Joel');
is $instance->greet, 'Hello, my name is Joel';
is $instance->can('greet')->(), 'Hello, my name is Joel';
is $instance->yell('can you hear me?'), 'CAN YOU HEAR ME?';
ok $instance->isa('Cow');
ok !$instance->isa('Horse');

done_testing;

