#!perl -T
use Test::More ;#tests ;# => 4;

BEGIN {
    use_ok( 'String::Validator::Common' ) || print "Bail out!\n";
}
my $Validator = String::Validator::Common->new() ;
is( $Validator->isa('String::Validator::Common'), 1 ,  'New validator isa String::Validator::Common' ) ;
diag( "Testing String::Validator::Common $String::Validator::Common::VERSION, Perl $], $^X" );

my $version = $String::Validator::Common::VERSION ;
is ( $Validator->Version() , $version, 
    "We are on version $version of Common" ) ;
is ( $Validator->version(), $version, 
    'check the lowercase alias to ->version' ) ;  

package String::Validator::Common::TestClass {  
    
our $VERSION = 0.16 ;      

sub new {
    my $class = shift ;
    my $self = { @_ } ;
    use base ( 'String::Validator::Common' ) ;        
    bless $self, $class ;
    return $self ;    
    }
sub now { return localtime() }    
#sub is { my $self = shift ; return $self->isa }
sub is {  return __Package__ ; }

}


my $newclass = String::Validator::Common::TestClass->new() ;
ok( $newclass, "newclass evaluates as true" );
is( $newclass->now(), localtime() , "now method returns localtime" );

is( $newclass->isa('String::Validator::Common::TestClass'), 1 , 
    'new object isa String::Validator::Common::TestClass' ) ;

#require Exporter ;
my $Vers = $newclass->Version() ;
#my $Vers = $newclass->is() ;
note( "newclass isa: $Vers" );
note( $newclass->{ class } );
    
done_testing ;