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
                subtitle: 'Strategic Sourcing',
                description: 'At Fixx EV, we specialize in identifying and procuring high-quality EV components from audited global factories. Our expert team conducts rigorous compatibility testing and bench-marking to ensure that every part—from battery cells to powertrain controllers—is perfectly optimized for Indian road conditions and climate.',
                category: 'Support',
                order: 1,
            },
            {
                title: 'CKD Import & Logistics Handling',
                subtitle: 'Seamless Logistics',
                description: 'Navigating international trade can be complex. We manage the entire import lifecycle for your brand, including factory coordination, secure CKD packing, export documentation, international shipping, and customs clearance at Indian ports. We ensure your kits arrive safely and on time at your assembly unit.',
                category: 'Support',
                order: 2,
            },
            {
                title: 'Local Assembly Support & Quality Checks',
                subtitle: 'Precision Assembly',
                description: 'Launch your assembly operations with confidence. We provide detailed technical guidance for setting up local assembly lines, along with standardized technician training modules. Our multi-stage quality control protocols and PDI (Pre-Delivery Inspection) systems guarantee that every vehicle meets safety standards.',
                category: 'Support',
                order: 3,
            },
            {
                title: 'Branding, Marketing & Sales Support',
                subtitle: 'Brand Growth',
                description: 'Transform generic EV kits into a powerful local brand. We assist you with brand identity design, localized marketing strategies, and dealer network expansion. From digital presence to physical showroom branding, we provide the tools and support needed to drive sales and scale your EV business rapidly.',
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
