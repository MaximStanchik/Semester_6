package org.Stanchik;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public class Schnorr {
    private final BigInteger p;
    private final BigInteger q;
    private final BigInteger g;
    private BigInteger x;
    private final BigInteger y;
    public Schnorr() {
        SecureRandom random = new SecureRandom();
        this.p = BigInteger.valueOf(48731);
        this.q = BigInteger.valueOf(443);
        this.g = BigInteger.valueOf(11444);

        do {
            this.x = BigInteger.valueOf(random.nextInt(q.intValue() - 1) + 1);
        } while (this.x.compareTo(BigInteger.ONE) < 0 || this.x.compareTo(this.q) >= 0);

        this.y = this.g.modPow(this.x, this.p);
    }
    public BigInteger[] getPublicKey() {
        return new BigInteger[]{this.p, this.q, this.g, this.y};
    }

    public BigInteger[] createDigitalSignature(String message) {
        SecureRandom random = new SecureRandom();
        BigInteger k;
        do {
            k = BigInteger.valueOf(random.nextInt(q.intValue() - 2) + 2);
        } while (k.compareTo(BigInteger.ONE) <= 0 || k.compareTo(q) >= 0);
        BigInteger a = g.modPow(k, p);
        message += a.toString();
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(message.getBytes("UTF-8"));
            BigInteger hashBigInt = new BigInteger(1, hash);
            BigInteger r = hashBigInt;
            BigInteger s = k.add(x.multiply(hashBigInt)).mod(q);
            return new BigInteger[]{r, s};
        }
        catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean verifyDigitalSignature(String message, BigInteger[] digitalSignature) {
        try {
            BigInteger r = digitalSignature[0];
            BigInteger s = digitalSignature[1];
            BigInteger a = g.modPow(s, p).multiply(y.modPow(q.subtract(r), p)).mod(p);

            String combined = message + a.toString();

            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] receivedHash = digest.digest(combined.getBytes("UTF-8"));
            BigInteger receivedHashBigInt = new BigInteger(1, receivedHash);

            return r.equals(receivedHashBigInt);
        }
        catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return false;
        }
    }


}
