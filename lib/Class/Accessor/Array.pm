package Class::Accessor::Array;

# DATE
# VERSION

sub import {
    my ($class0, $spec) = @_;
    my $caller = caller();

    no warnings 'redefine';

    # generate accessors
    for my $meth (keys %{$spec->{accessors}}) {
        my $idx = $spec->{accessors}{$meth};
        my $code_str = 'sub (;$) { ';
        $code_str .= "\$_[0][$idx] = \$_[1] if \@_ > 1; ";
        $code_str .= "\$_[0][$idx]; ";
        $code_str .= "}";
        #say "D:accessor code for $meth: ", $code_str;
        *{"$caller\::$meth"} = eval $code_str;
        die if $@;
    }

    # generate constructor
    {
        my $code_str = 'sub { my $class = shift; bless [], $class }';

        #say "D:constructor code for class $caller: ", $code_str;
        my $constructor = $spec->{constructor} || "new";
        unless (*{"$caller\::$constructor"}{CODE}) {
            *{"$caller\::$constructor"} = eval $code_str;
            die if $@;
        };
    }
}

1;
# ABSTRACT: Generate accessors/constructor for array-based object

=for Pod::Coverage .+

=head1 SYNOPSIS

In F<lib/Your/Class.pm>:

 package Your::Class;
 use Class::Accessor::Array {
     accessors => {
         foo => 0,
         bar => 1,
     },
 };

In code that uses your class:

 use Your::Class;

 my $obj = Your::Class->new;
 $obj->foo(1980);
 $obj->bar(12);

C<$obj> is now:

 bless([1980, 12], "Your::Class");


=head1 DESCRIPTION

This module is a builder for array-backed classes.

Note that if you're looking to reduce memory storage usage, an object based on
Perl array is not that much-more-space-efficient compared to the hash-based
object. Try representing an object as a pack()-ed string instead using
L<Class::Accessor::PackedString>.


=head1 SEE ALSO

L<Class::Accessor::PackedString> and L<Class::Accessor::PackedString::Fields>.

Other class builders for array-backed objects: L<Class::XSAccessor::Array>,
L<Class::Accessor::Array::Glob>, L<Class::ArrayObjects>,
L<Object::ArrayType::New>.
