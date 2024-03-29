package Class::MakeMethods::Template::DiskCache;

$VERSION = 1.000_001;

@EXPORT_OK = qw( disk_cache );
sub import { require Exporter and goto &Exporter::import } # lazy Exporter

use strict;
use Carp;
use File::Spec;
use File::Path;

########################################################################

use vars qw( $DiskCacheDir );

my $IndexFile = "methods.ix";	# file also serves as timestamp
my $FileEnding = ".mm";

sub import {
  my $package = shift;
  if ( scalar @_ ) {
    $DiskCacheDir = shift;
  }
}

########################################################################

my %HaveCheckedFreshness;

# $result = disk_cache( $package, $file, $sub, @args );
sub disk_cache {  
  my ( $full_funct, $args_string, $function, @args ) = @_;
  
  unless ( $DiskCacheDir and -e $DiskCacheDir ) {
    return &$function( @args );
  }
  
  my ($package, $func_name) = ( $full_funct =~ /^(.+)::(\w+)$/ );
  
  my $pack_dir = File::Spec->catdir( $DiskCacheDir, split /::/, $package );
  if ( ! -e $pack_dir and -w $DiskCacheDir ) {
    mkpath($pack_dir, 0, 07777);
  }
  
  unless ( defined $HaveCheckedFreshness{$package} ) {
    
    my $idx = File::Spec->catfile( $pack_dir, $IndexFile );
    
    my $signature = dependency_signature($package);
    
    if ( -e $idx and read_file( $idx ) eq $signature ) {
      $HaveCheckedFreshness{$package} = 1;
    } else {
      if ( ! -w $pack_dir ) {
	# The index is out of date, but not writable -- abandon it
	$HaveCheckedFreshness{ $package } = 0;
      } else {
	rmtree($pack_dir, 0, 1);
	mkpath($pack_dir, 0, 07777);
	
	write_file( $idx, $signature );
	$HaveCheckedFreshness{$package} = 1;
      }
    }
  }
  
  unless ( $HaveCheckedFreshness{$package} ) {
    return &$function( @args );
  }
  
  my $func_dir = File::Spec->catdir( $pack_dir, $func_name );
  
  if ( ! -e $func_dir and -w $pack_dir ) {
    mkpath($func_dir, 0, 07777);
  }
  my $file = File::Spec->catfile( $func_dir, $args_string . $FileEnding );
  
  if ( -e $file ) {
    return read_file( $file );
  }
  
  my $value = ( &$function( @args ) );
  
  if ( -e $func_dir and -w $func_dir ) {
    write_file( $file, $value );
  } else {
    warn "Can't cache: $file\n";
  }
  
  return $value;
}

########################################################################

sub dependency_signature {
  my @sources = shift;
  my @results;
  no strict 'refs';
  while ( my $class = shift @sources ) {
    push @sources, @{"$class\::ISA"};
    push @results, $class unless ( grep { $_ eq $class } @results );
  }
  
  foreach ( @results ) { 
    s!::!/!g;
    $_ .= '.pm';
  }
  return join "\n", map { $_ . ' '. (stat($::INC{ $_ }))[9] } @results;
}

########################################################################

sub read_file {
  my $file = shift;
  # warn "Reading file: $file\n";
  local *FILE;
  open FILE, "$file" or die "Can't open $file: $!";
  local $/ = undef;
  return <FILE>;
}

sub write_file {
  my $file = shift;
  # warn "Writing file: $file \n";
  local *FILE;
  open FILE, ">$file" or die "Can't write to $file: $!";
  print FILE shift();
}

sub read_dir {
  my $dir = shift;
  local *DIR;
  opendir(DIR, $dir);
  readdir(DIR);
}

########################################################################

1;
