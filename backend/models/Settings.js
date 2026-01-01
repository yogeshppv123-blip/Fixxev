const mongoose = require('mongoose');

const SettingsSchema = new mongoose.Schema({
    siteName: { type: String, default: 'Fixxev' },
    contactEmail: { type: String },
    contactPhone: { type: String },
    address: { type: String },
    maintenanceMode: { type: Boolean, default: false },
    emailNotifications: { type: Boolean, default: true },
    socialLinks: {
        facebook: { type: String },
        twitter: { type: String },
        instagram: { type: String },
        linkedin: { type: String }
    }
}, { timestamps: true });

module.exports = mongoose.model('Settings', SettingsSchema);
