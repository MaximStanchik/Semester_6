package org.Stanchik;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class HashGeneration {
    public String createSalt(int size) {
        SecureRandom rng = new SecureRandom();
        byte[] buff = new byte[size];
        rng.nextBytes(buff);
        return Base64.getEncoder().encodeToString(buff);
    }
    public String generateHash(String input, String algorithm, String salt) {
        return generateHash((input + salt), algorithm);
    }

    public String generateHash(String input, String algorithm) {
        try {
            MessageDigest digest = MessageDigest.getInstance(algorithm);
            byte[] hash = digest.digest(input.getBytes());

            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }
}
