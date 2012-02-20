package String::Validator::Common;

use 5.006;
use strict;
use warnings;

=pod

=head1 NAME

String::Validator::Common - Routines shared by String::Validator Modules.

=head1 VERSION

Version 0.93

=cut

our $VERSION = '0.93';

sub new {
    my $class = shift ;
    my $self = { @_ } ;
    bless $self , $class;
    $self->_Init() ;
    return $self ;
}

sub IncreaseErr {
      my $self = shift ;
      $self->{ errstring } .= "@_\n" ;
      $self->{ error }++ ;
      } ;

# Every time we get a new request
# these values need to be reset from the
# previous request.
sub _Init  {
    my $self = shift ;
    $self->{errstring} = '';
    $self->{error} = 0;
    $self->{string} = '' ;
    } ;

sub Start {
    my ( $self, $string1, $string2 ) = @_ ;
    $self->_Init() ;
# String comparison, must not fail if no string2 is provided.
# string2 is also available for destructive operations.
# Failing the string match alse necessitates immediate
# error return as the other tests are meaningless as
# we cannot know if either or neither string is the password.
    if ( 0 == length $string2 ) {  }
    elsif ( $string1  ne $string2 ) {
		$self->IncreaseErr( 'Strings don\'t match.' ) ;
		return 1 ;
	}
    $self->{string} = $string1 ;
    return 0 ;
    }

sub Length {
    my $self = shift ;
    my $string = $self->{ string } ;
    if ( length( $self->{ string } ) < $self->{min_len} ) {
		$self->IncreaseErr( "Length of " . length( $self->{ string } ) .
		" Does not meet requirement: Min Length " . $self->{min_len} . "." ) ;
		return $self->{ error } ;
		}
    if ( $self->{max_len} ) {
            if ( length( $self->{ string } ) > $self->{max_len} ) {
		$self->IncreaseErr( "Length of " . length( $self->{ string } ) .
		" Does not meet requirement: Max Length " . $self->{max_len} . "." ) ;
		return $self->{ error } ;
	}       }
    return 0 ;
}

sub CheckCommon {
    my ( $self, $string1, $string2 ) = @_ ;
    if ( $self->Start( $string1, $string2 ) ) {
		return $self->{ error } }
    if ( $self->Length ) { return $self->{ error } }
    return 0;
}

# Check serves as example, but more importantly lets
# us test the module.
# Takes 2 strings and runs Start.
# If the strings match it returns 0, else 1.
sub Check {
    my ( $self, $string1, $string2 ) = @_ ;
    my $started = $self->Start( $string1, $string2 ) ;
    return $self->{ error } ;
    }

sub Errcnt  {
	my $self = shift ;
	return $self->{ error }
	}

sub Errstr  {
	my $self = shift ;
	return $self->{ errstring }
	}

sub IsNot_Valid {
	( my $self, my $string1, my $string2 ) = @_ ;
	if ( $self->Check( $string1, $string2 )) { return $self->{ errstring } }
	else { return 0 }
	}

sub Is_Valid{
	( my $self, my $string1, my $string2 ) = @_ ;
	if ( $self->Check( $string1, $string2 )) { return 0 }
	else { return 1 }
	}

sub String {
	my $self = shift ;
	return $self->{ string } ;
	}

=pod

=head1 SYNOPSIS

There are some methods common to all String::Validator Modules. By starting
with this module other String::Validator Modules inherit these methods.

=head1 String::Validator::Common Methods and Usage

Modules Using String Validator Common use its' new method and then extend the
attributes in their own new methods.

 use String::Validator::Common;
 sub new {
 my $class = shift ;
 my $self = { @_ } ;
 use base ( 'String::Validator::Common' ) ;
 unless ( defined $self->{ some_param } )
   { $self->{ some_param } = 'somedefault'; }
 ...
 bless $self , $class ;
 return $self ;
 }

=head1 Methods String::Validator::Common provides

=head2 IncreaseErr

A String::Validator contains two error variables error and errstring. When an
error is found, simply pass a brief description to this method to increment
the errorcount, and append the present description to the errstring.

 if ( 1 != 2 ) { $self->IncreaseErr( qq /1 Still Doesn't equal 2!/ ) }

=head2 Start

This method initializes three key values: $self->{errstring} ,
$self->{error}, and $self->{string} to NULL, 0, NULL. If no errors are found
error and errstring will remain 0 and NULL. string will be used to hold
the string being evaluated. Arguments are the
string to be evaluated and optionally a second string to be compared with the
first. If the strings are mismatched the sub will return 1, and string will
remain NULL, the inheriting module should immediately return the error and
not contine.

=head2 Length

Checks $self->{ string } against $self->{ min_length } and $self->{ max_length }
If the length checks pass it returns 0, if one fails it immediately returns
the incremented value of error.

=head2 CheckCommon

CheckCommon is just a shortcut to run Start and Length.

=head2 Check

A stub for testing, overridden in actual string validator classes.



=head1 AUTHOR

John Karr, C<< <brainbuz at brainbuz.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-string-validator-email at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=String-Validator-Email>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc String::Validator::Email


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=String-Validator-Email>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/String-Validator-Email>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/String-Validator-Email>

=item * Search CPAN

L<http://search.cpan.org/dist/String-Validator-Email/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 John Karr.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 3 or at your option
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

A copy of the GNU General Public License is available in the source tree;
if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.


=cut

1; # End of String::Validator::Common
