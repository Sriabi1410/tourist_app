const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');
const { v4: uuidv4 } = require('uuid');
const db = require('../store/db');
const { firestore } = require('../firebase_admin');

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
  const e = db.addEmergency(emergency);
  if (firestore) {
    firestore.collection('emergencies').doc(e.id).set(e).catch((err) => console.warn('Firestore emergency sync failed:', err.message || err));
  }
  req.app.get('io').emit('sos_alert', e);
  console.log(`🆘 SOS Alert: ${e.id} from ${req.user.id} at ${latitude}, ${longitude}`);
  res.status(201).json({ message: 'SOS alert sent', emergency: e });
});

router.get('/active', auth, (req, res) => {
  const active = db.getEmergencies().find(e => e.userId === req.user.id && e.status === 'active');
  res.json({ emergency: active || null });
});

router.put('/:id/status', auth, (req, res) => {
  const { status } = req.body;
  const emergency = db.updateEmergency(req.params.id, { status });
  if (!emergency) return res.status(404).json({ error: 'Emergency not found' });
  req.app.get('io').emit('sos_update', emergency);
  res.json({ message: 'Status updated', emergency });
});

router.put('/:id/cancel', auth, (req, res) => {
  const emergency = db.updateEmergency(req.params.id, { status: 'cancelled' });
  if (!emergency) return res.status(404).json({ error: 'Emergency not found' });
  req.app.get('io').emit('sos_update', emergency);
  res.json({ message: 'Emergency cancelled', emergency });
});

router.get('/history', auth, (req, res) => {
  const userEmergencies = db.getEmergencies().filter(e => e.userId === req.user.id);
  res.json({ emergencies: userEmergencies });
});

// Admin: Get all emergencies
router.get('/all', (req, res) => {
  const emergencies = db.getEmergencies();
  res.json({ emergencies, total: emergencies.length });
});

module.exports = router;
