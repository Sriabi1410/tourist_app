const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');

const checkins = [];

router.post('/', auth, (req, res) => {
  const { latitude, longitude, message } = req.body;
  const checkin = { id: Date.now().toString(), userId: req.user.id, latitude, longitude, message: message || "I'm safe", timestamp: new Date().toISOString() };
  checkins.unshift(checkin);
  res.status(201).json({ message: 'Check-in recorded', checkin });
});

router.get('/history', auth, (req, res) => {
  res.json({ checkins: checkins.filter(c => c.userId === req.user.id) });
});

router.post('/missed', auth, (req, res) => {
  console.log(`⚠️ Missed check-in for user ${req.user.id}`);
  res.json({ message: 'Missed check-in alert sent to contacts' });
});

router.get('/activity', auth, (req, res) => {
  res.json({ activity: [
    { title: 'Visited India Gate', time: '10:30 AM', distance: '2.1 km' },
    { title: 'Walking - Rajpath', time: '11:00 AM', distance: '0.8 km' },
    { title: 'Lunch at Restaurant', time: '12:30 PM', distance: '0.3 km' },
  ], stats: { totalDistance: '6.6 km', activeTime: '4h 30m', places: 4 } });
});

module.exports = router;
