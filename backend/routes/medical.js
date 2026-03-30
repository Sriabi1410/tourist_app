const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');

router.get('/profile', auth, (req, res) => {
  res.json({ medical: { bloodType: 'O+', allergies: 'Penicillin', medications: 'None', conditions: 'None', insuranceProvider: 'Star Health', insuranceNumber: 'SH-2026-001' } });
});

router.put('/profile', auth, (req, res) => {
  const { bloodType, allergies, medications, conditions, insuranceProvider, insuranceNumber } = req.body;
  res.json({ message: 'Medical profile updated', medical: { bloodType, allergies, medications, conditions, insuranceProvider, insuranceNumber } });
});

router.get('/contacts', auth, (req, res) => {
  res.json({ contacts: [
    { id: '1', name: 'Dr. Rahul Sharma', type: 'doctor', phone: '+91 98765 43210' },
    { id: '2', name: 'Apollo Hospital', type: 'hospital', phone: '+91 11 2692 5858' },
  ]});
});

router.post('/contacts', auth, (req, res) => {
  res.status(201).json({ message: 'Medical contact added', contact: req.body });
});

router.get('/share/:userId', (req, res) => {
  res.json({ medical: { bloodType: 'O+', allergies: 'Penicillin', emergencyOnly: true } });
});

module.exports = router;
