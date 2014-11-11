#include<stdio.h>
#include<cuda.h>
//#include<conio.h>
#include<malloc.h>
double *a,*b,*c;
double *ga,*gb,*gc;
int numOfBlocks; 
int blocksize=256;
float et;
int sizerowa , sizeclma;

__device__ float comb6 (int n , int k)
{
  int i = 1 ; 
  float t = 1.0 ; 
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


__global__ void combcal (double *d_p,int kk, int blocksize)
{
int u,v;
u= ((blockIdx.x*blocksize)+threadIdx.x)/(kk);
v = (( blockIdx.x * blocksize )+threadIdx.x)%(kk); 

if(u>=v)
{
	d_p[threadIdx.x + (blocksize * blockIdx.x)] = comb6(u,v);
}

}


int main()
{

printf("Enter user matrix siz\n");
scanf("%d", &sizerowa);

sizeclma = sizerowa;

a=(double *)malloc((sizerowa* sizeclma)*sizeof(double));
//b=(int*)malloc((sizerowa * sizeclma)*sizeof(int));
//c=(int*)malloc((sizerowa * sizeclma)*sizeof(int));

//printf("%d %d \n",sizerowa, sizeclma);
int i=0; 

/*
 for(i=0;i<( sizerowa* sizeclma);i++)
{
*(a+i)=i;
}


 for(i=0;i<( sizerowa* sizeclma);i++)
 {
 *(b+i)=i;
 }
*/

numOfBlocks=( sizerowa* sizeclma) /blocksize;
if((sizerowa* sizeclma)%blocksize>0) numOfBlocks++;

cudaMalloc((void**)&ga,( sizerowa* sizeclma) *sizeof(double));
//cudaMalloc((void**)&gb,( sizerowa* sizeclma)*sizeof(int));
//cudaMalloc((void**)&gc,( sizerowa* sizeclma)*sizeof(int));


//cudaMemcpy(ga,a,( sizerowa* sizeclma)*sizeof(int),cudaMemcpyHostToDevice);
//cudaMemcpy(gb,b, sizerowa* sizeclma *sizeof(int),cudaMemcpyHostToDevice);

//printf("%d %d \n",sizerowa, sizeclma);

		 cudaEvent_t start,stop;
		 cudaEventCreate(&start);
		 cudaEventCreate(&stop);
		 cudaEventRecord(start,0);
			combcal<<<numOfBlocks,blocksize>>>(ga,sizerowa,blocksize);

				cudaEventRecord(stop,0);
				cudaEventSynchronize(stop);
				cudaEventElapsedTime(&et,start,stop);
				cudaEventDestroy(start);
				cudaEventDestroy(stop);
				cudaDeviceSynchronize();

				cudaMemcpy(a,ga,( sizerowa* sizeclma)*sizeof(double),cudaMemcpyDeviceToHost);
				
				for(int jj=0; jj< sizerowa ; jj++)
				{
					for(int oo=0 ; oo < sizerowa ; oo++)
					{
						printf("%f  ",*(a+(sizerowa*jj)+oo));
					}
					printf("\n");
				}				

				printf(" parallel %f\n",et);


return 0 ; 
}



