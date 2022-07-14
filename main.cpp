#include <iostream>
#include <vector>
#include <math.h>
#include "kernel.cuh"

/*
For a positive integer n, let σ2(n) be the sum of the squares of its divisors. For example,

σ2(10) = 1 + 4 + 25 + 100 = 130.
Find the sum of all n, 0 < n < 64,000,000 such that σ2(n) is a perfect square.

*/

std::vector<int> getDivisors(int n){
    std::vector<int> divs = {};
    for (int i = 0; i <= n; i++){
        /*
        if (div(n, i).rem == 0){
            divs.push_back(i);
        }
        */
       if (n % i == 0){
            divs.push_back(i);
        }
    }
    return divs;
}

auto factors(int n){
    std::vector<int> divs;
    int i = 1;
    while (i * i <= n){
        if (n % i == 0){
            divs.push_back(i);
            if (n/i != i){
                divs.push_back(n/i);
            }
        }
        i++;
    }
    return divs;
}

long long sumSquares(std::vector<int>& d){
    long long sum = 0;
    for(auto& n : d){
        sum += n * n;
    }
    return sum;
}

bool perfectSquare(long long& n){
    double sr = round(sqrt((double) n));
    return n == sr*sr;
}

void testRun(int i, int *y){
    long long sum = 0;
    long long j = 1;
    while (j * j <= i){
        if (i % j == 0){
            sum += j*j;
            if (j * j != i){
                sum += ((j/i) * (j/i));
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

int main(int, char**) {
    //std::vector<int> d = getDivisors(91816);
    int testNum = 31;
    std::vector<int> d = factors(testNum);
    for(auto& n : d){
        std::cout<<n<<'\n';
    }
    long long s = sumSquares(d);
    std::cout<<s<<'\n';
    std::cout<<perfectSquare(s)<<'\n';
    std::cout<<"\n\n\n------------------\n\n\n";
    std::cout<<"Running Kernel\n";
    run();
    std::cout<<"\n\n\n------------------\n\n\n";
    std::cout<<"TEST Kernel\n";

    //testRun(testNum);
}
