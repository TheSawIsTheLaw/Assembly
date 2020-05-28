#include <stdio.h>

#define YES 1
#define NO 0

#define ITSAHUMAN 0
#define SATAN 666
#define NOTSATAN -666
#define LEET 1337
#define AZINO 777

#define SUCCESS 0

/*
 * Собственно, по заданному тесту нужно набрать 0 баллов.
 * Прямо как на экзамене. Только тут не отчисляют.
 */

int firstQuestion() {
    printf("\nFirst question is: Are you a machine? Answer: ");
    int ret = NO;
    scanf("%d", &ret);

    return ret;
}


int clarification() {
    printf("\nAre you sure? Answer: ");
    int notRet = NO;
    scanf("%d", &notRet);

    return notRet;
}


int secondQuestion() {
    printf("\nSecond question is: Are you a human? Answer: ");
    int answ = NO;
    scanf("%d", &answ);

    if (answ == YES)
        answ = clarification();
    else
        answ = YES;
    return answ;
}


int thirdQuestion() {
    printf("\nThird question is: Can you kill a human? Answer: ");
    int answ = NO;
    int answs[] = { YES, NO, NO, NOTSATAN, YES, NO, SATAN, YES, LEET, AZINO};
    int answsSec[] = { SATAN, SATAN, NO, NOTSATAN, SATAN, NO, SATAN, YES, LEET, AZINO};

    scanf("%d", &answ);
    return answsSec[1] + answs[3] + answ;
}


int main(void) {
    printf("You won't pass, machine!");

    int mark = 0;

    mark += firstQuestion();

    mark += secondQuestion();

    mark += thirdQuestion();

    if (mark == ITSAHUMAN)
        printf("\nOh, hi, Mark!");
    else
        printf("Stupid cringeMachine! Go away!");

    return SUCCESS;
}
