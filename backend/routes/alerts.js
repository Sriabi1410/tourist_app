const express = require('express');
const router = express.Router();

const alerts = [
  { id: '1', title: 'Pickpocket Warning', area: 'Connaught Place', type: 'crime', severity: 'high', timestamp: new Date().toISOString() },
  { id: '2', title: 'Heavy Rain Alert', area: 'Central Delhi', type: 'weather', severity: 'medium', timestamp: new Date().toISOString() },
  { id: '3', title: 'Road Closure', area: 'Rajpath', type: 'traffic', severity: 'low', timestamp: new Date().toISOString() },
  { id: '4', title: 'Tourist Scam Report', area: 'Red Fort Area', type: 'crime', severity: 'medium', timestamp: new Date().toISOString() },
  { id: '5', title: 'Travel Advisory Update', area: 'Delhi NCR', type: 'advisory', severity: 'info', timestamp: new Date().toISOString() },
];

router.get('/', (req, res) => {
  const { type } = req.query;
  const filtered = type ? alerts.filter(a => a.type === type) : alerts;
  res.json({ alerts: filtered });
});

router.get('/crime', (req, res) => {
  res.json({ alerts: alerts.filter(a => a.type === 'crime') });
});

router.get('/weather', (req, res) => {
  res.json({ weather: { temp: '28°C', humidity: '85%', wind: '12 km/h', warning: 'Heavy Rain Expected' } });
});

router.get('/advisory', (req, res) => {
  res.json({ advisory: { country: 'India', level: 2, message: 'Exercise Increased Caution', regions: [
    { name: 'Delhi NCR', level: 1, message: 'Exercise normal caution' },
    { name: 'Kashmir', level: 3, message: 'Reconsider travel' },
    { name: 'Goa', level: 1, message: 'Exercise normal caution' },
  ]}});
});

router.post('/', (req, res) => {
  const { title, area, type, severity } = req.body;
  const alert = { id: String(alerts.length + 1), title, area, type, severity, timestamp: new Date().toISOString() };
  alerts.unshift(alert);
  res.status(201).json({ message: 'Alert created', alert });
});

module.exports = router;
