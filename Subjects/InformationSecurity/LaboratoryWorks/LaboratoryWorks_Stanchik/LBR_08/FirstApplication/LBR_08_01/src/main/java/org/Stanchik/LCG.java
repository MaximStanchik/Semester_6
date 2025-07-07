package org.Stanchik;

import java.util.ArrayList;
import java.util.List;

public class LCG {
    public List<Integer> lcg(int seed, int sequenceLength, int a, int c, int n) {
        List<Integer> sequence = new ArrayList<>();

        for (int i = 0; i < sequenceLength; i++) {
            sequence.add(seed);
            seed = (a * seed + c) % n;
        }

        return sequence;
    }
}
