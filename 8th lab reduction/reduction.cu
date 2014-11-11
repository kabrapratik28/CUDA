//nvcc -arch=sm_20 reduction.cu
#include<stdio.h>
#include<cuda.h>
#include<malloc.h>

int *a,*c;
int *ga,*gc;
int sizerowa;
int numOfBlocks; 
int blocksize=256;
float et;
__global__ void VectorMatrix(int* ga,int* gc,int sizerowa)
{
extern  __shared__ int s[];
int i=threadIdx.x;


//copy max in s[i]
 s[i]=999999; 
 __syncthreads();

//copy the values from d_var in s[i] 
 if (i<sizerowa)
    s[i]=ga[i];
 __syncthreads();

printf ("%d  ",s[i]);

//Do the reduction

 if (blockDim.x>=256)
 {
	if(i<128)
	{
		if(s[i]>s[i+128])
		{
			s[i]= s[i+128];
		}
 	}

	__syncthreads( );
 }

 if (blockDim.x>=128)
 {
	if(i<64)
	{
		if(s[i]>s[i+64])
		{
			s[i]= s[i+64];
		}
 	}

	__syncthreads( );
 }

 if (blockDim.x>=64)
 {
	if(i<32)
	{
		if(s[i]>s[i+32])
		{
			s[i]= s[i+32];
		}
 	}

	__syncthreads( );
 }

 if (blockDim.x>=32)
 {
	if(i<16)
	{
		if(s[i]>s[i+16])
		{
			s[i]= s[i+16];
		}
 	}

	__syncthreads( );
 }

 if (blockDim.x>=16)
 {
	if(i<8)
	{
		if(s[i]>s[i+8])
		{
			s[i]= s[i+8];
		}
 	}

	__syncthreads( );
 }

 if (blockDim.x>=8)
 {
	if(i<4)
	{
		if(s[i]>s[i+4])
		{
			s[i]= s[i+4];
		}
 	}

	__syncthreads( );
 }

 if (blockDim.x>=4)
 {
	if(i<2)
	{
		if(s[i]>s[i+2])
		{
			s[i]= s[i+2];
		}
 	}

	__syncthreads( );
 }

 if (blockDim.x>=2)
 {
	if(i<1)
	{
		if(s[i]>s[i+1])
		{
			s[i]= s[i+1];
		}
 	}

	__syncthreads( );
 }
 
//Thread zero will store minimum of this block in d_Min
if(i==0)
{
	*(gc+0)=s[0];
	printf("\nparallel %d\n",s[0]);
}


}


int main()
{

printf("Enter user matrix siz\n");
scanf("%d", &sizerowa );

a=(int*)malloc(sizerowa*sizeof(int));
c=(int*)malloc((1)*sizeof(int));


int i=0; 
 
 for(i=0;i<sizerowa;i++)
{
*(a+i)=i+2;
}


numOfBlocks=sizerowa/blocksize;
if(sizerowa%blocksize>0) numOfBlocks++;

cudaMalloc((void**)&ga,sizerowa*sizeof(int));
cudaMalloc((void**)&gc,1*sizeof(int));


cudaMemcpy(ga,a,sizerowa*sizeof(int),cudaMemcpyHostToDevice);


	cudaEvent_t start,stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start,0);
			VectorMatrix<<<numOfBlocks,blocksize,sizerowa*sizeof(int)>>>(ga,gc,sizerowa);
	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&et,start,stop);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);
		
		cudaDeviceSynchronize();

		cudaMemcpy(c,gc,1*sizeof(int),cudaMemcpyDeviceToHost);
			
	printf(" parallel %f\n",et);

printf("%d",*c);
return 0 ; 
}

