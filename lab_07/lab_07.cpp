#include <iostream>

extern "C" {
	void cpy();
}

int main() {
	char testString[] = "Wow, such a program\0";
	int result = 0;

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

	__asm {
		lea EAX, [testString]
		push EAX
		lea EAX, [copied]
		push EAX
	}
	cpy();
	__asm {
		pop EAX
		pop EAX
	}

	std::cout << copied;

	return 0;
}