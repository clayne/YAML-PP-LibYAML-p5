# ABSTRACT: Parser for YAML::PP::LibYAML
package YAML::PP::LibYAML::Parser;
use strict;
use warnings;

our $VERSION = '0.000'; # VERSION

use YAML::LibYAML::API::XS;
use YAML::PP::Reader;
use base 'YAML::PP::Parser';

sub new {
    my ($class, %args) = @_;
    my $reader = delete $args{reader} || YAML::PP::Reader->new;
    my $receiver = delete $args{receiver};

    my $self = bless {
        reader => $reader,
    }, $class;
    if ($receiver) {
        $self->set_receiver($receiver);
    }
    return $self;
}

sub reader { return $_[0]->{reader} }
sub set_reader {
    my ($self, $reader) = @_;
    $self->{reader} = $reader;
}

sub parse {
    my ($self) = @_;
    my $reader = $self->reader;
    # TODO let XS read file/filehandle directly
    my $yaml = $reader->read;
    my $events = [];
    my $test = YAML::LibYAML::API::XS::parse_string_events($yaml, $events);
    for my $info (@$events) {
        my $name = $info->{name};
        $self->callback->( $self, $name => $info );
    }
}


1;

__END__

=pod

=head1 NAME

YAML::PP::LibYAML::Parser - Parser for YAML::PP::LibYAML

=head1 DESCRIPTION

L<YAML::PP::LibYAML::Parser> is a subclass of L<YAML::PP::Parser>.

=cut
