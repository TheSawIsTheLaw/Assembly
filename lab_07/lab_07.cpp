#include <iostream>

extern "C" {
	void cpy(char *to, char *from, size_t len);
}

int main() {
	char testString[] = "Wow, such a program\0";
	size_t result = 0;

	__asm {
		mov ECX, -1
		mov AL, 0
		lea DI, [testString]
		repne scasb
		mov EAX, -1
		sub EAX, ECX
		dec EAX
		mov result, EAX
	}
	std::cout<< result;

	char copied[666];
	size_t saved;

	cpy(copied, testString, result);
	__asm mov saved, ECX

	std::cout << saved;

	return 0;
}