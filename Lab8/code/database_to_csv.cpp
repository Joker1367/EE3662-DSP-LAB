#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <fstream>

using namespace std;

int main(void){
    ifstream inFile;
    ofstream outFile;
    inFile.open("112.txt");
    outFile.open("112m.csv");
    //outFile << "Truth" << endl;

    cout << "ERROR!\n";

    string a, b, c, d, e;
    while(!inFile.eof()){
        inFile >> a >> b >> c >> d >> e;
        int len = e.length();
        double minute = 0;
        double second = 0;
        double fp = 0;
        int i = 0;
        while(e[i] != ':'){
            minute *= 10;
            minute += e[i] - '0';
            i++;
        }
        //cout << minute << endl;
        i++;
        while(e[i] != '.'){
            second *= 10;
            second += e[i] - '0';
            i++;
        }
        //cout << second << endl;
        i++;
        second += (e[i] - '0') / 10.0 + (e[i + 1] - '0') / 100.0 + (e[i + 2] - '0') / 1000.0 + minute * 60;
        //cout << second << endl;
        //cout << second << endl;
        outFile << second << endl;
    }
    return 0;
}