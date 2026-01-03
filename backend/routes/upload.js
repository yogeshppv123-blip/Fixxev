const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Ensure uploads directory exists
const uploadDir = path.join(__dirname, '../uploads');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// Configure storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname));
    }
});

const upload = multer({
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
    fileFilter: (req, file, cb) => {
        const filetypes = /jpeg|jpg|png|webp|gif/;
        const mimetype = filetypes.test(file.mimetype);
        const extname = filetypes.test(path.extname(file.originalname).toLowerCase());

        if (mimetype || extname) { // Use OR instead of AND to be more flexible
            return cb(null, true);
        }
        cb(new Error("Only image files (jpeg, jpg, png, webp, gif) are allowed!"));
    }
});

// Upload endpoint
router.post('/', (req, res) => {
    upload.single('image')(req, res, (err) => {
        if (err instanceof multer.MulterError) {
            console.error('Multer error:', err);
            return res.status(400).json({ message: `Upload error: ${err.message}` });
        } else if (err) {
            console.error('Upload filter error:', err);
            // If it's our custom error, return 400
            if (err.message.includes("allowed")) {
                return res.status(400).json({ message: err.message });
            }
            return res.status(500).json({ message: `Server error: ${err.message}` });
        }

        if (!req.file) {
            console.error('No file in request');
            return res.status(400).json({ message: 'No file uploaded' });
        }

        try {
            console.log('File uploaded successfully:', req.file.filename);

            // Construct the URL
            const protocol = req.protocol;
            const host = req.get('host');
            // We use the same host and protocol as the request
            const url = `${protocol}://${host}/uploads/${req.file.filename}`;

            res.json({
                url,
                fileName: req.file.filename,
                message: 'Upload successful'
            });
        } catch (error) {
            console.error('Route handler error:', error);
            res.status(500).json({ message: 'Internal server error during URL construction' });
        }
    });
});

module.exports = router;
