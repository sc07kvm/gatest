#include <stdio.h>

#include <openssl/err.h>
#include <openssl/ssl.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#include <pcre.h>

#include "main.h"

int main() {
  next();
  printf("PCRE version: %s\n", pcre_version());
  printf("OpenSSL version: %s\n", OpenSSL_version(OPENSSL_VERSION));
  return 0;
}