const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

// CKD Feature Schema
const ckdFeatureSchema = new mongoose.Schema({
    title: { type: String, required: true },
    subtitle: { type: String, default: '' },
    description: { type: String, default: '' },
    category: { type: String, enum: ['Infrastructure', 'Technology', 'Design', 'Efficiency', 'Sustainability'], default: 'Infrastructure' },
    imageUrl: { type: String, default: '' },
    isActive: { type: Boolean, default: true },
    order: { type: Number, default: 0 },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
});

const CKDFeature = mongoose.models.CKDFeature || mongoose.model('CKDFeature', ckdFeatureSchema);

// Get all features
router.get('/', async (req, res) => {
    try {
        const features = await CKDFeature.find().sort({ order: 1 });
        res.json(features);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Create feature
router.post('/', async (req, res) => {
    try {
        const feature = new CKDFeature(req.body);
        const savedFeature = await feature.save();
        res.status(201).json(savedFeature);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Update feature
router.put('/:id', async (req, res) => {
    try {
        const feature = await CKDFeature.findByIdAndUpdate(
            req.params.id,
            { ...req.body, updatedAt: Date.now() },
            { new: true }
        );
        res.json(feature);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Delete feature
router.delete('/:id', async (req, res) => {
    try {
        await CKDFeature.findByIdAndDelete(req.params.id);
        res.json({ message: 'Feature deleted' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Seed default data
router.post('/seed', async (req, res) => {
    try {
        const count = await CKDFeature.countDocuments();
        if (count > 0) {
            return res.json({ message: 'Data already exists' });
        }

        const defaultFeatures = [
            {
                title: 'Modular Design',
                subtitle: 'Flexible & Scalable',
                description: 'Our CKD containers are designed with modularity in mind, allowing for easy customization and expansion.',
                category: 'Design',
                order: 1,
            },
            {
                title: 'Rapid Deployment',
                subtitle: '30-Day Setup',
                description: 'Get your showroom up and running in just 30 days with our pre-fabricated container solutions.',
                category: 'Efficiency',
                order: 2,
            },
            {
                title: 'Smart Technology',
                subtitle: 'IoT Integrated',
                description: 'Built-in IoT sensors and smart systems for real-time monitoring and diagnostics.',
                category: 'Technology',
                order: 3,
            },
            {
                title: 'Eco-Friendly',
                subtitle: 'Sustainable Materials',
                description: 'Constructed with eco-friendly materials and designed for minimal environmental impact.',
                category: 'Sustainability',
                order: 4,
            },
            {
                title: 'All-Weather Ready',
                subtitle: 'Climate Controlled',
                description: 'Fully insulated with climate control systems for year-round operation in any weather.',
                category: 'Infrastructure',
                order: 5,
            },
        ];

        await CKDFeature.insertMany(defaultFeatures);
        res.json({ message: 'Default CKD features seeded successfully' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;
