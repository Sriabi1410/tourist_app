const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');

// In-memory store (replace with Firebase Firestore in production)
const users = new Map();
const otpStore = new Map();

// POST /api/auth/register
router.post('/register', async (req, res) => {
  try {
    const { name, email, phone, password, nationality } = req.body;
    if (!name || !email || !password) {
      return res.status(400).json({ error: 'Name, email, and password are required' });
    }
    if (users.has(email)) {
      return res.status(409).json({ error: 'Email already registered' });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const userId = `USR-${uuidv4().slice(0, 8)}`;
    const user = { id: userId, name, email, phone, nationality, password: hashedPassword, role: 'user', createdAt: new Date().toISOString() };
    users.set(email, user);

    // Generate OTP
    const otp = String(Math.floor(100000 + Math.random() * 900000));
    otpStore.set(email, { otp, expiresAt: Date.now() + 5 * 60 * 1000 });
    console.log(`OTP for ${email}: ${otp}`);

    res.status(201).json({ message: 'Registration successful', userId, otpRequired: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/auth/verify-otp
router.post('/verify-otp', (req, res) => {
  const { email, otp } = req.body;
  const stored = otpStore.get(email);
  if (!stored || stored.otp !== otp || Date.now() > stored.expiresAt) {
    return res.status(400).json({ error: 'Invalid or expired OTP' });
  }
  otpStore.delete(email);
  const user = users.get(email);
  const token = jwt.sign({ id: user.id, email, role: user.role }, process.env.JWT_SECRET || 'saferoam_secret', { expiresIn: '7d' });
  res.json({ message: 'Verification successful', token, user: { id: user.id, name: user.name, email } });
});

// POST /api/auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = users.get(email);
    if (!user) return res.status(401).json({ error: 'Invalid credentials' });

    const valid = await bcrypt.compare(password, user.password);
    if (!valid) return res.status(401).json({ error: 'Invalid credentials' });

    const token = jwt.sign({ id: user.id, email, role: user.role }, process.env.JWT_SECRET || 'saferoam_secret', { expiresIn: '7d' });
    res.json({ token, user: { id: user.id, name: user.name, email: user.email, phone: user.phone, nationality: user.nationality } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/auth/logout
router.post('/logout', (req, res) => {
  res.json({ message: 'Logged out successfully' });
});

module.exports = router;
