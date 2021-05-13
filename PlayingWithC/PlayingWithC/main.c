//
//  main.c
//  PlayingWithC
//
//  Created by Jonathan Pappas on 5/11/21.
//

#include <stdio.h>

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    
    
    int count = 1;
    
    for(int i=0;i<1000000000;i++) {
        for(int j=0;j<1000000000;j++) {
            for(int l=0;l<1000000000;l++) {
                for(int m=0;m<1000000000;m++) {
                    count++;
                }
            }
        }
    }
    printf("%d", count);
    
    
    return 0;
}
