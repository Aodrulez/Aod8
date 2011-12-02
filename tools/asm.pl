# Assembler for Aod8 Virtual Processor.
# (c) Aodrulez.
#
# Usage:
# ------
# perl asm.pl asm-code-file output-bootrom-file
#
# Ex.
# ---
# perl asm.pl test.asm bootrom
#########################################


print "\n   +------------------+";
print "\n   |  Aod8 Assembler  |";
print "\n   +------------------+";
print "\n   (c) Aodrulez.\n";
print "\n\nVersion 1.0";
print "\n-----------";
if(!$ARGV[0] or !$ARGV[1]){
print "\n[!] Specify the assembly & output files!\n";exit;}
open (F, $ARGV[0]) || die "[!] Could not open : $!\n";
@test = <F>;
close F;

#Info
my $loc=scalar(@test);
my $output=$ARGV[1];
my $x=0;
my @labels;
my $count=0;
my $ip=0;


print "\n[*] Input Filename  : $ARGV[0]";
print "\n[*] Output Filename : $output";
print "\n[*] Lines of Code   : $loc";

open(OUT, "> $output");
binmode(OUT);

#pass1 --> find all labels.
#print "\n\npass-0 :\n------\n";
#print @test;
print "\n[+] First Pass : Finding labels.";

while($x<=$loc)
{
my $line=@test[$x];
chomp($line);
if($line=~/^#/){$x++;next;}
if($line=~/:/i ){
my @array=split(":",$line);
@labels[$count]="@array[0]:$ip";
@test[$x]="nop\n";
$count++;
++$ip;}
if($line=~m/mov\sa,\[sp\]/i){++$ip;}	# mov a,[sp]
if($line=~m/mov\sb,\[sp\]/i){++$ip;}	# mov b,[sp]
if($line=~m/mov\sa,b/i){++$ip;}		# mov a,b
if($line=~m/mov\sb,a/i){++$ip;}		# mov b,a
if($line=~m/mov\s\[sp\],a/i){++$ip;}	# mov [sp],a
if($line=~m/mov\s\[sp\],b/i){++$ip;}	# mov [sp],b
if($line=~m/mov\ssp,a/i){++$ip;}	# mov sp,a
if($line=~m/mov\ssp,b/i){++$ip;}	# mov sp,b
if($line=~m/mov\sa,sp/i){++$ip;}	# mov a,sp
if($line=~m/mov\ssp,[0-9]/){++$ip;++$ip;}	# mov sp,x
if($line=~m/mov\sa,[0-9]/){++$ip;++$ip;}	# mov a,x
if($line=~m/mov\sb,[0-9]/){++$ip;++$ip;}	# mov b,x
#ADDITION
if($line=~m/add\sa,[0-9]/){++$ip;++$ip;}	# ADD A,x
if($line=~m/add\sa,b/i){++$ip;}		# add a,b
if($line=~m/add\sb,[0-9]/){++$ip;++$ip;}	# ADD b,x
if($line=~m/add\sb,a/i){++$ip;}		# add B,A
#SUBSTRACTION
if($line=~m/sub\sa,[0-9]/){++$ip;++$ip;}	# sub A,x
if($line=~m/sub\sa,b/i){++$ip;}		# sub a,b
if($line=~m/sub\sb,[0-9]/){++$ip;++$ip;}	# sub b,x
if($line=~m/sub\sb,a/i){++$ip;}		# sub B,A
#comparison
if($line=~m/cmp\sa,b/i){++$ip;}		# cmp a,b
if($line=~m/cmp\sa,[0-9]/){++$ip;++$ip;}	# cmp a,x
if($line=~m/cmp\sb,[0-9]/){++$ip;++$ip;}	# cmp b,x
#jump
if($line=~m/jmp\sa/i){++$ip;}		# jmp a
if($line=~m/jmp\sb/i){++$ip;}		# jmp b
if($line=~m/jmp\s[0-9]/){++$ip;++$ip;}	# jmp x
if($line=~m/jmp\s[a-z]/){++$ip;++$ip;}	# jmp label
#jne
if($line=~m/jne\sa/i){++$ip;}		# jne a
if($line=~m/jne\sb/i){++$ip;}		# jne b
if($line=~m/jne\s[0-9]/){++$ip;++$ip;}	# jne x
if($line=~m/jne\s[a-z]/){++$ip;++$ip;}	# jne label
#je
if($line=~m/je\sa/i){++$ip;}		# je a
if($line=~m/je\sb/i){++$ip;}		# je b
if($line=~m/je\s[0-9]/){++$ip;++$ip;}	# je x
if($line=~m/je\s[a-z]/){++$ip;++$ip;}	# je label
#jge
if($line=~m/jge\sa/i){++$ip;}		# jge a
if($line=~m/jge\sb/i){++$ip;}		# jge b
if($line=~m/jge\s[0-9]/){++$ip;++$ip;}	# jge x
if($line=~m/jge\s[a-z]/){++$ip;++$ip;}	# jge label
#jle
if($line=~m/jle\sa/i){++$ip;}		# jle a
if($line=~m/jle\sb/i){++$ip;}		# jle b
if($line=~m/jle\s[0-9]/){++$ip;++$ip;}	# jle x
if($line=~m/jle\s[a-z]/){++$ip;++$ip;}	# jle label
#inc
if($line=~m/inc\sa/i){++$ip;}		# inc a
if($line=~m/inc\sb/i){++$ip;}		# inc b
if($line=~m/inc\ssp/i){++$ip;}		# inc sp
#miscellaneous
if($line=~m/input/i){++$ip;}		# Input
if($line=~m/output/i){++$ip;}		# output 
if($line=~m/nop/i){++$ip;}		# NOP
if($line=~m/halt/i){++$ip;}		# HALT
if($line=~m/loop\s/i){++$ip;++$ip;}	# Loop x
if($line=~m/sleep\s[0-9]/i){++$ip;++$ip;}	# Sleep x
$x++;
}

print "\n[+] Second Pass : Fixing label addresses.";
$x=0;
$count=0;
$ip=0;
$labelnum=scalar(@labels);
while($x<=$loc)
{
my $line=@test[$x];
chomp($line);
if($line=~/^#/){$x++;next;}
if($line=~m/loop\s[a-z]/i){
my @array=split(" ",$line);
my $f;
	for($f=0;$f<$labelnum;$f++)
	{
	if(@labels[$f]=~/@array[1]/){ 
					my @phew=split(":",@labels[$f]);
						@phew[1]=$ip-@phew[1];
					 @test[$x]=~s/@array[1]/@phew[1]/g;
				    }
	}
++$ip;
++$ip;
}
if($line=~m/j..\s[a-z][a-z]/i){
my @array=split(" ",$line);
my $f;
	for($f=0;$f<$labelnum;$f++)
	{
	if(@labels[$f]=~/@array[1]/){ 
					my @phew=split(":",@labels[$f]);
					@phew[1]=@phew[1]-$ip;
					@test[$x]=~s/@array[1]/@phew[1]/g;
				    }
	}
++$ip;
++$ip;
}
if($line=~m/j.\s[a-z][a-z]/i){
my @array=split(" ",$line);
my $f;
	for($f=0;$f<$labelnum;$f++)
	{
	if(@labels[$f]=~/@array[1]/){ 
					my @phew=split(":",@labels[$f]);
					@phew[1]=@phew[1]-$ip;
					 @test[$x]=~s/@array[1]/@phew[1]/g;
				    }
	}
++$ip;
++$ip;
}
if($line=~m/mov\sa,\[sp\]/i){++$ip;}	# mov a,[sp]
if($line=~m/mov\sb,\[sp\]/i){++$ip;}	# mov b,[sp]
if($line=~m/mov\sa,b/i){++$ip;}		# mov a,b
if($line=~m/mov\sb,a/i){++$ip;}		# mov b,a
if($line=~m/mov\s\[sp\],a/i){++$ip;}	# mov [sp],a
if($line=~m/mov\s\[sp\],b/i){++$ip;}	# mov [sp],b
if($line=~m/mov\ssp,a/i){++$ip;}	# mov sp,a
if($line=~m/mov\ssp,b/i){++$ip;}	# mov sp,b
if($line=~m/mov\sa,sp/i){++$ip;}	# mov a,sp
if($line=~m/mov\ssp,[0-9]/){++$ip;++$ip;}	# mov sp,x
if($line=~m/mov\sa,[0-9]/){++$ip;++$ip;}	# mov a,x
if($line=~m/mov\sb,[0-9]/){++$ip;++$ip;}	# mov b,x
#ADDITION
if($line=~m/add\sa,[0-9]/){++$ip;++$ip;}	# ADD A,x
if($line=~m/add\sa,b/i){++$ip;}		# add a,b
if($line=~m/add\sb,[0-9]/){++$ip;++$ip;}	# ADD b,x
if($line=~m/add\sb,a/i){++$ip;}		# add B,A
#SUBSTRACTION
if($line=~m/sub\sa,[0-9]/){++$ip;++$ip;}	# sub A,x
if($line=~m/sub\sa,b/i){++$ip;}		# sub a,b
if($line=~m/sub\sb,[0-9]/){++$ip;++$ip;}	# sub b,x
if($line=~m/sub\sb,a/i){++$ip;}		# sub B,A
#comparison
if($line=~m/cmp\sa,b/i){++$ip;}		# cmp a,b
if($line=~m/cmp\sa,[0-9]/){++$ip;++$ip;}	# cmp a,x
if($line=~m/cmp\sb,[0-9]/){++$ip;++$ip;}	# cmp b,x
#jump
if($line=~m/jmp\sa/i){++$ip;}		# jmp a
if($line=~m/jmp\sb/i){++$ip;}		# jmp b
if($line=~m/jmp\s[0-9]/){++$ip;++$ip;}	# jmp x
#jne
if($line=~m/jne\sa/i){++$ip;}		# jne a
if($line=~m/jne\sb/i){++$ip;}		# jne b
if($line=~m/jne\s[0-9]/){++$ip;++$ip;}	# jne x
#je
if($line=~m/je\sa/i){++$ip;}		# je a
if($line=~m/je\sb/i){++$ip;}		# je b
if($line=~m/je\s[0-9]/){++$ip;++$ip;}	# je x
#jge
if($line=~m/jge\sa/i){++$ip;}		# jge a
if($line=~m/jge\sb/i){++$ip;}		# jge b
if($line=~m/jge\s[0-9]/){++$ip;++$ip;}	# jge x
#jle
if($line=~m/jle\sa/i){++$ip;}		# jle a
if($line=~m/jle\sb/i){++$ip;}		# jle b
if($line=~m/jle\s[0-9]/){++$ip;++$ip;}	# jle x
#inc
if($line=~m/inc\sa/i){++$ip;}		# inc a
if($line=~m/inc\sb/i){++$ip;}		# inc b
if($line=~m/inc\ssp/i){++$ip;}		# inc sp
#miscellaneous
if($line=~m/input/i){++$ip;}		# Input
if($line=~m/output/i){++$ip;}		# output 
if($line=~m/nop/i){++$ip;}		# NOP
if($line=~m/halt/i){++$ip;}		# HALT
if($line=~m/loop\s[0-9]/i){++$ip;++$ip;}	# Loop x
if($line=~m/sleep\s[0-9]/i){++$ip;++$ip;}	# Sleep x
$x++;
}

print "\n[+] Third Pass : Compiling.";
$x=0;
$count=0;
$ip=0;
while($x<=$loc)
{
my $line=@test[$x];
chomp($line);
if($line=~/^#/){$x++;next;}
if($line=~m/mov\sa,\[sp\]/i){printf (OUT "%c",0x11);}	# mov a,[sp]
if($line=~m/mov\sb,\[sp\]/i){printf (OUT "%c",0x12);}	# mov b,[sp]
if($line=~m/mov\sa,b/i){printf (OUT "%c",0x13);}	# mov a,b
if($line=~m/mov\sb,a/i){printf (OUT "%c",0x14);}	# mov b,a
if($line=~m/mov\s\[sp\],a/i){printf (OUT "%c",0x15);}	# mov [sp],a
if($line=~m/mov\s\[sp\],b/i){printf (OUT "%c",0x16);}	# mov [sp],b
if($line=~m/mov\ssp,a/i){printf (OUT "%c",0x17);}	# mov sp,a
if($line=~m/mov\ssp,b/i){printf (OUT "%c",0x18);}	# mov sp,b
if($line=~m/mov\sa,sp/i){printf (OUT "%c",0x19);}	# mov a,sp
if($line=~m/mov\ssp,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x19,@array[1];}		# mov sp,x
if($line=~m/mov\sa,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x1A,@array[1];}		# mov a,x
if($line=~m/mov\sb,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x1B,@array[1];}		# mov b,x
#ADDITION
if($line=~m/add\sa,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x1C,@array[1];}		# ADD A,x
if($line=~m/add\sa,b/i){printf (OUT "%c",0x1D);}	# add a,b
if($line=~m/add\sb,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x1E,@array[1];}		# ADD b,x
if($line=~m/add\sb,a/i){printf (OUT "%c",0x1F);}	# add B,A
#SUBSTRACTION
if($line=~m/sub\sa,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x20,@array[1];}		# sub A,x
if($line=~m/sub\sa,b/i){printf (OUT "%c",0x21);}	# sub a,b
if($line=~m/sub\sb,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x22,@array[1];}		# sub b,x
if($line=~m/sub\sb,a/i){printf (OUT "%c",0x23);}	# sub B,A
#comparison
if($line=~m/cmp\sa,b/i){printf (OUT "%c",0x24);}	# cmp a,b
if($line=~m/cmp\sa,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x25,@array[1];}		# cmp a,x
if($line=~m/cmp\sb,[0-9]/)
	{
	my @array = split(",", $line);
	printf OUT "%c%c",0x26,@array[1];}		# cmp b,x
#jump
if($line=~m/jmp\sa/i){printf (OUT "%c",0x27);}		# jmp a
if($line=~m/jmp\sb/i){printf (OUT "%c",0x28);}		# jmp b
if($line=~m/jmp\s[0-9]/)
	{
	my @array = split(" ", $line);
	printf OUT "%c%c",0x29,@array[1];}		# jmp x
#jne
if($line=~m/jne\sa/i){printf (OUT "%c",0x2A);}		# jne a
if($line=~m/jne\sb/i){printf (OUT "%c",0x2B);}		# jne b
if($line=~m/jne\s[0-9]/)
	{
	my @array = split(" ", $line);
	printf OUT "%c%c",0x2C,@array[1];}		# jne x
#je
if($line=~m/je\sa/i){printf (OUT "%c",0x2D);}		# je a
if($line=~m/je\sb/i){printf (OUT "%c",0x2E);}		# je b
if($line=~m/je\s[0-9]/)
	{
	my @array = split(' ', $line);
	printf OUT "%c%c",0x2F,@array[1];}		# je x
#jge
if($line=~m/jge\sa/i){printf (OUT "%c",0x30);}		# jge a
if($line=~m/jge\sb/i){printf (OUT "%c",0x31);}		# jge b
if($line=~m/jge\s[0-9]/)
	{
	my @array = split(" ", $line);
	printf OUT "%c%c",0x32,@array[1];}		# jge x
#jle
if($line=~m/jle\sa/i){printf (OUT "%c",0x33);}		# jle a
if($line=~m/jle\sb/i){printf (OUT "%c",0x34);}		# jle b
if($line=~m/jle\s[0-9]/)
	{
	my @array = split(" ", $line);
	printf OUT "%c%c",0x35,@array[1];}		# jle x
#inc
if($line=~m/inc\sa/i){printf (OUT "%c",0x36);}		# inc a
if($line=~m/inc\sb/i){printf (OUT "%c",0x37);}		# inc b
if($line=~m/inc\ssp/i){printf (OUT "%c",0x38);}		# inc sp
#miscellaneous
if($line=~m/input/i){printf (OUT "%c",0x39);}		# Input
if($line=~m/output/i){printf (OUT "%c",0x3A);}		# output 
if($line=~m/NOP/i){printf (OUT "%c",0x3B);}		# NOP
if($line=~m/halt/i){printf (OUT "%c",0x3C);}		# HALT
if($line=~m/loop\s[0-9]/i){
	my @array = split(" ", $line);
	printf OUT "%c%c",0x3D,@array[1];}		# Loop x
if($line=~m/sleep\s[0-9]/i){
	my @array = split(" ", $line);
	printf OUT "%c%c",0x3E,@array[1];}		# Sleep x
$x++;
}
close(OUT);
print"\n[!] Done.\n";

