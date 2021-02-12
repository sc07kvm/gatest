#include <stdio.h>

#include <openssl/err.h>
#include <openssl/ssl.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#include <pcre.h>

int main() {
  volatile int *arr;
  const char *error;
  int erroffset;
  char *s_re = "123.*123";
  volatile pcre *re;

  printf("PCRE version: %s\n", pcre_version());
  re = pcre_compile(s_re, PCRE_CASELESS, &error, &erroffset, NULL);
  if (!re) {
    printf("Failed regex compile %s at offset %d: %s\n", s_re, erroffset,
           error);
    return 1;
  }
  printf("OpenSSL version: %s\n", OpenSSL_version(OPENSSL_VERSION));
  arr = (int *)malloc(sizeof(int) * 100);
  printf("%p %p\n", re, arr);

  return 0;
}