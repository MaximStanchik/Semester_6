package org.Stanchik;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import static org.Stanchik.MathUtils.generateCoprimeNumber;
import static org.Stanchik.MathUtils.generatePrimeNumber;

public class RSA {
    private BigInteger p;
    private final BigInteger q;
    private final BigInteger n;
    private final BigInteger fi;
    private final BigInteger e;
    private final BigInteger d;
    public RSA() {
        this.p = generatePrimeNumber(512);
        this.q = generatePrimeNumber(512);

        this.n = this.p.multiply(this.q);
        this.fi = this.p.subtract(BigInteger.ONE).multiply(this.q.subtract(BigInteger.ONE));
        this.e = generateCoprimeNumber(this.fi);
        this.d = e.modInverse(fi);
    }

    public BigInteger[] getPublicKey() {
        return new BigInteger[]{this.e, this.n};
    }

    public BigInteger createDigitalSignature(String text) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(text.getBytes("UTF-8"));
            BigInteger hashBigInt = new BigInteger(1, hash);
            return hashBigInt.modPow(d, n);
        }
        catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
        catch (java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean verifyDigitalSignature(String text, BigInteger digitalSign) {
        try {
            BigInteger signBytes = digitalSign.modPow(e, n);
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] receivedHash = digest.digest(text.getBytes("UTF-8"));
            BigInteger receivedHashBigInt = new BigInteger(1, receivedHash);
            return receivedHashBigInt.equals(signBytes);
        }
        catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return false;
        }
        catch (java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
