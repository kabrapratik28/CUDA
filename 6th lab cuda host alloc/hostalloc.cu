#include<stdio.h>
#include<cuda.h>
//#include<conio.h>
#include<malloc.h>
int *a,*b,*c;
int *ga,*gb,*gc;
int numOfBlocks; 
int blocksize=256;
float et;
int sizerowa , sizeclma;

__global__ void MatrixMatrixadd (int* ga,int *gb,int* gc,int size)
{

int i=threadIdx.x + (blockIdx.x*blockDim.x);

  if(i<size)
{ 
  gc[i] =ga[i]+gb[i];
}

}


int main()
{

printf("Enter user matrix siz\n");
scanf("%d %d", &sizerowa ,  &sizeclma);

a=(int*)malloc((sizerowa* sizeclma)*sizeof(int));


int i=0; 



cudaMalloc((void**)&ga,( sizerowa* sizeclma) *sizeof(int));
int *p ; 
cudaHostAlloc(&p ,(sizerowa*sizeclma)*sizeof(int),cudaHostAllocPortable );



		 cudaEvent_t start,stop;
		 cudaEventCreate(&start);
		 cudaEventCreate(&stop);
		 cudaEventRecord(start,0);

		 cudaMemcpy(ga,a,( sizerowa* sizeclma)*sizeof(int),cudaMemcpyHostToDevice);
				
				cudaEventRecord(stop,0);
				cudaEventSynchronize(stop);
				cudaEventElapsedTime(&et,start,stop);
				cudaEventDestroy(start);
				cudaEventDestroy(stop);
				cudaDeviceSynchronize();

				
				printf("without page locked parallel %f\n",et);




				//cudaEvent_t start,stop;
		 cudaEventCreate(&start);
		 cudaEventCreate(&stop);
		 cudaEventRecord(start,0);

		 cudaMemcpy(ga,p,( sizerowa* sizeclma)*sizeof(int),cudaMemcpyHostToDevice);
				
				cudaEventRecord(stop,0);
				cudaEventSynchronize(stop);
				cudaEventElapsedTime(&et,start,stop);
				cudaEventDestroy(start);
				cudaEventDestroy(stop);
				cudaDeviceSynchronize();

				
				printf("pagelocked parallel %f\n",et);



return 0 ; 
}



