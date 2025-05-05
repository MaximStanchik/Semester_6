package org.Stanchik;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import static org.Stanchik.MathUtils.generateCoprimeNumber;
import static org.Stanchik.MathUtils.generatePrimeNumber;

public class ElGamal {
    private final BigInteger p;
    private final BigInteger g;
    private final BigInteger x;
    private final BigInteger y;
    public ElGamal() {
        SecureRandom random = new SecureRandom();

        this.p = generatePrimeNumber(100);
        this.g = generateCoprimeNumber(this.p);

        this.x = BigInteger.valueOf(2).add(new BigInteger(1, random).mod(this.p.subtract(BigInteger.ONE).subtract(BigInteger.TWO)));
        this.y = this.g.modPow(this.x, this.p);
    }

    public BigInteger[] getPublicKey() {
        return new BigInteger[]{this.p, this.g, this.y};
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
