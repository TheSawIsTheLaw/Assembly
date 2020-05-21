#include <iostream>

#define BAD_OPERATION -1

#define SUCCESS 0

using namespace std;

float sinFloat(const float angle) {
	float result = 0;
	__asm {
		fld angle
		fsin
		fstp result
	}
	return result;
}

float cosFloat(const float angle) {
	float result = 0;
	__asm {
		fld angle
		fcos
		fstp result
	}
	return result;
}

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
	float result = 0;
	__asm {
		fld fNum
		fld sNum
		fdiv
		fstp result
	}
	return result;
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

int goToAriphmetics(float &result) {
	cout << "Set your epxr: ";
	float firstNum = 0, secondNum = 0;
	char oper = '+';

	cin >> firstNum >> oper >> secondNum;

	int check = reallyBadCalculator(firstNum, secondNum, oper, result);
	return check;
}

void goToSinCos(float& result, int choice) {
	cout << "Angle: ";
	float angle = 0;
	cin >> angle;

	if (choice == 1)
		result = sinFloat(angle);
	else
		result = cosFloat(angle);
}

int main()
{
	cout << "What do you want?\n" <<
		"1. Get sinus!\n2. Get cosinus!\n" <<
		"3. Get result of an Arithmetic operation!\n" <<
		"4. Оставь меня, старушка, я в печали...\n\nYour choice: ";

	int choice = 0;
	cin >> choice;

	float result = 0;

	int check = SUCCESS;
	if (choice == 1 || choice == 2) {
		goToSinCos(result, choice);
	}
	else if (choice == 3) {
		check = goToAriphmetics(result);
	}

	if (!check)
		cout << "Result of this operation is: " << result;

	return check;
}
