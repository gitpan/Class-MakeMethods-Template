package Class::MakeMethods::Template::Hash;

use Class::MakeMethods::Template::Generic '-isasubclass';

use strict;
require 5.0;

=head1 NAME

B<Class::MakeMethods::Template::Hash> - Method interfaces for hash-based objects

=head1 SYNOPSIS

  package MyObject;
  use Class::MakeMethods::Template::Hash (
    new             => [ 'new' ],
    scalar          => [ 'foo', 'bar' ]
  );
  
  package main;

  my $obj = MyObject->new( foo => "Foozle", bar => "Bozzle" );
  print $obj->foo();
  $obj->bar("Bamboozle"); 

=head1 DESCRIPTION

These meta-methods create and access values within blessed hash objects.

B<Common Parameters>: The following parameters are defined for Hash meta-methods.

=over 4

=item hash_key

The hash key to use when retrieving values from each hash instance. Defaults to '*', the name of the meta-method.

Changing this allows you to change an accessor method name to something other than the name of the hash key used to retrieve its value.

Note that this parameter is not portable to the other implementations, such as Static or Flyweight.

=back

B<Common Behaviors>

=over 4

=item Behavior: delete

Deletes the named key and associated value from the current hash instance.

=back

=cut

sub generic {
  {
    'params' => {
      'hash_key' => '*',
    },
    'code_expr' => { 
      _VALUE_ => '_SELF_->{_STATIC_ATTR_{hash_key}}',
      '-import' => { 'Template::Generic:generic' => '*' },
    },
    'behavior' => {
      'hash_delete' => q{ delete _VALUE_ },
      'hash_exists' => q{ exists _VALUE_ },
    },
  }
}

=head2 new

There are several types of hash-based object constructors to choose from.

Each of these methods creates a new blessed hash and returns a reference to it. They differ in how their (optional) arguments are interpreted to set initial values within the hash, and in how they operate when called as class or instance methods.

See the documentation on C<Generic:new> for interfaces and behaviors.

=cut

sub new {
  { 
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:new' => '*',
    },
    'code_expr' => {
      _EMPTY_NEW_INSTANCE_ => 'bless {}, _SELF_CLASS_',
      _SET_VALUES_FROM_HASH_ => 'while ( scalar @_ ) { local $_ = shift(); $self->{ $_ } = shift() }'
    },
  }
}

########################################################################

=head2 scalar

Creates hash-key accessor methods for scalar values.

See the documentation on C<Generic:scalar> for interfaces and behaviors.

=cut

sub scalar {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:scalar' => '*',
    },
  }
}

sub string {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:string' => '*',
    },
  }
}

########################################################################

=head2 string_index

  string_index => [ qw / foo bar baz / ]

Creates string accessor methods for hash objects, like Hash:string
above, but also maintains a static hash index in which each object
is stored under the value of the field when the slot is set. If an
object has a slot set to a value which another object is already
set to the object currently set to that value has that slot set to
undef and the new object will be put into the hash under that value.
(I.e.  only one object can have a given key.)

The method find_x is defined which if called with any arguments
returns a list of the objects stored under those values in the
hash. Called with no arguments, it returns a reference to the hash.

Objects with undefined values are not stored in the index.

Note that to free items from memory, you must clear these values!

=head2 find_or_new

  'string_index -find_or_new' => [ qw / foo bar baz / ]

Just like string_index except the find_x method is defined to call the new
method to create an object if there is no object already stored under
any of the keys you give as arguments.

=cut

sub string_index {
  {
    '-import' => { 'Template::Generic:string_index' => '*' },
    'params' => { 
      'hash_key' => '*',
    },
    'code_expr' => { 
      _VALUE_ => '_SELF_->{_ATTR_{hash_key}}',
    },
  } 
}

########################################################################

sub number {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:number' => '*',
    },
  }
}

########################################################################

sub boolean {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:boolean' => '*',
    },
  }
}

########################################################################

=head2 array

Creates hash-key accessor methods for array-ref values.

See the documentation on C<Generic:array> for interfaces and behaviors.

=cut

sub array {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:array' => '*',
    },
  } 
}

########################################################################

=head2 struct

  struct => [ qw / foo bar baz / ];

Creates methods for setting, checking and clearing values which
are stored by position in an array. All the slots created with this
meta-method are stored in a single array.

The argument to struct should be a string or a reference to an
array of strings. For each string meta-method x, it defines two
methods: I<x> and I<clear_x>. x returns the value of the x-slot.
If called with an argument, it first sets the x-slot to the argument.
clear_x sets the slot to undef.

Additionally, struct defines three class method: I<struct>, which returns
a list of all of the struct values, I<struct_fields>, which returns
a list of all the slots by name, and I<struct_dump>, which returns a hash of
the slot-name/slot-value pairs.

=cut

sub struct {
  ( {
    'params' => { 'hash_key' => '*' },
    'interface' => {
      default => { 
	  '*'=>'get_set', 'clear_*'=>'clear',
	  'struct_fields'=>'struct_fields', 
	  'struct'=>'struct', 'struct_dump'=>'struct_dump' 
      },
    },
    'behavior' => {
      '-init' => sub {
	my $m_info = $_[0]; 
	
	$m_info->{class} ||= $m_info->{target_class};
	$m_info->{bstore} ||= $m_info->{class} . '__boolean';
	
	my $class_info = 
	  ( $Class::MakeMethods::Template::Hash::struct{$m_info->{class}} ||= [] );
	if ( ! defined $m_info->{sfp} ) {
	  foreach ( 0..$#$class_info ) { 
	    if ( $class_info->[$_] eq $m_info->{'name'} ) {
	      $m_info->{sfp} = $_; 
	      last 
	    }
	  }
	  if ( ! defined $m_info->{sfp} ) {
	    push @$class_info, $m_info->{'name'};
	    $m_info->{sfp} = $#$class_info;
	  }
	}
	return;	
      },
      
      'struct_fields' => sub { my $m_info = $_[0]; sub {
	my $class_info = 
	  ( $Class::MakeMethods::Template::Hash::struct{$m_info->{class}} ||= [] );
	  @$class_info;
	}},
      'struct' => sub { my $m_info = $_[0]; sub {
	  my $self = shift;
	  $self->{'struct'} ||= [];
	  if ( @_ ) { @{$self->{'struct'}} = @_ }
	  @{$self->{'struct'}};
	}},
      'struct_dump' => sub { my $m_info = $_[0]; sub {
	  my $self = shift;
	  my $class_info = 
	    ( $Class::MakeMethods::Template::Hash::struct{$m_info->{class}} ||= [] );
	  map { ($_, $self->$_()) } @$class_info;
	}},
      
      'get_set' => sub { my $m_info = $_[0]; sub {
	  my $self = shift;
	  $self->{'struct'} ||= [];
	
	  if ( @_ ) {
	    $self->{'struct'}->[ $m_info->{sfp} ] = shift;
	  }
	  $self->{'struct'}->[ $m_info->{sfp} ];
	}},
      'clear' => sub { my $m_info = $_[0]; sub {
	  my $self = shift;
	  $self->{'struct'} ||= [];
	  $self->{'struct'}->[ $m_info->{sfp} ] = undef;
	}},
    },
  } )
}


########################################################################

=head2 hash

Creates hash-key accessor methods for hash-ref values.

See the documentation on C<Generic:hash> for interfaces and behaviors.

=cut

sub hash {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:hash' => '*',
    },
  } 
}

########################################################################

=head2 tiedhash

A variant of Hash:hash which initializes the hash by tieing it to a caller-specified package.

See the documentation on C<Generic:tiedhash> for interfaces and behaviors, and for I<required> additional parameters.

=cut

sub tiedhash {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:tiedhash' => '*',
    },
  } 
}

########################################################################

=head2 hash_of_arrays

Creates hash-key accessor methods for references to hashes of array-refs.

See the documentation on C<Generic:hash_of_arrays> for interfaces and behaviors.

=cut

sub hash_of_arrays {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:hash_of_arrays' => '*',
    },
  }
}

########################################################################

=head2 object

Creates meta-methods for hash objects which contain references to other objects.

See the documentation on C<Generic:object> for interfaces, behaviors, and parameters.

=cut

sub object {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:object' => '*',
    },
  }
}

########################################################################

=head2 array_of_objects

Creates meta-methods for hash objects which contain an array of object references. 

See the documentation on C<Generic:array_of_objects> for interfaces, behaviors, and parameters.

=cut

sub array_of_objects {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:array_of_objects' => '*',
    },
  }
}

########################################################################

=head2 code

Creates meta-methods for hash objects which contain an subroutine reference. 

See the documentation on C<Generic:code> for interfaces, behaviors, and parameters.

=cut

sub code {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:code' => '*',
    },
  }
}

########################################################################

=head2 bits

Creates hash-key accessor methods for bit-field values.

See the documentation on C<Generic:bits> for interfaces and behaviors.

The difference between 'Hash:bits' and 'Hash:boolean' is
that all flags created with this meta-method are stored in a single
vector for space efficiency.

B<Parameters>:

=over 4

=item hash_key

Initialized to '*{target_class}__boolean'. 

=back

=cut

sub bits {
  {
    '-import' => { 
      'Template::Hash:generic' => '*',
      'Template::Generic:bits' => '*',
    },
    'params' => {
      'hash_key' => '*{target_class}__boolean',
    },
  }
}

=head1  SEE ALSO

Class::MakeMethods

=cut

1;
