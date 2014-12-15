package Class::Private::Instance;

use strict;
use warnings;

sub AUTOLOAD {
  my $self = $_[0];
  my ($name) = our $AUTOLOAD =~ /::(\w+)$/;
  my $func = $self->($name) or die "Instance of anonymous class has no method $name";
  goto $func;
}

sub DESTROY { }

sub can { $_[0]->($_[1]) }

sub isa { goto $_[0]->('isa') }

1;

