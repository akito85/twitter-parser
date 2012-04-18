#!/usr/bin/perl

use JSON;
use Encode;
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

    my ($url, $res_txt) = $line =~ /URL:(.*),RES_TXT:(.*),<EOH>/;
    my ($url, $res_txt) = ($1,$2); 

    my $obj = $json->utf8(1)->decode($res_txt); 

    if($url =~ /.*\/(.*)\.json/){
        my $event = $1;

        print CSV "$event|";

        if(ref($obj) eq "ARRAY") {

            # reminder: 1. non_entity->index 2. non_entity->user->index 
            #           3. non_entity->status->index 4. non_entity->status->place->index

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
    print CSV $_[1]->{$_[0]} . $_[2] . $_[1]->{user}->{$_[0]} . $_[2] . $_[1]->{status}->{$_[0]} . $_[2] . 
              $_[1]->{status}->{place}->{$_[0]} . $_[2] . $_[1]->{recipient}->{$_[0]} . $_[2] . $_[1]->{sender}->{$_[0]} . $_[2];
}

sub print_entity {
    print CSV $_[3]->{$_[0]} . $_[4] . $_[3]->{$_[1]} . $_[4] . $_[3]->{$_[2]} . $_[4];                              
}

exit;