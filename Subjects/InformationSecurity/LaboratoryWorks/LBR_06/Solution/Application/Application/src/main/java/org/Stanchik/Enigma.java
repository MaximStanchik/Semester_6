package org.Stanchik;

import java.util.HashMap;
import java.util.Map;

enum Operation {
    ENCRYPT,
    DECRYPT,
}

public class Enigma {
    public static final String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    public static final String alphabetRightRotor  =  "LEYJVCNIXWPBQMDRTAKZGFUHOS";;
    public static final String alphabetMiddleRotor = "BDFHJLCPRTXVZNYEIWGAKMUSQO";
    public static final String alphabetLeftRotor   = "FSOKANUERHMBTIYCWLQPZXVGJD";

    Map<Character, Character> alphabetReflector;
    int length = alphabet.length();

    private int rotorRightCurrentPosition =  0;
    private int rotorMiddleCurrentPosition = 0;
    private int rotorLeftCurrentPosition  =  0;

    private int rotorRightTotalOffsets =  0;
    private int rotorMiddleTotalOffsets = 0;
    private int rotorLeftTotalOffsets  =  0;

    private int rotorRightFullRotations =  0;
    private int rotorMiddleFullRotations = 0;
    private int rotorLeftFullRotations  =  0;

    private int rotorRightStep =  4;
    private int rotorMiddleStep = 0;
    private int rotorLeftStep  =  0;
    private static Map<Character, Character> fillTheRelector() {
        Map<Character, Character> reflector = new HashMap<>();
        reflector.put('A', 'F');
        reflector.put('B', 'V');
        reflector.put('C', 'P');
        reflector.put('D', 'J');
        reflector.put('E', 'I');
        reflector.put('G', 'O');
        reflector.put('H', 'Y');
        reflector.put('K', 'R');
        reflector.put('L', 'Z');
        reflector.put('M', 'X');
        reflector.put('N', 'W');
        reflector.put('T', 'Q');
        reflector.put('S', 'U');

        return reflector;
    }

    public Enigma(int rightRotorPosition, int middleRotorPosition, int leftRotorPosition) {
        if (rightRotorPosition >= 0 && rightRotorPosition < length && middleRotorPosition >= 0 && middleRotorPosition < length &&  leftRotorPosition  >= 0 && leftRotorPosition  <  length) {
            rotorRightCurrentPosition = rightRotorPosition;
            rotorMiddleCurrentPosition = middleRotorPosition;
            rotorLeftCurrentPosition  = leftRotorPosition;
        }
        else {
            throw new IllegalArgumentException("Позиции роторов должны быть от 0 до " + (length - 1));
        }

        alphabetReflector = fillTheRelector();
    }

    public char[] Encrypt(char[] openText) {
        StringBuilder sb = new StringBuilder();

        for (char letter : openText) {
            if (isLetterInAlphabet(letter)) {
                char encryptedLetter = processLetter(letter, Operation.ENCRYPT);
                sb.append(encryptedLetter);
            } else {
                sb.append(letter);
            }
        }
        return sb.toString().toCharArray();
    }

    public char[] Decrypt(char[] openText) {
        StringBuilder sb = new StringBuilder();

        for (char letter : openText) {
            if (isLetterInAlphabet(letter)) {
                char decryptedLetter = processLetter(letter, Operation.DECRYPT);
                sb.append(decryptedLetter);
            } else {
                sb.append(letter);
            }
        }
        return sb.toString().toCharArray();
    }

    private boolean isLetterInAlphabet(char letter) {
        return alphabet.indexOf(letter) != -1;
    }

    private char processLetter(char letter, Operation operation) {
        char letterAfterRightRotor = (operation == Operation.ENCRYPT)
                ? encryptWithRotor(letter, alphabet, alphabetRightRotor, rotorRightCurrentPosition)
                : decryptWithRotor(letter, alphabet, alphabetRightRotor, rotorRightCurrentPosition);

        char letterAfterMiddleRotor = (operation == Operation.ENCRYPT)
                ? encryptWithRotor(letterAfterRightRotor, alphabet, alphabetMiddleRotor, rotorMiddleCurrentPosition)
                : decryptWithRotor(letterAfterRightRotor, alphabet, alphabetMiddleRotor, rotorMiddleCurrentPosition);

        char letterAfterLeftRotor = (operation == Operation.ENCRYPT)
                ? encryptWithRotor(letterAfterMiddleRotor, alphabet, alphabetLeftRotor, rotorLeftCurrentPosition)
                : decryptWithRotor(letterAfterMiddleRotor, alphabet, alphabetLeftRotor, rotorLeftCurrentPosition);

        char letterAfterReflector = encryptWithReflector(letterAfterLeftRotor);

        char letterAfterLeftRotorBackwards = (operation == Operation.ENCRYPT)
                ? encryptWithRotor(letterAfterReflector, alphabetLeftRotor, alphabet, rotorLeftCurrentPosition)
                : decryptWithRotor(letterAfterReflector, alphabetLeftRotor, alphabet, rotorLeftCurrentPosition);

        char letterAfterMiddleRotorBackwards = (operation == Operation.ENCRYPT)
                ? encryptWithRotor(letterAfterLeftRotorBackwards, alphabetMiddleRotor, alphabet, rotorMiddleCurrentPosition)
                : decryptWithRotor(letterAfterLeftRotorBackwards, alphabetMiddleRotor, alphabet, rotorMiddleCurrentPosition);

        char letterAfterRightRotorBackwards = (operation == Operation.ENCRYPT)
                ? encryptWithRotor(letterAfterMiddleRotorBackwards, alphabetRightRotor, alphabet, rotorRightCurrentPosition)
                : decryptWithRotor(letterAfterMiddleRotorBackwards, alphabetRightRotor, alphabet, rotorRightCurrentPosition);

        updateRotorPositions();
        return letterAfterRightRotorBackwards;
    }

    private void updateRotorPositions() {
        rotorRightTotalOffsets += rotorRightStep;
        rotorRightCurrentPosition = rotorRightTotalOffsets % length;

        if (rotorRightTotalOffsets / length > 0) {
            rotorRightFullRotations = rotorRightTotalOffsets / length;
            rotorMiddleTotalOffsets = rotorRightFullRotations * rotorMiddleStep;
            rotorMiddleCurrentPosition = rotorMiddleTotalOffsets % length;
        }
        if (rotorMiddleTotalOffsets / length > 0) {
            rotorMiddleFullRotations = rotorMiddleTotalOffsets / length;
            rotorLeftTotalOffsets = rotorMiddleFullRotations * rotorLeftStep;
            rotorLeftCurrentPosition = rotorLeftTotalOffsets % length;
        }
        if (rotorLeftTotalOffsets / length > 0) {
            rotorLeftFullRotations = rotorLeftTotalOffsets / length;
        }
    }

    private char encryptWithRotor(char letter, String alphabet, String alphabetEncryption, int offset) {
        int index = alphabet.indexOf(letter);
        int indexEncrypted = (index + offset) % length;
        return alphabetEncryption.charAt(indexEncrypted);
    }

    private char decryptWithRotor(char letter, String alphabet, String alphabetEncryption, int offset) {
        int index = alphabet.indexOf(letter);
        int indexEncrypted = (index - offset + length) % length;
        return alphabetEncryption.charAt(indexEncrypted);
    }

    private char encryptWithReflector(char letter) {
        if (alphabetReflector.containsKey(letter)) {
            return alphabetReflector.get(letter);
        }
        else if (alphabetReflector.containsValue(letter)) {
            return alphabetReflector.entrySet().stream().filter(entry -> entry.getValue() == letter).map(Map.Entry::getKey).findFirst().orElse(letter);
        }
        else {
            return letter;
        }
    }

}