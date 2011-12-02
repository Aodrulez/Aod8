#include <stdio.h>
#include <string.h>
int main()
{char user[50];int x;
printf("\nName : ");
scanf("%s",user);

for(x=0;x<strlen(user);x++)
{
printf("%c",user[x]-((x+1)*2));
}
printf("\n");

}
