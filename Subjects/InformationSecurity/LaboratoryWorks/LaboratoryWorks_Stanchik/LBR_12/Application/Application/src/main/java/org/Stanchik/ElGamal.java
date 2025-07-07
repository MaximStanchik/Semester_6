package org.Stanchik;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import static org.Stanchik.MathUtils.*;

public class ElGamal {
    private final BigInteger p;
    private final BigInteger g;
    private final BigInteger x;
    private final BigInteger y;
    public ElGamal() {
        SecureRandom random = new SecureRandom();

        this.p = generatePrimeNumber(512);
        this.g = generateCoprimeNumber(this.p);

        this.x = BigInteger.valueOf(2).add(new BigInteger(1, random).mod(this.p.subtract(BigInteger.ONE).subtract(BigInteger.TWO)));
        this.y = this.g.modPow(this.x, this.p);
    }

    public BigInteger[] getPublicKey() {
        return new BigInteger[]{this.p, this.g, this.y};
    }
    public BigInteger[] createDigitalSignature(String message) {
        BigInteger[] digitalSignI = new BigInteger[2];
        SecureRandom random = new SecureRandom();

        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(message.getBytes("UTF-8"));
            BigInteger hash = new BigInteger(1, hashBytes);

            do {
                BigInteger k;
                do {
                    k = new BigInteger(p.bitLength() - 1, random).mod(p.subtract(BigInteger.TWO)).add(BigInteger.TWO);
                } while (!isCoprime(k, p.subtract(BigInteger.ONE)));

                digitalSignI[0] = g.modPow(k, p);
                BigInteger temp = hash.subtract(x.multiply(digitalSignI[0])).mod(p.subtract(BigInteger.ONE));
                temp = temp.multiply(k.modInverse(p.subtract(BigInteger.ONE))).mod(p.subtract(BigInteger.ONE));

                if (temp.compareTo(BigInteger.ZERO) < 0) {
                    temp = p.subtract(BigInteger.ONE).subtract(temp.abs());
                }
                digitalSignI[1] = temp;
            } while (digitalSignI[1].equals(BigInteger.ZERO));

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }

        return digitalSignI;
    }

    public boolean verifyDigitalSignature(String message, BigInteger[] digitalSignature) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(message.getBytes("UTF-8"));
            BigInteger hashBigInt = new BigInteger(1, hash);

            BigInteger leftPart = g.modPow(hashBigInt, p);

            BigInteger rightPart = y.modPow(digitalSignature[0], p)
                    .multiply(digitalSignature[0].modPow(digitalSignature[1], p))
                    .mod(p);

            return leftPart.equals(rightPart);
        }
        catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return false;
        }
        catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }
}
