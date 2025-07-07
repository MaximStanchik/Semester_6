const PORT = 3000;

const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

app.post('/rpc', (req, res) => {
  const { jsonrpc, method, params, id } = req.body;

  if (jsonrpc !== '2.0' || typeof method !== 'string' || id === undefined) {
    return res.status(400).json({
      jsonrpc: '2.0',
      error: { code: -32600, message: 'Invalid Request' },
      id: null
    });
  }

  const methods = {
    sum: (args) => {
      if (!Array.isArray(args) || args.some(v => typeof v !== 'number')) {
        throw { code: -32602, message: 'Invalid params: sum expects array of numbers' };
      }
      return args.reduce((acc, val) => acc + val, 0);
    },

    mul: (args) => {
      if (!Array.isArray(args) || args.some(v => typeof v !== 'number')) {
        throw { code: -32602, message: 'Invalid params: mul expects array of numbers' };
      }
      return args.reduce((acc, val) => acc * val, 1);
    },

    div: ([x, y]) => {
      if (typeof x !== 'number' || typeof y !== 'number') {
        throw { code: -32602, message: 'Invalid params: div expects two numbers' };
      }
      if (y === 0) {
        throw { code: -32000, message: 'Division by zero' };
      }
      return x / y;
    },

    proc: ([x, y]) => {
      if (typeof x !== 'number' || typeof y !== 'number') {
        throw { code: -32602, message: 'Invalid params: proc expects two numbers' };
      }
      if (y === 0) {
        throw { code: -32000, message: 'Division by zero in proc' };
      }
      return (x / y) * 100;
    }
  };

  try {
    if (!methods[method]) {
      throw { code: -32601, message: 'Method not found' };
    }

    const result = methods[method](params);

    res.json({
      jsonrpc: '2.0',
      result,
      id
    });
  } catch (err) {
    res.status(400).json({
      jsonrpc: '2.0',
      error: {
        code: err.code || -32000,
        message: err.message || 'Server error'
      },
      id
    });
  }
});

app.listen(PORT, () => {
  console.log(`JSON-RPC сервер запущен на http://localhost:${PORT}/rpc`);
});
