require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const path = require('path');
const http = require('http');
const { Server } = require('socket.io');
const db = require('./store/db');
const { admin, firestore } = require('./firebase_admin');

// Import routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const emergencyRoutes = require('./routes/emergency');
const locationRoutes = require('./routes/locations');
const alertRoutes = require('./routes/alerts');
const medicalRoutes = require('./routes/medical');
const documentRoutes = require('./routes/documents');
const checkinRoutes = require('./routes/checkin');
const adminRoutes = require('./routes/admin');

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });
app.set('io', io);

io.on('connection', (socket) => {
  console.log(`⚡ Socket client connected: ${socket.id}`);
  socket.on('disconnect', () => {
    console.log(`🔌 Socket client disconnected: ${socket.id}`);
  });
});

const PORT = process.env.PORT || 3000;

// ─── Middleware ──────────────────────────────────────────────────────────────
app.use(helmet({ contentSecurityPolicy: false }));
app.use(cors());
app.use(morgan('dev'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 min
  max: 100,
  message: { error: 'Too many requests, please try again later' },
});
app.use('/api/', limiter);

// ─── API Routes ─────────────────────────────────────────────────────────────
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/emergency', emergencyRoutes);
app.use('/api/locations', locationRoutes);
app.use('/api/alerts', alertRoutes);
app.use('/api/medical', medicalRoutes);
app.use('/api/documents', documentRoutes);
app.use('/api/checkin', checkinRoutes);
app.use('/api/admin', adminRoutes);

// ─── Admin Dashboard (Static Files) ────────────────────────────────────────
app.use('/admin', express.static(path.join(__dirname, 'admin')));

// ─── Police Dashboard (Static Files) ────────────────────────────────────────
app.use('/police', express.static(path.join(__dirname, 'police')));

// ─── Health Check ───────────────────────────────────────────────────────────
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'SafeRoam API',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

// ─── Root ───────────────────────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    message: 'SafeRoam — Tourist Safety API',
    docs: '/api/health',
    admin: '/admin',
  });
});

// ─── Error Handler ──────────────────────────────────────────────────────────
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    error: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
});

// ─── 404 Handler ────────────────────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// ─── Start Server ───────────────────────────────────────────────────────────
server.listen(PORT, () => {
  console.log(`\n🛡️  SafeRoam API running on http://localhost:${PORT}`);
  console.log(`📊 Admin Dashboard:  http://localhost:${PORT}/admin`);
  console.log(`🚔 Police Dashboard: http://localhost:${PORT}/police`);
  console.log(`💚 Health Check:     http://localhost:${PORT}/api/health\n`);
});

module.exports = server;
