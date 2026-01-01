require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5001; // Port 5000 is often taken by AirPlay on Mac

// Middleware
app.use(cors({
    origin: '*', // Allow all origins
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// Request logger
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
    next();
});

// Database Connection
// Database Connection
mongoose.connect(process.env.MONGODB_URI)
    .then(() => console.log('MongoDB Connected'))
    .catch(err => console.log(err));

// Routes
const servicesRouter = require('./routes/services');
const teamRouter = require('./routes/team');
const productsRouter = require('./routes/products');

app.use('/api/services', servicesRouter);
app.use('/api/team', teamRouter);
app.use('/api/products', productsRouter);
app.use('/api/blog', require('./routes/blog'));
app.use('/api/settings', require('./routes/settings'));
app.use('/api/dashboard', require('./routes/dashboard'));
app.use('/api/media', require('./routes/media'));
app.use('/api/page-content', require('./routes/pageContent'));
app.use('/api/leads', require('./routes/leads'));
app.use('/api/about-sections', require('./routes/aboutSections'));
app.use('/api/franchise-types', require('./routes/franchiseTypes'));
app.use('/api/ckd-features', require('./routes/ckdFeatures'));

app.get('/', (req, res) => {
    res.send('Fixxev Backend API');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
