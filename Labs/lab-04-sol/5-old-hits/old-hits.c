#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSIZE 4096

int secret;
const unsigned char m_key[] = "<2DaTM`q8w9C@~1}t{:M#<#HV^SayYT9";
const unsigned char  m_iv[] = "V-To)F`z z'> ;m<";

/*
 * Encrypt and decrypt process taken from
 * https://wiki.openssl.org/index.php/EVP_Symmetric_Encryption_and_Decryption
 */
int proc_encrypt(unsigned char *text, int text_len, const unsigned char *key,
		 const unsigned char *iv, unsigned char *result, bool encrypt)
{
	EVP_CIPHER_CTX *ctx;

	int len;
	int rc;

	int result_len;

	/* Create and initialise the context */
	ctx = EVP_CIPHER_CTX_new();
	if(ctx == NULL)
		return -1;

	/*
	 * Initialise the encryption operation. IMPORTANT - ensure you use a key
	 * and IV size appropriate for your cipher
	 * In this example we are using 256 bit AES (i.e. a 256 bit key). The
	 * IV size for *most* modes is the same as the block size. For AES this
	 * is 128 bits
	 */
	if (encrypt)
		rc = EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv);
	else
		rc = EVP_DecryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv);
	if (rc != 1)
		return -1;

	if (encrypt) {
		rc = EVP_EncryptUpdate(ctx, result, &len, text, text_len);
	} else {
		/*
		 * Round down the length to a multiple of block size.
		 * It's possible that base64 operations add padding we should
		 * get rid of.
		 */
		text_len -= text_len % EVP_CIPHER_CTX_block_size(ctx);
		rc = EVP_DecryptUpdate(ctx, result, &len, text, text_len);
	}
	if (rc != 1)
		return -1;

	result_len = len;

	if (encrypt)
		rc = EVP_EncryptFinal_ex(ctx, result + len, &len);
	else
		rc = EVP_DecryptFinal_ex(ctx, result + len, &len);
	if (rc != 1)
		return -1;

	result_len += len;

	/* Clean up */
	EVP_CIPHER_CTX_free(ctx);

	return result_len;
}

#ifdef REENCRYPT
int encrypt_links(char enc_b64[], int enc_b64_len)
{
	char enc[BUFSIZE];
	int enc_len;

	char links[] =
		"https://www.youtube.com/watch?v=dQw4w9WgXcQ"
		"https://www.youtube.com/watch?v=3rzgrP7VA_Q"
		"https://www.youtube.com/watch?v=ZZ5LpwO-An4"
		"https://www.youtube.com/watch?v=y6120QOlsfU"
		"https://www.youtube.com/watch?v=0q6yphdZhUA"
		"https://www.youtube.com/watch?v=989-7xsRLR4"
		"https://www.youtube.com/watch?v=7yh9i0PAjck"
		"https://www.youtube.com/watch?v=04F4xlWSFh0"
		"https://www.youtube.com/watch?v=hAAlDoAtV7Y"
		"https://www.youtube.com/watch?v=NAEppFUWLfc";


	enc_len = proc_encrypt(links, sizeof(links), m_key, m_iv, enc, true);
	if (enc_len == -1) {
		fprintf(stderr, "Encountered an error while encrypting\n");
		return -1;
	}

	if (enc_b64_len < (4 * (enc_len + 2) / 3)) {
		fprintf(stderr, "Base64 buffer size too small\n");
		return -1;
	}

	enc_len = EVP_EncodeBlock(enc_b64, enc, enc_len);
	if (enc_len == -1) {
		fprintf(stderr, "Error encoding code to base64\n");
		return -1;
	}

	printf("Encrypted links are: \n");
	printf("%s\n", enc_b64);

	return 0;
}
#endif /* REENCRYPT */

int validate(int guess)
{
	return guess == (secret + 1337);
}

int show_link(int guess)
{
	unsigned char enc_b64[BUFSIZE] =
		"cpU8QtmoUqPOIRUfP26ybdYcTCaN9B+yvHKWsAskKrwFBiR5QU6Yyz/pY+fRnQ"
		"lFiKdKZ6xFg6Z5HsuFyuInEYmuIQbkfAQcO+yFi0IF9frQ/RWn5DLEnWIuFWsB"
		"xIkTWm9FdLjBHtKzfXIM9FNRimqDnJXvpoOxjueFVkb48fH7G6Qze529fNFvXs"
		"nDfZjXoT8cOmHHZ1ttAOb1K8Y4fwcnZ1Zit6MfzF6erZUxLUxetpfa3gR9CyFF"
		"eFIpG+3GyM6Wk8IrM1JcdGkhCjqzTFOh5gDhH4UWMXiJk00V9DlfI2feSWHdUF"
		"OqXKxBBi6C8iEy6/ndX/RoNxIkMsgMiqYlRpMtMnKiu43ecyXW7w7JuxTBxAAa"
		"8tpNa2g/eOI1VPL9yrKu6jGVHF0CUVbWTkC+s6ZwcossIiL+Pbmd9mIXacdvTU"
		"yTp12VsEVSo8FLvleFWZnm5pmBoMJzwBRHUgsjbKNbkraRj9Yv+Dqw8yMnPxoM"
		"TCXr8uvRQplBRTAf00SweM+b2t4vxraCLzMuy1B8Qo5B6xaVX6N3zSA2Os0iWI"
		"vXem4IdIQOAuUJFEqn";
	int link_len = sizeof("https://www.youtube.com/watch?v=XXXXXXXXXX");

	unsigned char enc[BUFSIZE], dec[BUFSIZE];
	int dec_len, enc_len;

	unsigned char *link;
	int link_cnt, link_idx;

#ifdef REENCRYPT
	int rc;

	memset(enc_b64, 0, BUFSIZE);

	rc = encrypt_links(enc_b64, BUFSIZE);
	if (rc == -1) {
		fprintf(stderr, "Failed to encrypt links\n");
		return -1;
	}
#endif /* REENCRYPT */

	enc_len = EVP_DecodeBlock(enc, enc_b64, strlen((char *) enc_b64));
	if (enc_len == -1) {
		fprintf(stderr, "Failed to decode base64 text\n");
		ERR_print_errors_fp(stderr);
		return -1;
	}

	dec_len = proc_encrypt(enc, enc_len, m_key, m_iv, dec, false);
	if (dec_len == -1) {
		fprintf(stderr, "Failed to decrypt links\n");
		ERR_print_errors_fp(stderr);
		return -1;
	}

	link_cnt = strlen((char *)dec) / link_len;
	link_idx = random() % link_cnt;

	link = dec + link_idx * link_len;
	link[link_len] = '\0';

	if (validate(guess)) {
		printf("Congrats! Here's your link: %s\n", link);
		return 0;
	} else {
		printf("Better luck next time!\n");
		return 1;
	}
}

int main(void)
{
	int guess;
	int rc;

	srandom(time(NULL));
	secret = random();

	printf("Enter your guessed secret (int): ");
	fflush(stdout);
	scanf("%d", &guess);

	if (!validate(guess)) {
		printf("This is incorrect\n");
		return 1;
	}

	rc = show_link(guess);

	return rc;
}

