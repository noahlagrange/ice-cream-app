require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(bodyParser.json());

app.use(cors());

mongoose
  .connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB Connected'))
  .catch((err) => console.error(err));

const CoordinateSchema = new mongoose.Schema({
    latitude: { type: Number, required: true },
    longitude: { type: Number, required: true },
});

const Coordinate = mongoose.model('Coordinate', CoordinateSchema);
const ItemSchema = new mongoose.Schema({
  path: { type: String, required: true },
  name: { type: String, required: true },
  price: { type: Number, required: true },
  stock: { type: Number, required: true },
});

const Item = mongoose.model('Item', ItemSchema);

app.get('/', (req, res) => {
  res.send('Welcome to the Node.js Server with MongoDB!');
});

app.post('/items', async (req, res) => {
  try {
    const newItem = new Item(req.body);
    const savedItem = await newItem.save();
    res.status(201).json(savedItem);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/test', (req, res) => {
    res.send('Hello World!');
    });

app.get('/items', async (req, res) => {
  try {
    console.log("GET");
    const items = await Item.find();
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.put('/items/:id', async (req, res) => {
  try {
    const updatedItem = await Item.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updatedItem);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.delete('/items/:id', async (req, res) => {
  try {
    await Item.findByIdAndDelete(req.params.id);
    res.json({ message: 'Item deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.post('/coordinates', async (req, res) => {
  try {
    const newCoordinate = new Coordinate(req.body);
    const savedCoordinate = await newCoordinate.save();
    res.status(201).json(savedCoordinate);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/coordinates', async (req, res) => {
  try {
    const coordinates = await Coordinate.find();
    res.json(coordinates);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/coordinates/:id', async (req, res) => {
  try {
    const coordinate = await Coordinate.findById(req.params.id);
    if (!coordinate) {
      return res.status(404).json({ message: 'Coordinate not found' });
    }
    res.json(coordinate);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.put('/coordinates/:id', async (req, res) => {
  try {
    const updatedCoordinate = await Coordinate.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedCoordinate) {
      return res.status(404).json({ message: 'Coordinate not found' });
    }
    res.json(updatedCoordinate);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.delete('/coordinates/:id', async (req, res) => {
  try {
    const deletedCoordinate = await Coordinate.findByIdAndDelete(req.params.id);
    if (!deletedCoordinate) {
      return res.status(404).json({ message: 'Coordinate not found' });
    }
    res.json({ message: 'Coordinate deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.listen(PORT, () => {
  console.log('Server is running on port 5000');
});
