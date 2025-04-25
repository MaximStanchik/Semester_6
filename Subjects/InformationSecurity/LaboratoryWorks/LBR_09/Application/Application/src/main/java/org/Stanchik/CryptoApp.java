package org.Stanchik;

import javax.crypto.Cipher;
import java.math.BigInteger;
import java.security.*;
import java.util.Base64;

public class CryptoApp {
    private KeyPair rsaKeyPair;

    private BigInteger p;
    private BigInteger g;
    private BigInteger x;
    private BigInteger y;

    public CryptoApp() throws NoSuchAlgorithmException {
        KeyPairGenerator rsaKeyGen = KeyPairGenerator.getInstance("RSA");
        rsaKeyGen.initialize(2048);
        rsaKeyPair = rsaKeyGen.generateKeyPair();

        generateElGamalKeys(2048);
    }

    private void generateElGamalKeys(int bitLength) {
        SecureRandom random = new SecureRandom();
        p = BigInteger.probablePrime(bitLength, random);
        g = BigInteger.valueOf(2);
        x = new BigInteger(bitLength, random).mod(p.subtract(BigInteger.ONE));
        y = g.modPow(x, p);
    }

    public String rsaEncrypt(String plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, rsaKeyPair.getPublic());
        byte[] encryptedBytes = cipher.doFinal(plaintext.getBytes());
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    public String rsaDecrypt(String ciphertext) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, rsaKeyPair.getPrivate());
        byte[] decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(ciphertext));
        return new String(decryptedBytes);
    }

    public BigInteger[] elGamalEncrypt(String plaintext) {
        BigInteger m = new BigInteger(1, plaintext.getBytes());
        SecureRandom random = new SecureRandom();
        BigInteger k = new BigInteger(2048, random).mod(p.subtract(BigInteger.ONE));
        BigInteger c1 = g.modPow(k, p);
        BigInteger c2 = m.multiply(y.modPow(k, p)).mod(p);
        return new BigInteger[]{c1, c2};
    }

    public String elGamalDecrypt(BigInteger c1, BigInteger c2) {
        BigInteger s = c1.modPow(x, p);
        BigInteger m = c2.multiply(s.modInverse(p)).mod(p);
        return new String(m.toByteArray());
    }

    public static void main(String[] args) {
        try {
            CryptoApp cryptoApp = new CryptoApp();
            String plaintext = "Maxim Stanchik Andrevich";
            System.out.println("Изначальный текст: " + plaintext);
            System.out.println("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");

            long startTime = System.nanoTime();
            String rsaCiphertext = cryptoApp.rsaEncrypt(plaintext);
            long endTime = System.nanoTime();
            System.out.println("RSA Encrypted: " + rsaCiphertext);
            System.out.println("RSA Decrypted: " + cryptoApp.rsaDecrypt(rsaCiphertext));
            System.out.println("RSA Time: " + (endTime - startTime) + " ns");

            System.out.println("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");

            startTime = System.nanoTime();
            BigInteger[] elGamalCiphertext = cryptoApp.elGamalEncrypt(plaintext);
            endTime = System.nanoTime();
            System.out.println("ElGamal Encrypted: c1 = " + elGamalCiphertext[0] + ", c2 = " + elGamalCiphertext[1]);
            System.out.println("ElGamal Decrypted: " + cryptoApp.elGamalDecrypt(elGamalCiphertext[0], elGamalCiphertext[1]));
            System.out.println("ElGamal Time: " + (endTime - startTime) + " ns");

            System.out.println("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}