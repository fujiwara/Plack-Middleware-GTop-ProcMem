use strict;
use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;

my $app = builder {
    enable "GTop::ProcMem", callback => sub {
        my ($env, $res, $before, $after) = @_;
        my $diff = $after->rss - $before->rss;
        Plack::Util::header_set($res->[1], 'X-RSS-Diff', $diff);
    };
    sub {
        my $env = shift;
        [ 200, [ 'Content-Type', 'text/plain'], ["ok"] ];
    };
};
test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET "/");
    is $res->content, "ok";
    like $res->header("X-RSS-Diff"), qr/^\d+$/;
};

done_testing;
