const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

const cuteEmoticons = ['🐱', '🐶', '🐨', '🐼', '🦊', '🐰', '🐸', '🦋', '🐙', '🦑', '🐢', '🦆', '🐧', '🦝', '🐭'];

app.get('/', (req, res) => {
  const randomNumber = Math.floor(Math.random() * 1000000);
  const timestamp = new Date().toISOString();
  const cuteEmoticon = cuteEmoticons[Math.floor(Math.random() * cuteEmoticons.length)];
  
  const response = {
    message: 'Hello from Express in Kubernetes!',
    randomNumber: randomNumber,
    timestamp: timestamp,
    cuteEmoticon: cuteEmoticon
  };
  
  res.json(response);
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
