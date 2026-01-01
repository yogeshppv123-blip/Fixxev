const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

// About Section Schema
const aboutSectionSchema = new mongoose.Schema({
    title: { type: String, required: true },
    label: { type: String, default: '' },
    description: { type: String, default: '' },
    type: { type: String, enum: ['Values', 'Vision', 'CSR', 'Future', 'Custom'], default: 'Custom' },
    items: [{ type: String }],
    imageUrl: { type: String, default: '' },
    isActive: { type: Boolean, default: true },
    order: { type: Number, default: 0 },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
});

const AboutSection = mongoose.models.AboutSection || mongoose.model('AboutSection', aboutSectionSchema);

// Get all sections
router.get('/', async (req, res) => {
    try {
        const sections = await AboutSection.find().sort({ order: 1 });
        res.json(sections);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Create section
router.post('/', async (req, res) => {
    try {
        const section = new AboutSection(req.body);
        const savedSection = await section.save();
        res.status(201).json(savedSection);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Update section
router.put('/:id', async (req, res) => {
    try {
        const section = await AboutSection.findByIdAndUpdate(
            req.params.id,
            { ...req.body, updatedAt: Date.now() },
            { new: true }
        );
        res.json(section);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Delete section
router.delete('/:id', async (req, res) => {
    try {
        await AboutSection.findByIdAndDelete(req.params.id);
        res.json({ message: 'Section deleted' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Seed default data
router.post('/seed', async (req, res) => {
    try {
        const count = await AboutSection.countDocuments();
        if (count > 0) {
            return res.json({ message: 'Data already exists' });
        }

        const defaultSections = [
            {
                title: 'Our Core Values',
                label: '// VALUES',
                description: 'At FIXXEV, we are driven by integrity, excellence, and a deep commitment to the environment.',
                type: 'Values',
                items: ['Integrity in every service', 'Excellence in engineering', 'Sustainable EV solutions'],
                order: 1,
            },
            {
                title: 'Corporate Social Responsibility',
                label: '// GIVING BACK',
                description: 'FIXXEV is committed to making a positive impact on the environment and society.',
                type: 'CSR',
                items: ['Green recycling programs', 'Community EV awareness', 'Waste reduction protocols'],
                order: 2,
            },
            {
                title: 'Our Goal',
                label: '// VISION',
                description: 'Our goal is to build India\'s most reliable EV support ecosystem.',
                type: 'Vision',
                items: ['Zero downtime for EV users', 'Nationwide service availability', 'Affordable premium care'],
                order: 3,
            },
            {
                title: 'Future Plans & Expansion',
                label: '// THE FUTURE',
                description: 'We are rapidly expanding our footprint across India with upcoming battery tech centers.',
                type: 'Future',
                items: ['Upcoming battery tech centers', 'Expansion to 200+ cities', 'Next-gen retrofit solutions'],
                order: 4,
            },
        ];

        await AboutSection.insertMany(defaultSections);
        res.json({ message: 'Default sections seeded successfully' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;
