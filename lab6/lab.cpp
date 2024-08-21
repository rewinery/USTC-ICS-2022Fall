#include <cstdint>
#include <iostream>
#include <fstream>
#define MAXLEN 100
#ifndef LENGTH
#define LENGTH 3
#endif
//

int16_t lab1(int16_t a, int16_t b)
{
    int sum = 0;
    int i, j = 1;
    for (i = 0; i < b; i++)
    {
        if (a & j)
            sum++;
        j = j + j;
    }
    return sum;
}
int16_t lab2(int16_t p, int16_t q, int16_t n)
{
    if ((n == 0) || (n == 1))
        return 1;
    int16_t a, b, c;
    c = lab2(p, q, n - 1);
    a = lab2(p, q, n - 2) & (p - 1);
    while (c > 0)
    {
        c = c - q;
    }
    b = q + c;
    return a + b;
}
int16_t lab3(int16_t n, char s[])
{
    int sum = 1;
    int max = 1;
    if (n == 0)
        return 0;
    for (int i = 1; i <= n; i++)
    {
        if (s[i] == s[i + 1])
            sum++;
        else
        {
            if (sum > max)
                max = sum;
            sum = 1;
        }
    }
    return max;
}
void lab4(int16_t score[], int16_t &a, int16_t &b)
{
    int16_t temp;
    for (int i = 0; i < 16; i++)
    {
        for (int j = 0; j < 16; j++)
        {
            if (score[j] > score[j + 1])
            {
                temp = score[j];
                score[j] = score[j + 1];
                score[j + 1] = temp;
            }
        }
    }
    for (int i = 15; i >= 7; i--)
    {
        if ((i > 11) && (score[i] >= 85))
            a++;
        else if (score[i] >= 75)
            b++;
    }
}
int main()
{
    std ::fstream file;
    file.open("test.txt", std ::ios ::in);
    // lab1
    int16_t a = 0, b = 0;
    for (int i = 0; i < LENGTH; i++)
    {
        file >> a >> b;
        std ::cout << lab1(a, b) << std ::endl;
    }

    // lab2
    int16_t p = 0, q = 0, n = 0;
        for (int i = 0; i < LENGTH; i++) {
            file >> p >> q >> n;
            // std ::cout << lab2(p, q, n) << std ::endl;
        }
    // lab3
    char s[MAXLEN];
    for (int i = 0; i < LENGTH; ++i)
    {
        file >> n >> s;
        std ::cout << lab3(n, s) << std ::endl;
    }
    // lab4
    int16_t score[16];
    for (int i = 0; i < LENGTH; ++i)
    {
        for (int j = 0; j < 16; j++)
        {
            file >> score[j];
        }

        lab4(score, &a, &b);
        for (int j = 0; j < 16; j++)
        {
            std ::cout << score[j] << " ";
        }
        std ::cout << std ::endl
                   << a << " " << b << std ::endl;
    }
    file.close();
    return 0;
}