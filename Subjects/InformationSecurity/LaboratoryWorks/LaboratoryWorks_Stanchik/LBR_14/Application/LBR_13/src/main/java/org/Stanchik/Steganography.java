package org.Stanchik;

import org.apache.commons.imaging.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class Steganography {

    public enum Method {
        ROWS, COLS
    }

    public static void getColorMatrix(String imagePath, String outputPath)
            throws IOException, ImageReadException, ImageWriteException {
        BufferedImage image = Imaging.getBufferedImage(new File(imagePath));
        BufferedImage newImage = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_INT_ARGB);

        for (int y = 0; y < image.getHeight(); y++) {
            for (int x = 0; x < image.getWidth(); x++) {
                int rgb = image.getRGB(x, y);
                int red = (rgb >> 16) & 0xFF;
                int green = (rgb >> 8) & 0xFF;
                int blue = rgb & 0xFF;

                int newRed = (red & 0x01) * 255;
                int newGreen = (green & 0x01) * 255;
                int newBlue = (blue & 0x01) * 255;

                int newColor = (newRed << 16) | (newGreen << 8) | newBlue | 0xFF000000;
                newImage.setRGB(x, y, newColor);
            }
        }

        Imaging.writeImage(newImage, new File(outputPath), ImageFormats.BMP);
    }


    public static void embedMessage(String containerPath, String message, String outputImagePath, Method method) throws IOException, ImageReadException, ImageWriteException {
        BufferedImage containerImage = Imaging.getBufferedImage(new File(containerPath));
        byte[] messageBytes = message.getBytes();
        StringBuilder messageBits = new StringBuilder();
        for (byte b : messageBytes) {
            messageBits.append(String.format("%8s", Integer.toBinaryString(b & 0xFF)).replace(' ', '0'));
        }
        int maxMessageBits = (containerImage.getWidth() * containerImage.getHeight()) * 3;
        if (messageBits.length() > maxMessageBits) {
            throw new IllegalArgumentException("Message is too large for the container");
        }
        int messageBitIndex = 0;
        int xMax, yMax;
        if (method == Method.ROWS) {
            xMax = containerImage.getWidth();
            yMax = containerImage.getHeight();
        } else {
            xMax = containerImage.getHeight();
            yMax = containerImage.getWidth();
        }
        for (int y = 0; y < yMax; y++) {
            for (int x = 0; x < xMax; x++) {
                int rgb = method == Method.ROWS ? containerImage.getRGB(x, y) : containerImage.getRGB(y, x);
                int red = (rgb >> 16) & 0xFF;
                int green = (rgb >> 8) & 0xFF;
                int blue = rgb & 0xFF;
                int newRed = red, newGreen = green, newBlue = blue;
                if (messageBitIndex < messageBits.length()) {
                    newRed = (messageBits.charAt(messageBitIndex++) == '1') ? (red | 1) : (red & ~1);
                }
                if (messageBitIndex < messageBits.length()) {
                    newGreen = (messageBits.charAt(messageBitIndex++) == '1') ? (green | 1) : (green & ~1);
                }
                if (messageBitIndex < messageBits.length()) {
                    newBlue = (messageBits.charAt(messageBitIndex++) == '1') ? (blue | 1) : (blue & ~1);
                }
                int newColor = (newRed << 16) | (newGreen << 8) | newBlue | 0xFF000000;
                if (method == Method.ROWS) {
                    containerImage.setRGB(x, y, newColor);
                } else {
                    containerImage.setRGB(y, x, newColor);
                }
                if (messageBitIndex >= messageBits.length()) {
                    break;
                }
            }
            if (messageBitIndex >= messageBits.length()) {
                break;
            }
        }
        Imaging.writeImage(containerImage, new File(outputImagePath), ImageFormats.BMP);
    }

    public static String extractMessage(String imagePath, Method method) throws IOException, ImageReadException {
        BufferedImage containerImage = Imaging.getBufferedImage(new File(imagePath));
        StringBuilder messageBits = new StringBuilder();
        int messageBitIndex = 0;
        int endZeroGroup = 0;
        int xMax, yMax;
        if (method == Method.ROWS) {
            xMax = containerImage.getWidth();
            yMax = containerImage.getHeight();
        } else {
            xMax = containerImage.getHeight();
            yMax = containerImage.getWidth();
        }
        for (int y = 0; y < yMax; y++) {
            for (int x = 0; x < xMax; x++) {
                int rgb = method == Method.ROWS ? containerImage.getRGB(x, y) : containerImage.getRGB(y, x);
                int red = (rgb >> 16) & 0xFF;
                int green = (rgb >> 8) & 0xFF;
                int blue = rgb & 0xFF;
                messageBits.append(red & 1);
                messageBitIndex++;
                if (messageBitIndex < (xMax * yMax * 3)) {
                    messageBits.append(green & 1);
                    messageBitIndex++;
                }
                if (messageBitIndex < (xMax * yMax * 3)) {
                    messageBits.append(blue & 1);
                    messageBitIndex++;
                }
                if (messageBits.length() >= 3 && messageBits.substring(messageBits.length() - 3).equals("000")) {
                    endZeroGroup++;
                } else {
                    endZeroGroup = 0;
                }
                if (endZeroGroup >= 3) {
                    break;
                }
            }
            if (endZeroGroup >= 3) {
                break;
            }
        }
        return convertBinaryToString(messageBits.toString());
    }

    private static String convertBinaryToString(String binaryString) {
        StringBuilder text = new StringBuilder();
        for (int i = 0; i < binaryString.length(); i += 8) {
            String byteString = binaryString.substring(i, Math.min(i + 8, binaryString.length()));
            int charCode = Integer.parseInt(byteString, 2);
            text.append((char) charCode);
        }
        return text.toString();
    }
}