const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const cloudinary = require('cloudinary').v2;
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const fs = require('fs');

// Configure Cloudinary
cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET
});

let upload;

// Determine storage engine
const useCloudinary = process.env.CLOUDINARY_CLOUD_NAME &&
    process.env.CLOUDINARY_API_KEY &&
    process.env.CLOUDINARY_API_SECRET;

if (useCloudinary) {
    console.log('Using Cloudinary Storage');
    const storage = new CloudinaryStorage({
        cloudinary: cloudinary,
        params: {
            folder: 'fixxev_uploads',
            allowed_formats: ['jpg', 'png', 'jpeg', 'webp', 'gif'],
            public_id: (req, file) => {
                const name = path.parse(file.originalname).name;
                return `${Date.now()}-${name}`;
            },
        },
    });
    upload = multer({ storage: storage });
} else {
    console.log('Using Local Storage (Cloudinary credentials missing)');
    const uploadDir = path.join(__dirname, '../uploads');
    if (!fs.existsSync(uploadDir)) {
        fs.mkdirSync(uploadDir, { recursive: true });
    }

    const storage = multer.diskStorage({
        destination: (req, file, cb) => {
            cb(null, uploadDir);
        },
        filename: (req, file, cb) => {
            const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
            cb(null, uniqueSuffix + path.extname(file.originalname));
        }
    });

    upload = multer({
        storage: storage,
        limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
        fileFilter: (req, file, cb) => {
            const filetypes = /jpeg|jpg|png|webp|gif/;
            const mimetype = filetypes.test(file.mimetype);
            const extname = filetypes.test(path.extname(file.originalname).toLowerCase());

            if (mimetype || extname) {
                return cb(null, true);
            }
            cb(new Error("Only image files (jpeg, jpg, png, webp, gif) are allowed!"));
        }
    });
}

// Upload endpoint
router.post('/', (req, res) => {
    upload.single('image')(req, res, (err) => {
        if (err instanceof multer.MulterError) {
            console.error('Multer error:', err);
            return res.status(400).json({ message: `Upload error: ${err.message}` });
        } else if (err) {
            console.error('Upload error:', err);
            return res.status(400).json({ message: err.message });
        }

        if (!req.file) {
            console.error('No file in request');
            return res.status(400).json({ message: 'No file uploaded' });
        }

        try {
            console.log('File uploaded successfully:', req.file.path || req.file.filename);

            // Cloudinary provides 'path' as the secure URL
            // Local storage needs URL construction
            let url;
            if (useCloudinary) {
                url = req.file.path;
            } else {
                const protocol = req.protocol;
                const host = req.get('host');
                url = `${protocol}://${host}/uploads/${req.file.filename}`;
            }

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
