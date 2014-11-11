#include<stdio.h>

float comb6 (int n , int k)
{
  int i = 1 ; 
  float t = 1 ; 
  if (k<(n-k))
    {
      for(i=n;i>=(n-k+1);i--)
	{
	  t = t * i /(n-i+1); 
	}
    }

  else 
    {
      for (i=n; i>=(k+1); i--  )
	{
	  t = t * i / (n-i+1);
	}
    }
  return t ; 
}

int main ()
{
  
  printf("%f",comb6(7,3)) ; 

  return 0 ; 
}
