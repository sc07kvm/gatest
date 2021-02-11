#include <stdio.h>

#include <pcre.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>

int main() {
	const char *error;
	int erroffset;
	char *s_re = "123.*123";
	pcre *re;

	printf("PCRE version: %s\n", pcre_version());
	re = pcre_compile(s_re, PCRE_CASELESS, &error, &erroffset, NULL);
	if(!re) {
		printf("Failed regex compile %s at offset %d: %s\n", s_re, erroffset, error);
		return 1;
	}
	printf("OpenSSL version: %s\n", OpenSSL_version(OPENSSL_VERSION));

	return 0;
}