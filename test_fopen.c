
#include <stdio.h>
#include <errno.h>
#include <string.h>

int main() {
    FILE *fp = fopen("test-ssl-keylog/logs", "a");
    if (fp == NULL) {
        printf("fopen failed: %s\n", strerror(errno));
    } else {
        printf("fopen succeeded\n");
        fclose(fp);
    }
    return 0;
}
