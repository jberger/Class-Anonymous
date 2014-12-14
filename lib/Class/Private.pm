package Class::Private;

use strict;
use warnings;

use Class::Private::Instance;

use Exporter 'import';
our @EXPORT = 'class';

sub instance {
  my $methods = shift || {};
  return bless sub {
    return {%$methods} unless @_;
    my $name = shift;
    $methods->{$name} = shift if @_;
    return $methods->{$name};
  } => 'Class::Private::Instance';
};

sub extend {
  my ($base, $extension) = @_;
  my $methods = $base->();
  my $constructor = $methods->{new};
  $methods->{new} = sub {
    my $class = shift;
    my $self = $class->$constructor(@_);
    $self->$extension(@_);
    return $self;
  };
  return instance($methods);
};

my $class = instance({
  new    => sub { instance() },
  extend => \&extend,
});

sub class (&) { extend($class, shift) }

1;


