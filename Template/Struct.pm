package Class::MakeMethods::Template::Struct;

require Class::MakeMethods::Template::Generic;
@ISA = qw( Class::MakeMethods::Template::Generic );

use strict;
require 5.00;
use Carp;

=head1 NAME

B<Class::MakeMethods::Template::Struct> - Methods for manipulating positional values in arrays

=head1 SYNOPSIS


=head1 DESCRIPTION

=cut

use vars qw( %ClassInfo );

sub generic {
  {
    'params' => {
      'array_index' => undef,
    },
    'code_expr' => { 
      _VALUE_ => '_SELF_->[_STATIC_ATTR_{array_index}]',
      '-import' => { 'Template::Generic:generic' => '*' },
    },
    'behavior' => {
      '-init' => sub {
	my $m_info = $_[0]; 
	
	# If we're the first one, 
	if ( ! $ClassInfo{$m_info->{target_class}} ) {
	  # traverse inheritance hierarchy, looking for fields to inherit
	  my @results;
	  no strict 'refs';
	  my @sources = @{"$m_info->{target_class}\::ISA"};
	  while ( my $class = shift @sources ) {
	    next unless exists $ClassInfo{ $class };
	    push @sources, @{"$class\::ISA"};
	    if ( scalar @results ) { 
	      Carp::croak "Too many inheritances of fields";
	    }
	    push @results, @{$ClassInfo{$class}};
	  }
	  $ClassInfo{$m_info->{target_class}} = \@sources;
	}
	
	my $class_info = $ClassInfo{$m_info->{target_class}};
	if ( ! defined $m_info->{array_index} ) {
	  foreach ( 0..$#$class_info ) { 
	    if ( $class_info->[$_] eq $m_info->{'name'} ) {
	      $m_info->{array_index} = $_; last }
	  }
	  if ( ! defined $m_info->{array_index} ) {
	    push @ $class_info, $m_info->{'name'};
	    $m_info->{array_index} = $#$class_info;
	  }
	}
	
	return;	
      },
    },
  } 
}

sub new {
  { 
    '-import' => { 
      'Template::Struct:generic' => '*',
      'Template::Generic:new' => '*',
    },
    'code_expr' => {
      _EMPTY_NEW_INSTANCE_ => 'bless [], _SELF_CLASS_',
      _SET_VALUES_FROM_HASH_ => 'while ( scalar @_ ) { local $_ = shift(); $self->[ _BFP_FROM_NAME_{ $_ } ] = shift() }'
    },
  }
}

sub scalar {
  {
    '-import' => { 
      'Template::Struct:generic' => '*',
      'Template::Generic:scalar' => '*',
    },
  }
}

sub string {
  {
    '-import' => { 
      'Template::Struct:generic' => '*',
      'Template::Generic:string' => '*',
    },
  }
}

sub number {
  {
    '-import' => { 
      'Template::Struct:generic' => '*',
      'Template::Generic:number' => '*',
    },
  }
}

sub boolean {
  {
    '-import' => { 
      'Template::Struct:generic' => '*',
      'Template::Generic:boolean' => '*',
    },
  }
}

sub array {
  {
    '-import' => { 
      'Template::Struct:generic' => '*',
      'Template::Generic:array' => '*',
    },
  } 
}

sub hash {
  {
    '-import' => { 
      'Template::Struct:generic' => '*',
      'Template::Generic:hash' => '*',
    },
  } 
}

sub object {
  {
    '-import' => { 
      'Template::Struct:generic' => '*',
      'Template::Generic:object' => '*',
    },
  }
}

1;
