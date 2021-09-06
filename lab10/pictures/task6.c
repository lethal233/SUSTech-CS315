#include <stdio.h>
#include <openssl/bn.h>

#define NBITS 256

void printBN(char *msg, BIGNUM * a)
{
	char * number_str = BN_bn2hex(a);
	printf("%s %s\n", msg, number_str);
	OPENSSL_free(number_str);
}

int main ()
{
	BN_CTX *ctx = BN_CTX_new();
	
	BIGNUM *M = BN_new();
	BIGNUM *e = BN_new();
	BIGNUM *d = BN_new();
	BIGNUM *n = BN_new();
	BIGNUM *S = BN_new();

	BN_hex2bn(&n, "00c70e6c3f23937fcc70a59d20c30e533f7ec04ec29849ca47d523ef03348574c8a3022e465c0b7dc9889d4f8bf0f89c6c8c5535dbbff2b3eafbe356e74a46d91322ca36d59bc1a8e3964393f20cbce6f9e6e899c86348787f5736691a191d5ad1d47dc29cd47fe18012ae7aea88ea57d8ca0a0a3a1249a262197a0d24f737ebb473927b05239b12b5ceeb29dfa41402b901a5d4a69c436488def87efee3f51ee5fedca3a8e46631d94c25e918b9895909aee99d1c6d370f4a1e352028e2afd4218b01c445ad6e2b63ab926b610a4d20ed73ba7ccefe16b5db9f80f0d68b6cd908794a4f7865da92bcbe35f9b3c4f927804eff9652e60220e10773e95d2bbdb2f1");
	BN_hex2bn(&e, "010001");
	BN_hex2bn(&S, "bcdc02d0d9de8cc5e2d9fe4defbad1228b34425984923182d50abc4035db06b2136ec8cf01f15fc0e7b734373aa808f29f32d5f920809fbfd3ff6d479c76d1cbf1c7f1db833337e53f18a700e2bddafe4f29455787785f53850db3a35c6393fee0265ef9928ced76a35f39e6220536c53273d0cd51aac8c31fa8ac5b26b7d99460088181d3f5b77a4fdf39215833b51563028cb822ead97a74ec5a41bb3da7c9e24021ea341a4aed736046c7963b99e4f5e59213cef43c16d5620fba0e99ae5ca52d34d89a55b75844ce0138bbd0762c64de8d002b99e2dd6110edc0b05ee5aa3740d87c13375d055f61ee694bdfe4eccff8f2aea55f552b0f31f2640a53abeb");
	BN_mod_exp(M, S, e, n, ctx);
	printBN("M = ", M);

	return 0;
}
