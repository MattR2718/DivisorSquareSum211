#include "kernel.cuh"

__global__
void work(int n, long long *x, long long *y){
    //printf("IN KERNEL\n");
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for(int i = index; i < n; i+=stride){
        long long sum = 0;
        for (long long j = 0; j <= x[i]; j++){
            if (x[i] % j == 0){
                //is a divisor
                sum += j * j;
            }
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
    int N = 100000;
    long long *x, *y;
    cudaMallocManaged(&x, N*sizeof(long long));
    cudaMallocManaged(&y, N*sizeof(long long));
    for (int i = 0; i < N; i++){
        x[i] = i;
        y[i] = 0;
    }

    int blockSize = 256;
    int numBlocks = (N + blockSize - 1) / blockSize;
    work<<<numBlocks,blockSize>>>(N, x, y);
    cudaDeviceSynchronize();
    long long s = 0;
    for (int i = 0; i < N; i++){
        if (y[i]){
            std::cout<<x[i]<<'\n';
            s += x[i];
        }
    }
    std::cout<<"Sum: "<<s<<'\n';
    cudaFree(x);
    cudaFree(y);
}