#include <iostream>

extern "C" {
	void testAsm(); // подключение в код на Си/Си++ функции
	// на другом языке программирования,
	// выполненной в соответствии с соглашениями
	// о вызовах Си
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
	std::cout << result;
	return 0;
}