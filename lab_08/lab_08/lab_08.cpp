#include <iostream>

#define BAD_OPERATION -1

#define SUCCESS 0

using namespace std;

float addFloat(const float fNum, const float sNum) {
	float result = 0;
	__asm {
		fld fNum
		fld sNum
		fadd
		fstp result
	}
	return result;
}

float difFloat(const float fNum, const float sNum) {
	float result = 0;
	__asm {
		fld fNum
		fld sNum
		fsub
		fstp result
	}
	return result;
}

float mulFloat(const float fNum, const float sNum) {
	float result = 0;
	__asm {
		fld fNum
		fld sNum
		fmul
		fstp result
	}
	return result;
}

float divFloat(const float fNum, const float sNum) {
	return 0;
}

int reallyBadCalculator(const float fNum, const float sNum, const char oper, float &result) {
	if (oper == '+')
		result = addFloat(fNum, sNum);
	else if (oper == '-')
		result = difFloat(fNum, sNum);
	else if (oper == '*')
		result = mulFloat(fNum, sNum);
	else if (oper == '/')
		result = divFloat(fNum, sNum);
	else
		return BAD_OPERATION;

	return SUCCESS;
}

int main()
{
	cout << "Set your epxr: ";
	float firstNum = 0, secondNum = 0;
	char oper = '+';

	cin >> firstNum >> oper >> secondNum;
	float result = 0;

	int check = reallyBadCalculator(firstNum, secondNum, oper, result);

	if (!check)
		cout << "Result of this operation is: " << result;

	return check;
}
