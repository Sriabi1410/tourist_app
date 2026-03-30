const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');

const locationLogs = [];

router.post('/update', auth, (req, res) => {
  const { latitude, longitude, address } = req.body;
  const log = { userId: req.user.id, latitude, longitude, address, timestamp: new Date().toISOString() };
  locationLogs.push(log);
  res.json({ message: 'Location updated', location: log });
});

router.get('/history', auth, (req, res) => {
  const userLogs = locationLogs.filter(l => l.userId === req.user.id).slice(-50);
  res.json({ locations: userLogs });
});

router.get('/nearby', (req, res) => {
  const { lat, lng, type } = req.query;
  const places = [
    { name: 'City Police Station', type: 'police', distance: '0.8 km', lat: 28.616, lng: 77.211, phone: '100' },
    { name: 'General Hospital', type: 'hospital', distance: '1.2 km', lat: 28.609, lng: 77.213, phone: '102' },
    { name: 'Fire Station #3', type: 'fire', distance: '1.5 km', lat: 28.620, lng: 77.206, phone: '101' },
    { name: 'US Embassy', type: 'embassy', distance: '2.1 km', lat: 28.606, lng: 77.203, phone: '+91-11-2419-8000' },
    { name: 'Tourist Police', type: 'police', distance: '2.4 km', lat: 28.624, lng: 77.216, phone: '1363' },
    { name: 'Apollo Hospital', type: 'hospital', distance: '3.0 km', lat: 28.602, lng: 77.218, phone: '+91-11-2692-5858' },
  ];
  const filtered = type && type !== 'all' ? places.filter(p => p.type === type) : places;
  res.json({ places: filtered });
});

router.post('/share', auth, (req, res) => {
  const { latitude, longitude, duration } = req.body;
  const shareLink = `https://saferoam.app/locate/${req.user.id}/${Date.now()}`;
  res.json({ message: 'Location sharing started', shareLink, expiresIn: duration || '1h' });
});

// Admin: all locations
router.get('/all', (req, res) => {
  res.json({ locations: locationLogs.slice(-100), total: locationLogs.length });
});

module.exports = router;
