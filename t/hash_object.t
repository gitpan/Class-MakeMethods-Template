#!/usr/bin/perl

package Y;
sub new { bless { foo => 'foo', bar => 'bar' }, shift; }
sub foo { shift->{'foo'}; }
sub bar {
  my ($self, $new) = @_;
  defined $new and $self->{'bar'} = $new;
  $self->{'bar'};
}

package X;

use lib qw ( ./t );
use Test;

use Class::MakeMethods::Template::Hash
  object  => [ 
    '--get_set_init',
    '-class' => 'Y',
    'a',
    [ qw / b c d / ],
    {
      name => 'e',
      delegate => [ qw / foo / ],
    },
    {
      name => 'f',
      delegate => [ qw / bar / ],
    }
  ];

sub new { bless {}, shift; }
my $o = new X;

TEST { 1 };

TEST { ref $o->a eq 'Y' };
TEST { ref $o->b eq 'Y' };

my $y = new Y;
TEST { $o->c($y); };
TEST { $o->c eq $y };
TEST { ref $o->c eq 'Y' };

TEST { ref $o->e eq 'Y' };

TEST { $o->foo eq 'foo' };
TEST { $o->bar('bar') };
TEST { $o->bar eq 'bar' };

TEST { $o->e->foo eq $o->foo };

exit 0;

