#! /usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;

my $help;
my ($sam_file,$gff_file);

my $script=substr($0, 1+rindex($0,'/'));
my $usage="Usage:\n
  $script -sam xxx.sam -gff xxx.gff >out.xls\n\n";

die $usage unless
  &GetOptions( 'sam:s'   => \$sam_file,
               'gff:s'     => \$gff_file,
               'h|help'   => \$help
         ) && !$help && $sam_file && $gff_file;

#perl sam2rpkm.pl xxx.sam xxx.gff

#my $sam_file = shift;
#my $gff_file = shift;

my %hash;
my %frags_pos;
my %reads_pos;

my($total_reads,$mapped_reads,$total_unmapped_reads);
my($single_mapped_reads,$single_unmapped_reads,$pair_mapped_reads,$pair_unmapped_reads,$fragments_mapped);

my $last = "";

open(SAM,"<$sam_file") or die $!;
while(<SAM>){
    chomp;
    unless(/^\@/){
        $total_reads ++;
        my @t = split(/\t/,$_);
        if($t[2] ne "*"){
            if($t[3] == $t[7]){
                if($t[5] ne "*"){
                    $single_mapped_reads ++;
                    $fragments_mapped ++;
                    $reads_pos{$t[3]}++;
                    $frags_pos{$t[3]}++;
                }else{
                    $single_unmapped_reads ++;
                }
            }else{
                $pair_mapped_reads ++;
                $reads_pos{$t[3]} ++;
                if($t[0] eq $last){
                    $frags_pos{$t[3]} ++;
                    $fragments_mapped ++;
                }
                $last = $t[0];
            }
        }else{
            $pair_unmapped_reads ++;
            $last = $t[0];
        }

    }
}
close SAM;

print STDERR "\n";
print STDERR "Total Reads:\t\t$total_reads\n";
print STDERR "Pair unmapped Reads:\t\t$pair_unmapped_reads\n";
print STDERR "Single unmapped Reads:\t\t$single_unmapped_reads\n";
print STDERR "Single mapped Reads:\t\t$single_mapped_reads\n";
print STDERR "Pair mapped Reads:\t\t$pair_mapped_reads\n";
print STDERR "Mapped fragments:\t\t$fragments_mapped\n";

print "start\tend\tmapped_reads\tmapped_fragments\tRPKM\tFPKM\n";

open(GFF,"<$gff_file") or die $!;
while(<GFF>){
    chomp;
    my @t = split(/\t/, $_);
    my $m_reads = 0;
    my $m_frags = 0;

    for(my $i =$t[2];$i<=$t[3];$i++){
        if(exists $reads_pos{$i}){
            $m_reads += $reads_pos{$i};
        }
        if(exists $frags_pos{$i}){
            $m_frags += $frags_pos{$i};
        }
    }

    # RPKM = [# of mapped reads]/([length of transcript]/1000)/([total reads]/10^6)
    # FPKM = [# of fragments]/([length of transcript]/1000)/([total reads]/10^6)
    my $rpkm = $m_reads/($t[3]-$t[2]+1)/$total_reads/1000000;
    my $fpkm = $m_frags/($t[3]-$t[2]+1)/$total_reads/1000000;

    print "$t[2]\t$t[3]\t$m_reads\t$m_frags\t$rpkm\t$fpkm\n";
}
close GFF;
