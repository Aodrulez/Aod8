#!/usr/bin/perl

use Switch;

my $IP=0;
my $FLAG=0;
my $SP=0;
my $A=0;
my $B=0;
my @stack=(0);
my $opcode=0;
$| = 1; # Disable output buffering. Comment it out
        # if the output is too slow.



print "\n   +--------------------------+";
print "\n   |  Aod8 Virtual Processor  |";
print "\n   +--------------------------+\n";
print "   (c) Aodrulez.\n";
print "\n[+] Reading bootrom.";

#read the bootrom
#----------------
open(BOOTROM, "<bootrom.txt"); # open for input
binmode(BOOTROM);
my (@ROM, $data);
while ((read BOOTROM, $data, 1) != 0) {
  @ROM[$IP] = $data;
  $IP++;
}
close(BOOTROM);

print "\n[+] Size of Bootrom : ".($IP)." bytes.";
print "\n[!] Registers initialised to 0.";
print "\n[!] Booting using the Boot-Rom.";
print "\n-------------------------------\n\n";
$IP=0;
#----------------



while($IP>=0 && $opcode!= 0x3C)
{
$opcode=ord(@ROM[$IP]);
#print "\nIP=".$IP." A=".$A." B=".$B." SP=".$SP." FLAG=".$FLAG." [SP]=".$stack[$SP];
	switch($opcode) {
  		
		
		case 0x11 { $A=(@stack[$SP]);$IP++;}
		case 0x12 { $B=(@stack[$SP]);$IP++;}
		case 0x13 { $A=$B;$IP++;}
		case 0x14 { $B=$A;$IP++;}
		case 0x15 { @stack[$SP]=($A);$IP++;}
		case 0x16 { @stack[$SP]=($B);$IP++;}
		case 0x17 { $SP=$A;$IP++;}
		case 0x18 { $SP=$B;$IP++;}
		case 0x19 { $A=$SP;$IP++;}
		case 0x1A { $A=ord(@ROM[++$IP]);$IP++;}
		case 0x1B { $B=ord(@ROM[++$IP]);$IP++;}
#Addition
		case 0x1C { $A=$A+ord(@ROM[++$IP]);$IP++;}
		case 0x1D { $A=$A+$B;$IP++;}
		case 0x1E { $B=$B+ord(@ROM[++$IP]);$IP++;}
		case 0x1F { $B=$A+$B;$IP++;}
#Substraction
		case 0x20 { $A=$A-ord(@ROM[++$IP]);$IP++;}
		case 0x21 { $A=$A-$B;$IP++;}
		case 0x22 { $B=$B-ord(@ROM[++$IP]);$IP++;}
		case 0x23 { $B=$B-$A;$IP++;}
#Compare
		case 0x24 { $FLAG=$A-$B;$IP++;}
		case 0x25 { $FLAG=($A)-ord(@ROM[++$IP]);$IP++;}
		case 0x26 { $FLAG=($B)-ord(@ROM[++$IP]);$IP++;}
#JMP
		case 0x27 { $IP=$A;}
		case 0x28 { $IP=$B;}
		case 0x29 { $IP=$IP+ord(@ROM[++$IP]);}
#JNE
		case 0x2A { if($FLAG!=0){$IP=$A;}else{$IP++;$IP++;}}
		case 0x2B { if($FLAG!=0){$IP=$B;}else{$IP++;$IP++;}}
		case 0x2C { if($FLAG!=0){$IP=($IP)+ord(@ROM[++$IP]);}else{$IP++;$IP++;}}
#JE
		case 0x2D { if($FLAG==0){$IP=$A;}else{$IP++;$IP++;}}
		case 0x2E { if($FLAG==0){$IP=$B;}else{$IP++;$IP++;}}
		case 0x2F { if($FLAG==0){$IP=$IP+ord(@ROM[++$IP]);}else{$IP++;$IP++;}}
#JGE
		case 0x30 { if($FLAG>=0){$IP=$A;}else{$IP++;$IP++;}}
		case 0x31 { if($FLAG>=0){$IP=$B;}else{$IP++;$IP++;}}
		case 0x32 { if($FLAG>=0){$IP=$IP+ord(@ROM[++$IP]);}else{$IP++;$IP++;}}
#JLE
		case 0x33 { if($FLAG<=0){$IP=$A;}else{$IP++;$IP++;}}
		case 0x34 { if($FLAG<=0){$IP=$B;}else{$IP++;$IP++;}}
		case 0x35 { if($FLAG<=0){$IP=$IP+ord(@ROM[++$IP]);}else{$IP++;$IP++;}}
#inc
		case 0x36 { $A++;$IP++;}
		case 0x37 { $B++;$IP++;}
		case 0x38 { $SP++;$IP++;}
#Miscellaneous
		case 0x39 { @stack[$SP]=ord(getc());$IP++;}
		case 0x3A { printf "%c",((@stack[$SP]));$IP++;}
		case 0x3B { $IP++;}
		case 0x3C { print "\nHalt.\n";exit;}
		case 0x3D { $IP=$IP-ord(@ROM[++$IP]);}
		case 0x3E { sleep ord((@ROM[++$IP]));$IP++;}
		else 
			{print "\nInvalid Bootrom.\n";
			 exit;}
		}
}
