const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

// CKD Feature Schema
const ckdFeatureSchema = new mongoose.Schema({
    title: { type: String, required: true },
    subtitle: { type: String, default: '' },
    description: { type: String, default: '' },
    category: { type: String, enum: ['Infrastructure', 'Technology', 'Design', 'Efficiency', 'Sustainability', 'Support'], default: 'Infrastructure' },
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
        await CKDFeature.deleteMany({});

        const defaultFeatures = [
            {
                title: 'Product Sourcing & Compatibility Testing',
                subtitle: 'Sourcing',
                description: 'We identify and procure high-quality EV components, ensuring complete compatibility for Indian road conditions.',
                category: 'Support',
                order: 1,
            },
            {
                title: 'CKD Import & Logistics Handling',
                subtitle: 'Logistics',
                description: 'Our team manages the complex import process, customs clearance, and secure transportation of CKD kits.',
                category: 'Support',
                order: 2,
            },
            {
                title: 'Local Assembly Support & Quality Checks',
                subtitle: 'Assembly',
                description: 'We provide technical guidance for local assembly and rigorous quality control protocols to ensure safety.',
                category: 'Support',
                order: 3,
            },
            {
                title: 'Branding, Marketing & Sales Support',
                subtitle: 'Growth',
                description: 'Leverage our brand assets and marketing strategies to launch your dealership and drive sales effectively.',
                category: 'Support',
                order: 4,
            }
        ];

        await CKDFeature.insertMany(defaultFeatures);
        res.json({ message: 'Default CKD features seeded successfully' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;
