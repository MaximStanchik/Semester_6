package org.Stanchik.DES_EDE2;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class DES_EDE2 {
    private static final String ALGORITHM = "DES/ECB/PKCS5Padding";
    public String encryptMes(byte[] firstKey, byte[] secondKey, String text) throws UnsupportedEncodingException {
        byte[] encrypted = desEncrypt(firstKey, text.getBytes("UTF-8"));
        byte[] decrypted = desDecrypt(secondKey, encrypted);
        encrypted = desEncrypt(firstKey, decrypted);
        return Base64.getEncoder().encodeToString(encrypted);
    };
    public String decryptMes (byte[] firstKey, byte[] secondKey, String text) throws UnsupportedEncodingException {
        byte[] encrypted = Base64.getDecoder().decode(text);
        byte[] decrypted = desDecrypt(firstKey, encrypted);
        encrypted = desEncrypt(secondKey, decrypted);
        return new String(desDecrypt(firstKey, encrypted), "UTF-8");
    };

    private byte[] desEncrypt(byte[] key, byte[] data) {
        try {
            SecretKeySpec secretKey = new SecretKeySpec(key, "DES");
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            return cipher.doFinal(data);
        }
        catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            throw new RuntimeException("Encryption error", e);
        }
        catch (NoSuchPaddingException e) {
            e.printStackTrace();
            throw new RuntimeException("Encryption error", e);
        }
        catch (InvalidKeyException e) {
            e.printStackTrace();
            throw new RuntimeException("Encryption error", e);
        }
        catch (IllegalBlockSizeException e) {
            e.printStackTrace();
            throw new RuntimeException("Encryption error", e);
        }
        catch (BadPaddingException e) {
            e.printStackTrace();
            throw new RuntimeException("Encryption error", e);
        }
    }
    private byte[] desDecrypt(byte[] key, byte[] data) {
        try {
            SecretKeySpec secretKey = new SecretKeySpec(key, "DES");
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, secretKey);
            return cipher.doFinal(data);
        }
        catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            throw new RuntimeException("Decryption error", e);
        }
        catch (NoSuchPaddingException e) {
            e.printStackTrace();
            throw new RuntimeException("Decryption error", e);
        }
        catch (InvalidKeyException e) {
            e.printStackTrace();
            throw new RuntimeException("Decryption error", e);
        }
        catch (IllegalBlockSizeException e) {
            e.printStackTrace();
            throw new RuntimeException("Decryption error", e);
        }
        catch (BadPaddingException e) {
            e.printStackTrace();
            throw new RuntimeException("Decryption error", e);
        }
    }
};
