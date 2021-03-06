#!/usr/bin/perl
use Getopt::Long;

GetOptions (\%opt,"ortholog:s","inf1:s","inf2:s","project:s","help");


my $help=<<USAGE;
Bar plot of Expression level comparison between ortholog genes based on different categray TE+-/Me+-.
perl $0 --orth ../input/OB-OS.orth --inf1 ./Distance2Expression/0.1/1k/OBa_Me.gene.closestTE.inf --inf2 ./Distance2Expression/0.1/1k/rice_Me.gene.closestTE.inf --project orth_OBa_rice > log 2> log2 &
--ortholog: ortholog table, the species cresponding to inf1 should be in the first colume
--inf1: gene information table with gene name, RPKM, closest TE distance, TE ID, TE methylation status, which generated by Distance2RPKM.pl
Gene    RPKM    Repeat  Distance        Methylation
--inf2: same with inf1, the other species.
--project: 
USAGE


if ($opt{help} or keys %opt < 1){
    print "$help\n";
    exit();
}

my $methylevel=0.1; ### methylation cutoff
my $TEdist=200; ### closest TE cutoff
my $refinf1=geneinf($opt{inf1});
my $refinf2=geneinf($opt{inf2});

& orthcompare($opt{ortholog},$refinf1,$refinf2,$methylevel,$TEdist);

sub orthcompare
{
my ($orth,$refinf1,$refinf2,$methylevel,$TEdist)=@_;
my %hash;
my %ort;
open IN, "$orth" or die "$!";
while(<IN>){
   chomp $_;
   my @unit=split("\t",$_);
   if (exists $refinf1->{$unit[0]} and exists $refinf2->{$unit[1]}){
       my $diff=$refinf1->{$unit[0]}->[0]-$refinf2->{$unit[1]}->[0];
       my $tmp1="$refinf1->{$unit[0]}->[0]\t$refinf1->{$unit[0]}->[1]\t$refinf1->{$unit[0]}->[2]\t$refinf1->{$unit[0]}->[3]";
       my $tmp2="$refinf2->{$unit[1]}->[0]\t$refinf2->{$unit[1]}->[1]\t$refinf2->{$unit[1]}->[2]\t$refinf2->{$unit[1]}->[3]";
       my $ort="$unit[0]\t$tmp1\t$unit[1]\t$tmp2";
       if ($refinf1->{$unit[0]}->[2] <= $TEdist and $refinf1->{$unit[0]}->[2] > 0){
           if ($refinf2->{$unit[1]}->[2] <= $TEdist and $refinf2->{$unit[1]}->[2] > 0){
               push (@{$hash{1}},$diff); 
               push (@{$ort{1}},$ort);
           }else{
               if ($refinf1->{$unit[0]}->[3] >= $methylevel){
                   push (@{$hash{3}},$diff);
                   push (@{$ort{3}},$ort);
               }else{
                   push (@{$hash{2}},$diff);
                   push (@{$ort{2}},$ort);
               }
           }
       }else{
           if ($refinf2->{$unit[1]}->[2] > $TEdist){
               push (@{$hash{0}},$diff);
               push (@{$ort{0}},$ort);
           }else{
               if ($refinf2->{$unit[1]}->[3] >= $methylevel){
                   push (@{$hash{5}},$diff);
                   push (@{$ort{5}},$ort);
               }else{
                   push (@{$hash{4}},$diff);
                   push (@{$ort{4}},$ort);
               }
           }
       }
       #TE in gene intron/exon
       #if ($refinf1->{$unit[0]}->[2] == 0 and $refinf2->{$unit[1]}->[2] == 0){
       #    push (@{$hash{6}},$diff);
       #}
   }
}
close IN;

my %class=(
   "0" => "TE-\|TE-",
   "1" => "TE+\|TE+",
   "2" => "mC-\|TE-",
   "3" => "mC+\|TE-",
   "4" => "TE-\|mC-",
   "5" => "TE-\|mC+"
   #"6" => "TE0\|TE0"
);

open INF, ">$opt{project}.ortholog.inf" or die "$!";
open OUT, ">$opt{project}.4r" or die "$!";
foreach(sort {$a <=> $b} keys %hash){
    print "$_\t$class{$_}\n";
    my $id=$_;
    foreach(@{$ort{$id}}){
         print INF "$class{$id}\t$_\n";
    }
    my ($mean,$se,$number)=ci($hash{$id},$id);
    my $cilow=$mean-$se;
    my $cihigh=$mean+$se;
    print OUT "$mean\t$cilow\t$cihigh\t$class{$id}\t$number\n";
}
close OUT;
close INF;

open OUT, ">$opt{project}.r" or die "$!";
print OUT <<"END.";
read.table("$opt{project}.4r") -> x
pdf("$opt{project}.pdf")
library("gplots")
barplot2(x[,1],plot.ci=TRUE,ci.l=x[,2],ci.u=x[,3],names.arg=x[,4],ylab="Normalized expression difference")
abline(h=0)
dev.off()
END.
close OUT;

system ("cat $opt{project}.r | R --vanilla --slave");
} ### end of sub orthcompare 

#############################################

sub ci
{
my ($num,$order)=@_;
my $loop=0;
my $total;
my $add_square;
open OUT1, ">$opt{project}.$order.4r" or die "$!";
foreach  (@$num) {
        next if ($_ eq "NA");
        #my $temp=log($_);
        #print "$_\t$temp\n";
        print OUT1 "$_\n";
        my $temp=$_;
        $total+=$temp;
        $add_square+=$temp*$temp;
        $loop++;
}
close OUT1;
=pod
open OUT1, ">$opt{project}.$order.r" or die "$!";
print OUT1 <<"END.";
read.table("$opt{project}.$order.4r") -> x
pdf("$opt{project}.$order.pdf")
plot(density(x[,1]),xlim=c(0,20));
dev.off()
END.
close OUT1;
system ("cat $opt{project}.$order.r | R --vanilla --slave");
=cut

my $number=$loop;
my $mean=$total/$number;
my $SD=sqrt( ($add_square-$total*$total/$number)/ ($number-1) );
my $se=1.96*$SD/sqrt($number);
return ($mean,$se,$number);
}

sub log2 {
    my ($n) = shift;
    return log($n)/log(2);
}



sub geneinf
{
###Gene    RPKM    Repeat  Distance        Methylation
my ($inf)=@_;
my %hash;
open IN, "$inf" or die "$!";
<IN>;
while(<IN>){
    chomp $_;
    my @unit=split("\t",$_);
    next if ($unit[1] eq "NA" or $unit[4] eq "NA");
    $hash{$unit[0]}=[$unit[1],$unit[2],$unit[3],$unit[4]];
}
close IN;
return \%hash;
}
