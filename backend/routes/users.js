const express = require('express');
const router = express.Router();
const { auth } = require('../middleware/auth');

router.get('/profile', auth, (req, res) => {
  res.json({ user: req.user, message: 'Profile retrieved' });
});

router.put('/profile', auth, (req, res) => {
  const { name, phone, nationality } = req.body;
  res.json({ message: 'Profile updated', user: { ...req.user, name, phone, nationality } });
});

router.get('/emergency-contacts', auth, (req, res) => {
  res.json({ contacts: [
    { id: '1', name: 'John Doe', phone: '+91 98765 43210', relationship: 'Brother' },
    { id: '2', name: 'Jane Doe', phone: '+91 91234 56789', relationship: 'Mother' },
  ]});
});

router.post('/emergency-contacts', auth, (req, res) => {
  const { name, phone, relationship } = req.body;
  res.status(201).json({ message: 'Contact added', contact: { id: Date.now().toString(), name, phone, relationship } });
});

router.delete('/emergency-contacts/:id', auth, (req, res) => {
  res.json({ message: 'Contact removed' });
});

module.exports = router;
