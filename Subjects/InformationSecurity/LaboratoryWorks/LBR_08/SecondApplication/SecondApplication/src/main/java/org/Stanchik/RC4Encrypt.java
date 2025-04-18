package org.Stanchik;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RC4Encrypt {
    public String process(String data, int key[]) {
        Map<Integer, Integer> box = new HashMap<>();

        for (int i = 0; i < 256; i++) {
            box.put(i, i);
        }

        for (int i = 0; i < 256; i++) {
            int j = (box.get(i) + key[i % key.length]) % 256;
            int temp = box.get(i);
            box.put(i, box.get(j));
            box.put(j, temp);
        }

        StringBuilder result = new StringBuilder();
        List<Character> out = new ArrayList<>();
        int x = 0;

        for (char c : data.toCharArray()) {
            x = (x + 1) % 256;
            int y = box.get(x);
            out.add((char) (c ^ box.get((box.get(x) + box.get(y)) % 256)));
        }

        for (char c : out) {
            result.append(c);
        }

        return result.toString();
    }

}
