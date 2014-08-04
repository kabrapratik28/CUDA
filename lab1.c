/*
PRATIK SHRIKANT KABARA
C-53
GR NO. 111292
*/
#include<stdio.h>
//#include<conio.h>
#include<malloc.h>
#include<time.h>

int main()
{

clock_t begin,end ;
double timet ;

long int total = 10000 ;
long int i = 0 ;


long int *a = (long int *)malloc(total*sizeof(long));
long int *b=  (long int *)malloc(total*sizeof(long));
long int *c = (long int *)malloc(total*sizeof(long));
//clrscr() ;

for (i=0 ; i<total ; i++)
{
	*(a + i)=i ;
	*(b+i)=i  ;
 //	*(c+i)=i ;
}
begin = clock() ;
for (i=0 ; i<total ; i++)
{
	//*(a + i)=i ;
 //	*(b+i)=i  ;
 *(c+i)= (*(a+i)) + (*(b+i)) ;
 //printf("%ld\n", *(c+i)) ;
}
end = clock() ;

//printf("%ld\n", *(c+i-1)) ;

timet = ((double)(end-begin)) /CLOCKS_PER_SEC ;
printf("%f",timet) ;

//getch() ;
return 0 ;
}



/*
Output  Time not precise (Try using cuda time same program)
0.0000
0.0000
0.0000
*/
