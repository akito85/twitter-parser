#!/usr/bin/perl

use JSON;
use URI::Escape;
use Config::Tiny;

$file_log = $ARGV[0];
$file_conf = $ARGV[1];

open (FILE, $file_log) or die("Unable to open file log!! " .$file_log . "\n");
#open (CONFIG, $file_conf) or die ("Unable to open file config!! ". $file_conf . "\n");

my $Config = Config::Tiny->new();
$Config = Config::Tiny->read('twitter.conf');
$sv = $Config->{global}->{sv}; # configurable separated value

$json = new JSON;
$json = $json->allow_nonref([$enable]);
$json = $json->relaxed([$enable]);
$json = $json->max_depth([$maximum_nesting_depth]);

open (CSV, ">>text");

while (<FILE>)
{
    chomp;
    my $line = $_;
    print "Parsing line: $counter\n";
    $counter + 1;

    my ($ts, $saddr, $daddr, $sport, $dport, $fid, $mtd, $resp, $host, $uac, $url, $cookie, $req_len, $req_type, $res_len, $res_type, $res_cencode, $res_tencode, $req_txt, $res_txt) = $line =~ /TS:(.*),SADDR:(.*),DADDR:(.*),SPORT:(.*),DPORT:(.*),FID:(.*),MTD:(.*),RESP:(.*),HOST:(.*),UAC:(.*),URL:(.*),COOKIE:(.*),REQ_LEN:(.*),REQ_TYPE:(.*),RES_LEN:(.*),RES_TYPE:(.*),RES_CENCODE:(.*),RES_TENCODE:(.*),REQ_TXT:(.*),RES_TXT:(.*),<EOH>/;

    my ($ts, $saddr, $daddr, 
             $sport, $dport, 
             $fid, $mtd, $resp, $host, $uac, $url, $cookie, 
             $req_len, $req_type, 
             $res_len, $res_type, $res_cencode, $res_tencode, 
             $req_txt, $res_txt) = ($1, $2, $3, 
                                        $4, $5, 
                                        $6, $7, $8, $9, $10, $11, $12, 
                                        $13, $14, 
                                        $15, $16, $17, $18, 
                                        $19, $20); 

    my $obj = $json->utf8(1)->decode($res_txt); 

    my $encoded_url = uri_unscape($url);
    print $encoded_url . "\n\n\n\n";

    if($url =~ /.*\/(.*)\.json/){
        my $event = $1;

        print CSV "$ts $sv $event $sv";

        if(ref($obj) eq "ARRAY") {
            foreach my $non_entity(@$obj){
                my $index = 1; # config start             
                while ($Config->{twitter}->{$index})
                {
                    print_non_entity($Config->{twitter}->{$index}, $non_entity, $sv);
                    $index++;
                }
                    # entities are fix by twitter
                    foreach my $entity (@{$non_entity->{entities}->{user_mentions}})
                    {
                          print_entity('id','name','screen_name', $entity, $sv);
                    }
            }
        }
        else {
            my $index = 1; # config start
            while ($Config->{twitter}->{$index}){
                print_non_entity($Config->{twitter}->{$index}, $obj, $sv);
                $index++
            }
            # entities are fixed by twitter              
            foreach $entities ($obj->{entities}->{user_mentions})
            {
                foreach $entity(@{$entities})
                {
                    print_entity('id', 'name', 'screen_name', $entity, $sv);
                }
            }
         }
        print CSV "\n";
    }
}

close (CSV); close (FILE);

sub print_non_entity {
# reminder: 1. non_entity->index 
#           2. non_entity->user->index 
#           3. non_entity->status->index 
#           4. non_entity->status->place->index
    print CSV $_[1]->{$_[0]} . $_[2] . 
              $_[1]->{user}->{$_[0]} . $_[2] . 
              $_[1]->{status}->{$_[0]} . $_[2] . 
              $_[1]->{status}->{place}->{$_[0]} . $_[2] . 
              $_[1]->{recipient}->{$_[0]} . $_[2] . 
              $_[1]->{sender}->{$_[0]} . $_[2];
}
sub print_entity {
    print CSV $_[3]->{$_[0]} . $_[4] . 
              $_[3]->{$_[1]} . $_[4] . 
              $_[3]->{$_[2]} . $_[4];                              
}

exit;