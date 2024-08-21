#include <bits/stdc++.h>

#define LENGTH 3
#define MAXLEN 100
#define SCORENUM 16

int16_t lab1(const int16_t a, const int16_t b) {
    int16_t n = 1, cnt = 0;
    for(int i = 0; i < b; i++) {
        if(n & a)
            cnt++;
        n += n;
    }
    return cnt;
}

int16_t getFn(int16_t f1, int16_t f2, const int16_t p, const int16_t q) {
    while(f1 >= 0)
        f1 -= p;
    f1 += p;
    while(f2 >= 0)
        f2 -= q;
    f2 += q;
    return f1 + f2;
}

int16_t lab2(const int16_t p, const int16_t q, const int16_t n) {
    int16_t f[n+1];
    f[0] = f[1] = 1;
    for(int i = 2; i <= n; i++)
        f[i] = getFn(f[i-2], f[i-1], p, q);
    return f[n];
}

int16_t __lab2(const int16_t p, const int16_t q, const int16_t n) {
    if(!n || n == 1)
        return 1;
    return __lab2(p, q, n-2) % p + __lab2(p, q, n-1) % q;
}

int16_t lab3(const int16_t n, const char s[]) {
    int16_t max = 0, now = 0;
    for(int i = 1; i < n; i++) {
        if(s[i] == s[i-1])
            now++;
        else 
            now = 0;
        if(now > max)
            max = now;
    }
    return max+1;
}

void lab4(int16_t score[], int16_t &a, int16_t &b) {
    a = b = 0;
    int swap, idx;
    for(int i = 0; i < SCORENUM-1; i++) {
        idx = i;
        swap = score[i];
        for(int j = i+1; j < SCORENUM; j++)
            if(score[j] < swap) {
                swap = score[j];
                idx = j;
            }
        if(idx != i) {
            score[idx] = score[i];
            score[i] = swap;
        }
    }
    for(idx  = SCORENUM-1; idx > 11; idx--) {
        if(score[idx] >= 85)
            a++;
        else
            break;
    }
    for(; idx > 7; idx--) {
        if(score[idx] >= 75)
            b++;
        else
            break;
    }
}

int main() {
    std::fstream file;
    file.open("test.txt", std::ios::in);

    // lab1
    int16_t a = 0, b = 0;
    for(int i = 0; i < LENGTH; i++) {
        file >> a >> b;
        std::cout << lab1(a, b) << std::endl;
    }

    // lab2
    int16_t p = 0, q = 0, n = 0;
    for(int i = 0; i < LENGTH; i++) {
        file >> p >> q >> n;
        std::cout << lab2(p, q, n) << std::endl;
    }

    // lab3 
    char s[MAXLEN];;
    for(int i = 0; i < LENGTH; i++) {
        file >> n >> s;
        std::cout << lab3(n, s) << std::endl;
    }


    // lab4
    int16_t score[SCORENUM];
    for(int i = 0; i < LENGTH; i++) {
        for(int j = 0; j < SCORENUM; j++)
            file >> score[j];
        lab4(score, a, b);
        for(int j = 0; j < SCORENUM; j++)
            std::cout << score[j] << " ";
        std::cout << std::endl << a << " " << b << std::endl;
    }
    
    file.close();
    return 0;
}