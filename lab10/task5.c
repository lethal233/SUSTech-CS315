#include <stdio.h>
#include <openssl/bn.h>
#define NBITS 512
void print_BN(char *msg, BIGNUM * a)
{
/* Use BN_bn2hex(a) for hex string
* Use BN_bn2dec(a) for decimal string */
char * number_str = BN_bn2hex(a);

printf("%s %s\n", msg, number_str);
OPENSSL_free(number_str);
}
int main ()
{
BN_CTX *ctx = BN_CTX_new();
BIGNUM *n = BN_new();
BIGNUM *e = BN_new();
BIGNUM *d = BN_new();
BIGNUM *S = BN_new();
BIGNUM *M = BN_new();
BIGNUM *C = BN_new();

BN_hex2bn(&n,"AE1CD4DC432798D933779FBD46C6E1247F0CF1233595113AA51B450F18116115");
BN_hex2bn(&e,"010001");
BN_hex2bn(&S,"643D6F34902D9C7EC90CB0B2BCA36C47FA37165C0005CAB026C0542CBDB6803F");
BN_hex2bn(&M,"4120746f702073656372657421");
BN_hex2bn(&d,"74D806F9F3A62BAE331FFE3F0A68AFE35B3D2E4794148AACBC26AA381CD7D30D");

BN_mod_exp(C,S,e,n,ctx);
print_BN("C = ", C);
return 0;
}
