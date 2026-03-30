const express = require('express');
const router = express.Router();

// Admin endpoints
router.get('/dashboard', (req, res) => {
  res.json({
    stats: { totalUsers: 1247, activeEmergencies: 3, alertsToday: 12, responseRate: '94%' },
    recentEmergencies: [
      { id: 'EMG-001', type: 'medical', status: 'active', location: 'Connaught Place', time: '2 min ago' },
      { id: 'EMG-002', type: 'theft', status: 'responding', location: 'Red Fort', time: '15 min ago' },
      { id: 'EMG-003', type: 'accident', status: 'resolved', location: 'Karol Bagh', time: '1 hr ago' },
    ],
  });
});

router.get('/users', (req, res) => {
  res.json({ users: [
    { id: 'USR-001', name: 'John Doe', email: 'john@example.com', nationality: 'USA', status: 'active', lastSeen: '5 min ago' },
    { id: 'USR-002', name: 'Jane Smith', email: 'jane@example.com', nationality: 'UK', status: 'active', lastSeen: '12 min ago' },
    { id: 'USR-003', name: 'Raj Patel', email: 'raj@example.com', nationality: 'India', status: 'offline', lastSeen: '2 hrs ago' },
  ], total: 1247 });
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
