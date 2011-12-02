/**************************
 * Aod8 Virtual Processor *
 **************************/
// (c) Aodrulez.
#include <stdio.h>
#include <stdlib.h>

char *ROM;
char STACK[65535];
int A,B,SP,FLAG,OPCODE=0;
unsigned int IP=0;


void run(void)
{

	while(IP>=0 && OPCODE!=0x3c)
	{
	OPCODE=ROM[IP];
	printf("\n----------------------------------\nIP=%u A=%d B=%d FLAG=%d SP=%d [SP]=%d",IP,A,B,FLAG,SP,STACK[SP]);	
		switch(OPCODE)
		{	//MOV
			case 0x11: A=STACK[SP]; printf("\nmov a,[sp]");IP++;break;
			case 0x12: B=STACK[SP]; printf("\nmov b,[sp]");IP++;break;
			case 0x13: A=B;printf("\nmov a,b");IP++;break; 
			case 0x14: B=A;printf("\nmov b,a");IP++;break;
			case 0x15: STACK[SP]=A;printf("\nmov [sp],a");IP++;break; 
			case 0x16: STACK[SP]=B;printf("\nmov [sp],b");IP++;break;
			case 0x17: SP=A;printf("\nmov sp,a");IP++;break; 
			case 0x18: SP=B;printf("\nmov sp,b");IP++;break; 
			case 0x19: A=SP;printf("\nmov a,sp");IP++;break; 
			case 0x1A: A=ROM[++IP];printf("\nmov a,%d",ROM[IP]);IP++;break; 
			case 0x1B: B=ROM[++IP];printf("\nmov b,%d",ROM[IP]);IP++;break; 
			//Addition
			case 0x1C: A=A+ROM[++IP];printf("\nadd a,%d",ROM[IP]);IP++;break; 
			case 0x1D: A=A+B;printf("\nadd a,b");IP++;break; 
			case 0x1E: B=B+ROM[++IP];printf("\nadd b,%d",ROM[IP]);IP++;break; 
			case 0x1F: B=B+A;printf("\nadd b,a");IP++;break; 
			//SUBSTRACTION
			case 0x20: A=A-ROM[++IP];printf("\nsub a,%d",ROM[IP]);IP++;break; 
			case 0x21: A=A-B;printf("\nsub a,b");IP++;break; 
			case 0x22: B=B-ROM[++IP];printf("\nsub b,%d",ROM[IP]);IP++;break; 
			case 0x23: B=B-A;printf("\nsub b,a");IP++;break; 
			//Compare
			case 0x24: FLAG=A-B;printf("\ncmp a,b");IP++;break; 
			case 0x25: FLAG=A-ROM[++IP];printf("\ncmp a,%d",ROM[IP]);IP++;break; 
			case 0x26: FLAG=B-ROM[++IP];printf("\ncmp b,%d",ROM[IP]);IP++;break; 
			//JMP
			case 0x27: IP=A;printf("\njmp a");break; 
			case 0x28: IP=B; printf("\njmp b");break;
			case 0x29: IP=IP+ROM[++IP];printf("\njmp %d",ROM[IP]);break; 
			//JNE
			case 0x2A: if(FLAG!=0){IP=A;}else{IP++;};printf("\njne a");break; 
			case 0x2B: if(FLAG!=0){IP=B;}else{IP++;};printf("\njne b");break; 
			case 0x2C: if(FLAG!=0){IP=IP+ROM[++IP];printf("\njne %d",ROM[IP]);}else{IP++;printf("\njne %d",ROM[IP]);IP++;};break; 
			//JE
			case 0x2D: if(FLAG==0){IP=A;}else{IP++;};printf("\nje a");break;
			case 0x2E: if(FLAG==0){IP=B;}else{IP++;};printf("\nje b");break;
			case 0x2F: if(FLAG==0){IP=IP+ROM[++IP];printf("\nje %d",ROM[IP]);}else{IP++;printf("\nje %d",ROM[IP]);IP++;};break; 
			//JGE
			case 0x30: if(FLAG>=0){IP=A;}else{IP++;};printf("\njge a");break;
			case 0x31: if(FLAG>=0){IP=B;}else{IP++;};printf("\njge a");break;
			case 0x32: if(FLAG>=0){IP=IP+ROM[++IP];printf("\njge %d",ROM[IP]);}else{IP++;printf("\njge %d",ROM[IP]);IP++;};break; 
			//JLE
			case 0x33: if(FLAG<=0){IP=A;}else{IP++;};printf("\njle a");break;
			case 0x34: if(FLAG<=0){IP=B;}else{IP++;};printf("\njle a");break;
			case 0x35: if(FLAG<=0){IP=IP+ROM[++IP];printf("\njle %d",ROM[IP]);}else{IP++;printf("\njle %d",ROM[IP]);IP++;};break; 
			//INC
			case 0x36: ++A;printf("\ninc a");IP++;break; 
			case 0x37: ++B;printf("\ninc b");IP++;break; 
			case 0x38: ++SP;printf("\ninc sp");IP++;break; 
			//MISC
			case 0x39: printf("\ninput :");STACK[SP]=getchar();IP++;break; 
			case 0x3A: printf("\noutput : ");putchar(STACK[SP]);IP++;break; 
			case 0x3B: printf("\nnop");IP++;break; 
			case 0x3C: printf("\nHalt.");exit(0);
			case 0x3D: IP=IP-ROM[++IP];printf("\nloop %d",IP);break; 
			case 0x3E: printf("\nsleep %d",ROM[++IP]);++IP;break;
			default:printf("\nInvalid Boot-rom.");exit(0);
		}
	 printf("\nIP=%u A=%d B=%d FLAG=%d SP=%d [SP]=%d\n----------------------------------\n\n",IP,A,B,FLAG,SP,STACK[SP]);	
	}
}


main()
{
	FILE *file;
	unsigned long fileLen;
	file = fopen("bootrom.txt", "rb");
	if (!file)
	{
		printf("\nCan't open Boot-Rom");
		exit(1);
	}
	fseek(file, 0, SEEK_END);
	fileLen=ftell(file);
	fseek(file, 0, SEEK_SET);
	ROM=(char *)malloc(fileLen+1);
	if (!ROM)
	{
		printf("\nMemory error!");
        fclose(file);
		exit(1);
	}
	fread(ROM, fileLen, 1, file);
	fclose(file);
	run();
}


