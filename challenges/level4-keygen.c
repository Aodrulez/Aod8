#include <stdio.h>
#include <string.h>

int main()
{
int x,y=0;
char username[20],pass[20];
printf("\nKeygen for CTM Level-3");
printf("\nusername : ");
scanf("%s",username);

for(x=0;x<strlen(username);x++)
{
username[x]=username[x]-(20+x);
}
printf("Serial : %s\n",username);

}
