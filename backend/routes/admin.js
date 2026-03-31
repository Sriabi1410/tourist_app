const express = require('express');
const router = express.Router();
const db = require('../store/db');

// Admin endpoints
router.get('/dashboard', (req, res) => {
  const users = db.getUsers();
  const emergencies = db.getEmergencies();
  const activeEmergencies = emergencies.filter(e => e.status !== 'resolved' && e.status !== 'cancelled');

  res.json({
    stats: { totalUsers: users.length, activeEmergencies: activeEmergencies.length, alertsToday: emergencies.length, responseRate: '94%' },
    recentEmergencies: emergencies.slice(0, 5),
  });
});

router.get('/users', (req, res) => {
  const users = db.getUsers();
  res.json({ users, total: users.length });
});

router.get('/reports', (req, res) => {
  res.json({
    emergencyStats: { total: 156, medical: 45, police: 38, fire: 12, theft: 28, harassment: 15, accident: 18 },
    monthlyTrend: [12, 18, 15, 22, 19, 25, 14, 16, 20, 17, 13, 15],
    responseTime: { avg: '4.2 min', fastest: '1.5 min', slowest: '12 min' },
  });
});

router.get('/crime-data', (req, res) => {
  res.json({ crimeData: [
    { area: 'Connaught Place', type: 'Pickpocketing', reports: 24, severity: 'medium' },
    { area: 'Red Fort', type: 'Tourist Scam', reports: 18, severity: 'low' },
    { area: 'Karol Bagh', type: 'Bag Snatching', reports: 12, severity: 'high' },
  ]});
});

router.post('/crime-data', (req, res) => {
  res.status(201).json({ message: 'Crime data updated', data: req.body });
});

router.post('/alerts/broadcast', (req, res) => {
  const { title, message, severity, area } = req.body;
  console.log(`📢 Broadcasting alert: ${title} - ${area}`);
  res.json({ message: 'Alert broadcasted to users in area', recipientCount: 342 });
});

module.exports = router;
