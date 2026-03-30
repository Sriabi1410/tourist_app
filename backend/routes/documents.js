const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');

router.get('/', auth, (req, res) => {
  res.json({ documents: [
    { id: '1', name: 'Passport', type: 'passport', uploadedAt: '2026-03-15', size: '2.4 MB' },
    { id: '2', name: 'Travel Visa', type: 'visa', uploadedAt: '2026-03-10', size: '1.1 MB' },
    { id: '3', name: 'Travel Insurance', type: 'insurance', uploadedAt: '2026-03-05', size: '0.8 MB' },
  ]});
});

router.post('/upload', auth, (req, res) => {
  res.status(201).json({ message: 'Document uploaded & encrypted', document: { id: Date.now().toString(), ...req.body } });
});

router.get('/:id', auth, (req, res) => {
  res.json({ document: { id: req.params.id, name: 'Passport', type: 'passport', url: '#' } });
});

router.delete('/:id', auth, (req, res) => {
  res.json({ message: 'Document deleted permanently' });
});

module.exports = router;
