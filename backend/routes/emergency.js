const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');
const { v4: uuidv4 } = require('uuid');

const emergencies = [];

router.post('/sos', auth, (req, res) => {
  const { type, latitude, longitude, message } = req.body;
  const emergency = {
    id: `EMG-${uuidv4().slice(0, 8)}`,
    userId: req.user.id,
    type: type || 'other',
    latitude, longitude, message,
    status: 'active',
    createdAt: new Date().toISOString(),
    responderId: null, responderName: null, eta: null,
  };
  emergencies.unshift(emergency);
  console.log(`🆘 SOS Alert: ${emergency.id} from ${req.user.id} at ${latitude}, ${longitude}`);
  res.status(201).json({ message: 'SOS alert sent', emergency });
});

router.get('/active', auth, (req, res) => {
  const active = emergencies.find(e => e.userId === req.user.id && e.status === 'active');
  res.json({ emergency: active || null });
});

router.put('/:id/status', auth, (req, res) => {
  const { status } = req.body;
  const emergency = emergencies.find(e => e.id === req.params.id);
  if (!emergency) return res.status(404).json({ error: 'Emergency not found' });
  emergency.status = status;
  res.json({ message: 'Status updated', emergency });
});

router.put('/:id/cancel', auth, (req, res) => {
  const emergency = emergencies.find(e => e.id === req.params.id);
  if (!emergency) return res.status(404).json({ error: 'Emergency not found' });
  emergency.status = 'cancelled';
  res.json({ message: 'Emergency cancelled', emergency });
});

router.get('/history', auth, (req, res) => {
  const userEmergencies = emergencies.filter(e => e.userId === req.user.id);
  res.json({ emergencies: userEmergencies });
});

// Admin: Get all emergencies
router.get('/all', (req, res) => {
  res.json({ emergencies, total: emergencies.length });
});

module.exports = router;
