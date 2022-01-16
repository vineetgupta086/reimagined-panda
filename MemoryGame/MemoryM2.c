/*Memory Game Mark-2*/
#include<stdio.h>
#include<stdlib.h>
#include<dos.h>
#include<time.h>

//USER DEFINED: PRINTLINE 
int printline()
{
	int i;
	for(i=0;i<22;i++)
	{
		printf("*");
	}
	printf("\n");
	return 0;
}

//USER DEFINED: RANDOM FUNCTION (SRAND)
int random_number(void)
{
	int i=0; int x;
	srand(time(0));
	do
	{
	     x=rand();
	     if(x<=9)
	     {
		  i++;
	     }
	}while(i<1);
	return x;
}

//MAIN FUNCTION
void main()
{
	//VARIABLE DECLARATION
	int flag=0; char c; unsigned long long int m=0,x,n;
	
	//CLRSCR() SUBSTITUTE
	system("cls");
	
	printline();
	printf("WELCOME TO MEMORY GAME\n");
	printline();
	printf("Press enter key to start the game.\n");
	getche();

	//MAIN ALGORITHM
	do
	{
		if(flag!=0)
		{
			printf("YOU ARE CORRECT\n");
		}
		
		n=random_number();
		m=(10*m)+n;
		printf("\n%llu",n);
		sleep(2);
        
		//CLRSCR() SUBSTITUTE
		system("cls");
		printf("\nEnter number:  ");
		scanf("%llu",&x);
		if(x==m)
		{
			flag=++flag;
		}
	}while(x==m);
	sleep(2);
	printf("\nCorrect number:%llu\n",m);
	printline();
	printf("GAME OVER!\n");
	printline();
	printf("YOUR SCORE: %d\n",flag);
	printf("Press any key.");
	getche();
}
