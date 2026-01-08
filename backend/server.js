// Sync version: 1.0.1
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5001; // Port 5000 is often taken by AirPlay on Mac

// Middleware
app.use(cors({
    origin: '*', // Allow all origins
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));
app.use('/uploads', express.static('uploads'));

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
app.use('/api/upload', require('./routes/upload'));
app.use('/api/auth', require('./routes/auth'));

// Seed Default Admin
const Admin = require('./models/Admin');
const seedAdmin = async () => {
    try {
        let admin = await Admin.findOne({ email: 'admin@fixxev.com' });
        if (!admin) {
            admin = new Admin({
                name: 'Admin',
                email: 'admin@fixxev.com',
                password: 'Fixxev@456'
            });
            await admin.save();
            console.log('Default Admin seeded with new password');
        } else {
            // Force update to the requested password and ensure hashing
            admin.password = 'Fixxev@456';
            admin.markModified('password');
            await admin.save();
            console.log('Default Admin password updated to Fixxev@456 and hashed');
        }
    } catch (e) {
        console.log('Error seeding admin:', e);
    }
};
seedAdmin();

app.get('/', (req, res) => {
    res.send('Fixxev Backend API');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
