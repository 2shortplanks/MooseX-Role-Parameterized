#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 5;
use Test::Exception;

my ($parameters, %args);

do {
    package MyPerson;
    use MooseX::Role::Parameterized;

    parameter default_age => (
        is       => 'rw',
        isa      => 'Int',
        required => 1,
    );

    role {
        ($parameters, %args) = @_;

        has age => (
            is      => 'ro',
            default => $parameters->default_age,
        );
    };
};

ok(MyPerson->meta->has_role_generator, "MyPerson has a role generator");

my $role = MyPerson->meta->generate_role(
    default_age => 7,
);

isa_ok($role, 'Moose::Meta::Role', 'generate_role created a role');

is($parameters->default_age, 7);
is($args{operating_on}, $role, "we pass in the role metaclass that we're operating on");

my $age_attr = $role->get_attribute('age');
is($age_attr->{default}, 7, "role's age attribute has the right default");
