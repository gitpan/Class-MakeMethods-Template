package Class::MakeMethods::Template::PseudoHash;

require Class::MakeMethods::Template::Array;
@ISA = qw( Class::MakeMethods::Template::Array );

sub generic {
  {
    '-import' => { 'Template::Struct:generic' => '*' },
  }
}

sub new {
  { 
    '-import' => { 
      'Template::PsuedoHash:generic' => '*',
      'Template::Generic:new' => '*',
    },
    'code_expr' => {
      _EMPTY_NEW_INSTANCE_ => 'bless [\%{"$class\::FIELDS"], _SELF_CLASS_',
    },
  }
}

1;
