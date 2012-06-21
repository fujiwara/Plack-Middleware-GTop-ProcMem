package Plack::Middleware::GTop::ProcMem;
use strict;
use warnings;

use parent qw/ Plack::Middleware /;
use Plack::Util::Accessor qw/ callback /;
use GTop;

our $VERSION = '0.01';
our $GTop    = GTop->new;

sub call {
    my($self, $env) = @_;

    my $before = $GTop->proc_mem($$);
    my $res    = $self->app->($env);
    my $after  = $GTop->proc_mem($$);

    $self->response_cb($res, sub {
        my $res = shift;
        $self->callback->( $env, $res, $before, $after )
            if $self->callback;
    });
}

1;
__END__

=head1 NAME

Plack::Middleware::GTop::ProcMem - for measuring process memory

=head1 SYNOPSIS

  use Plack::Builder;
  builder {
      enable 'GTop::Mem', callback => sub {
          my ($env, $res, $before, $after) = @_;
          # $before, $after isa GTop::ProcMem
          my $diff = $after->rss - $before->rss;
          warn sprintf("%s RSS diff %d\n", $env->{REQUEST_URI}, $diff);
      };
      $app;
  };

=head1 DESCRIPTION

Plack::Middleware::GTop::ProcMem is middleware for measuring process memory.

=head1 CONFIGURATION

=over 4

=item callback

callback subref will be called after process app.

  callback => sub {
      my ($env, $res, $before, $after) = @_;
      ...
  };

First argument is Plack env.
Second argument is Plack response.
Third argument is a GTop::ProcMem object at before process app.
Fourth argument is a GTop::ProcMem object at after process app.

=back

=head1 AUTHOR

FUJIWARA Shunichiro E<lt>fujiwara@cpan.orgE<gt>

=head1 SEE ALSO

L<GTop> L<Plack::Middleware>

=head1 REPOSITORY

https://github.com/fujiwara/Plack-Middleware-GTop-ProcMem

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
