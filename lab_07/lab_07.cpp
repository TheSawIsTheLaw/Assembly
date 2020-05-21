#include <iostream>

extern "C" {
	void cpy(char *to, char *from, size_t len);
}

int main() {
	char testString[] = "Wow, such a programm";
	std::cout << testString << std::endl;
	size_t result = 0;

	__asm {
		mov ECX, -1
		mov AL, 0
		lea EDI, [testString]
		repne scasb
		not ECX
		dec ECX
		mov result, ECX
	}
	std::cout<< result<< "\n";

	char copied[666] = { '\0' };
	size_t saved;

	cpy(copied, testString, result);

	std::cout << copied << "\n";

	__asm mov saved, EAX
	cpy(copied + 4, copied, 6);
	__asm mov EAX, saved

	std::cout << copied;

	return 0;
}