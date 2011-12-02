/**************************
 * Aod8 Virtual Processor *
 **************************/
// (c) Aodrulez.
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

char *ROM;
char STACK[65535];
int A,B,SP,FLAG,OPCODE=0;
unsigned int IP=0;



void run(void)
{
printf("\n[!] Registers initialised to 0.");
printf("\n[!] Booting using the Boot-Rom.\n-------------------------------\n\n");
	while(IP>=0 && OPCODE!=0x3c)
	{
	OPCODE=ROM[IP];
		
		switch(OPCODE)
		{	//MOV
			case 0x11: A=STACK[SP];IP++;break;
			case 0x12: B=STACK[SP];IP++;break;
			case 0x13: A=B;IP++;break;
			case 0x14: B=A;IP++;break;
			case 0x15: STACK[SP]=A;IP++;break;
			case 0x16: STACK[SP]=B;IP++;break;
			case 0x17: SP=A;IP++;break;
			case 0x18: SP=B;IP++;break;
			case 0x19: A=SP;IP++;break;
			case 0x1A: A=ROM[++IP];IP++;break;
			case 0x1B: B=ROM[++IP];IP++;break;
			//Addition
			case 0x1C: A=A+ROM[++IP];IP++;break;
			case 0x1D: A=A+B;IP++;break;
			case 0x1E: B=B+ROM[++IP];IP++;break;
			case 0x1F: B=B+A;IP++;break;
			//SUBSTRACTION
			case 0x20: A=A-ROM[++IP];IP++;break;
			case 0x21: A=A-B;IP++;break;
			case 0x22: B=B-ROM[++IP];IP++;break;
			case 0x23: B=B-A;IP++;break;
			//Compare
			case 0x24: FLAG=A-B;IP++;break;
			case 0x25: FLAG=A-ROM[++IP];IP++;break;
			case 0x26: FLAG=B-ROM[++IP];IP++;break;
			//JMP
			case 0x27: IP=A;break;
			case 0x28: IP=B;break;
			case 0x29: IP=IP+ROM[++IP];break;
			//JNE
			case 0x2A: if(FLAG!=0){IP=A;}else{IP++;};break;
			case 0x2B: if(FLAG!=0){IP=B;}else{IP++;};break;
			case 0x2C: if(FLAG!=0){IP=IP+ROM[++IP];}else{IP++;IP++;};break;
			//JE
			case 0x2D: if(FLAG==0){IP=A;}else{IP++;};break;
			case 0x2E: if(FLAG==0){IP=B;}else{IP++;};break;
			case 0x2F: if(FLAG==0){IP=IP+ROM[++IP];}else{IP++;IP++;};break;
			//JGE
			case 0x30: if(FLAG>=0){IP=A;}else{IP++;};break;
			case 0x31: if(FLAG>=0){IP=B;}else{IP++;};break;
			case 0x32: if(FLAG>=0){IP=IP+ROM[++IP];}else{IP++;IP++;};break;
			//JLE
			case 0x33: if(FLAG<=0){IP=A;}else{IP++;};break;
			case 0x34: if(FLAG<=0){IP=B;}else{IP++;};break;
			case 0x35: if(FLAG<=0){IP=IP+ROM[++IP];}else{IP++;IP++;};break;
			//INC
			case 0x36: ++A;IP++;break;
			case 0x37: ++B;IP++;break;
			case 0x38: ++SP;IP++;break;
			//MISC
			case 0x39: STACK[SP]=getchar();IP++;break;
			case 0x3A: putchar(STACK[SP]);IP++;break;
			case 0x3B: IP++;break;
			case 0x3C: printf("\nHalt.");exit(0);
			case 0x3D: IP=IP-ROM[++IP];break;
			case 0x3E: sleep(ROM[++IP]);++IP;break;
			default:printf("\nInvalid Boot-rom.");exit(0);
		}
	}
}


main()
{
setbuf(stdout, NULL);
printf("\n   +--------------------------+");
printf("\n   |  Aod8 Virtual Processor  |");    
printf("\n   +--------------------------+");
printf("\n          (c) Aodrulez.");
printf("\n\n[+] Reading the Boot-Rom.");

	FILE *file;
	unsigned long fileLen;
	file = fopen("bootrom.txt", "rb");
	if (!file)
	{
		printf("\nCan't open Boot-Rom");
		exit(1);
	}
printf("\n[+] Read successfully.");
	fseek(file, 0, SEEK_END);
	fileLen=ftell(file);
printf("\n[+] Total Size : %lu.",fileLen);
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


