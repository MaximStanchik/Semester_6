const fs = require('fs');
const path = require('path');

const wasmPath = path.join(__dirname, 'functions.wasm');
const wasmBuffer = fs.readFileSync(wasmPath);

(async () => {
  const { instance } = await WebAssembly.instantiate(wasmBuffer);
  const { sum, mul, sub } = instance.exports;

  console.log(`sum(7, 4) = ${sum(7, 4)}`);
  console.log(`mul(7, 4) = ${mul(7, 4)}`);
  console.log(`sub(7, 4) = ${sub(7, 4)}`);
})();
