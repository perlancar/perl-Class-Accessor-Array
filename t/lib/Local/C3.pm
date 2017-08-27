package # hide from PAUSE
    Local::C3;

our @ISA = qw(Local::C1);

use Class::Accessor::Array {
    accessors => {
        baz => 2,
    },
};

1;
