
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
__global__ void VectorMatrix(int* ga,int* gc,int sizerowa,int *secondtime,int count_take_first_second)
{
extern  __shared__ int s[];
int i=threadIdx.x;


//copy max in s[i]
 s[i]=99999; 
 __syncthreads();

//copy the values from d_var in s[i] 
int index = threadIdx.x+(blockDim.x*blockIdx.x);
 if (index<sizerowa)
    if (count_take_first_second==0)
    {
	s[i]=ga[index];
    }
    else 
    {
	s[i]=secondtime[index];
    }
 __syncthreads();

//printf ("%d  ",s[i]);

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
	*(gc+blockIdx.x)=s[0];
//	printf("\nblock minimum value  %d\n",s[0]);
}


}


int main()
{

printf("Enter user matrix siz\n");
scanf("%d", &sizerowa );

  
a=(int*)malloc(sizerowa*sizeof(int));
c=(int*)malloc((sizerowa)*sizeof(int));


int i=0; 
int flag = 0 ;
int current_size = sizerowa; 
int count_first_second = 0 ; 
 for(i=0;i<sizerowa;i++)
{
	*(a+i)=i+2;
}
//test only for size greater than 1000
//*(a+290)= -5 ; 
//*(a+800)=-6;

numOfBlocks=sizerowa/blocksize;
if(sizerowa%blocksize>0) numOfBlocks++;

cudaMalloc((void**)&ga,sizerowa*sizeof(int));
cudaMalloc((void**)&gc,sizerowa*sizeof(int));


cudaMemcpy(ga,a,sizerowa*sizeof(int),cudaMemcpyHostToDevice);


	cudaEvent_t start,stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start,0);

			do{
			numOfBlocks=current_size/blocksize;
			if( current_size%blocksize>0) numOfBlocks++;
			
			if (current_size<blocksize)
			{
				flag=1 ; 
			}	

			VectorMatrix<<<numOfBlocks,blocksize,blocksize*sizeof(int)>>>(ga,gc,current_size,gc,count_first_second);
			/*
			if (current_size%2==0)
			{
			current_size=current_size/2;
			}
			else{
			current_size=current_size/2+1;
			}
			*/
			current_size = numOfBlocks ;
			count_first_second++;	
			}while(flag!=1);

	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&et,start,stop);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);
		
		cudaDeviceSynchronize();

		cudaMemcpy(c,gc,1*sizeof(int),cudaMemcpyDeviceToHost);
			
	printf(" parallel %f\n",et);
    

printf("%d",*(c+0));
return 0 ; 
}

