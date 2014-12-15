package Class::Anonymous;

use strict;
use warnings;

use Class::Anonymous::Instance;

use Exporter 'import';
our @EXPORT = qw/class extend via/;

use List::Util 'first';
use Scalar::Util 'refaddr';

my $new = sub {
  my $class = shift;
  my @isa = $class->isa();
  push @isa, $class;
  my $self = instance(@isa);
  $_->('BUILD')->($self, @_) for @isa;
  return $self;
};

sub instance {
  my @isa = @_;
  my %methods;

  my $isa = sub {
    my $self = shift;
    return @isa unless @_;
    my $class = shift;
    return unless ref $class;
    my $addr = refaddr $class;
    return first { $addr == refaddr $_ } reverse @isa;
  };

  return bless sub {
    return unless my $name = shift;
    return $isa if $name eq 'isa';
    return $new if $name eq 'new'; 
    $methods{$name} = shift if @_;
    return $methods{$name};
  } => 'Class::Anonymous::Instance';
};

sub class (&) {
  my $builder = shift;
  my $class = instance(@_);
  $class->(BUILD => $builder);
  return $class;
}

sub extend {
  my ($class, $extension) = @_;
  my @isa = $class->isa();
  return &class($extension, @isa, $class);
}

sub via (&) { $_[0] }

1;


