#include <stdio.h>

#define YES 1
#define NO 0

#define SUCCESS 0

int firstQuestion() {
    printf("\nFirst question is: Are you a machine?");
    int ret = NO;
    scanf("%d", &ret);

    return ret;
}

int secondQuestion() {
    printf("");
}

int main(void) {
    printf("You won't pass, machine!");

    int mark = 0;

    mark += firstQuestion();


    return SUCCESS;
}
