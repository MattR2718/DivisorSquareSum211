#include "kernel.cuh"

__global__
void work(int n, int *y, long long *squares){
    //printf("IN KERNEL\n");
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    int count = 0;
    for(int i = index; i < n; i+=stride){
        //count++;
        //if(count % 1000 == 0){printf("%d", count);}
        long long sum = 0;        
        long long j = 1;
        while (j * j <= i){
            if (i % j == 0){
                if  (!squares[j]){squares[j]=j*j;}
                sum += squares[j];
                if (j * j != i){
                    if  (!squares[(i/j)]){squares[(i/j)]=(i/j)*(i/j);}
                    sum += (squares[(i/j)]);
                }
            }
            j++;
        }
        
        double sr = round(sqrt((double) sum));
        if((double)sum == sr*sr){
            y[i] = 1;
        } else {
            y[i] = 0;
        }
    }
}

void run(){
    //int N = 64000001;
    int N = 5000000;
    //int *x, *y;
    int *y;
    long long *squares;
    //cudaMallocManaged(&x, N*sizeof(int));
    cudaMallocManaged(&y, N*sizeof(int));
    cudaMallocManaged(&squares, N*sizeof(long long));
    for (int i = 0; i < N; i++){
        //x[i] = i;
        y[i] = 0;
        squares[i] = 0;
    }

    int blockSize = 256;
    int numBlocks = (N + blockSize - 1) / blockSize;
    work<<<numBlocks,blockSize>>>(N, y, squares);
    cudaDeviceSynchronize();
    long long s = 0;
    for (int i = 0; i < N; i++){
        if (y[i]){
            std::cout<<i<<'\n';
            s += i;
        }
    }
    std::cout<<"Sum: "<<s<<'\n';
    //cudaFree(x);
    cudaFree(y);
    cudaFree(squares);
}