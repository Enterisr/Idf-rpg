const express = require('express');
const path = require('path');
const cors = require('cors');
const fs = require('fs');
const bodyParser = require('body-parser');
const moment = require('moment');
require('dotenv').config();
const app = express();
const port = process.env.PORT || 6969;
const MONGO_URL = process.env.MONGO_URI;
const Utils = require('./Utils');
const { MongoClient, ObjectId } = require('mongodb');

app.use(cors());

app.get('/newQuestion', (req, res) => {
	try {
		const client = MongoClient.connect(MONGO_URL, async (e, client) => {
			const db = client.db('TinderClone');
			let questions = await db.collection('Questions').find().toArray();
			res.send(Utils.selectRandomFromArray(questions));
		});
	} catch (ex) {
		console.error(ex);
	}
});
app.get('/', (req, res) => {
	res.send('ok');
});
app.listen(port, () => {
	console.log(`adMatay runs on http://localhost:${port}`);
});
