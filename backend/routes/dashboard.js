const express = require('express');
const router = express.Router();
const Service = require('../models/Service');
const Product = require('../models/Product');
const TeamMember = require('../models/TeamMember');
const Blog = require('../models/Blog');

router.get('/stats', async (req, res) => {
    try {
        const [servicesCount, productsCount, teamCount, blogsCount, recentServices, recentProducts, recentBlogs] = await Promise.all([
            Service.countDocuments(),
            Product.countDocuments(),
            TeamMember.countDocuments(),
            Blog.countDocuments(),
            Service.find().sort({ createdAt: -1 }).limit(2),
            Product.find().sort({ _id: -1 }).limit(2), // assuming _id for products
            Blog.find().sort({ createdAt: -1 }).limit(2)
        ]);

        const recentActivity = [];
        recentServices.forEach(s => recentActivity.push({ type: 'Service', message: `New service: ${s.title}`, time: 'Recent' }));
        recentProducts.forEach(p => recentActivity.push({ type: 'Product', message: `New product: ${p.name}`, time: 'Recent' }));
        recentBlogs.forEach(b => recentActivity.push({ type: 'Blog', message: `New post: ${b.title}`, time: 'Recent' }));

        res.json({
            servicesCount: servicesCount,
            productsCount: productsCount,
            teamCount: teamCount,
            blogsCount: blogsCount,
            recentActivity: recentActivity.slice(0, 5)
        });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;
