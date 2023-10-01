const express = require('express');
const bodyParser = require('body-parser');
require('isomorphic-fetch');

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res, next) => {
  const healthcheck = {
        uptime: process.uptime(),
        message: 'OK',
        timestamp: Date.now()
    };
    try {
        res.send(healthcheck);
    } catch (error) {
        healthcheck.message = error;
        res.status(503).send();
    }
})

app.post('/neworder', bodyParser.json(), (req, res) => {
    const data = req.body.data;
    const orderId = data.orderId;
    console.log("Got a new order! Order ID: " + orderId);
    res.status(200).send("Got a new order! Order ID: " + orderId);
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Node App listening on port ${port}!`));
