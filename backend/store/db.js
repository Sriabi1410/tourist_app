const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const DATA_FILE = path.join(__dirname, 'data.json');

let state = {
  emergencies: [],
  users: [
    { id: 'USR-001', name: 'John Doe', email: 'john@example.com', nationality: 'USA', status: 'Online', location: 'Airport Area', phone: '+1 555 012 3456', init: 'JD', color: '#0891b2', sos: 0, lastSeen: 'Just now' },
    { id: 'USR-002', name: 'Jane Smith', email: 'jane@example.com', nationality: 'UK', status: 'Online', location: 'MG Road', phone: '+44 7700 900077', init: 'JS', color: '#8b5cf6', sos: 0, lastSeen: '5m ago' },
    { id: 'USR-003', name: 'Rahul Sharma', email: 'rahul@example.com', nationality: 'India', status: 'Online', location: 'Koramangala', phone: '+91 98765 43210', init: 'RS', color: '#2563b0', sos: 0, lastSeen: '10m ago' },
  ],
  units: [
    { id: 'UNIT-01', name: 'Unit 01', type: 'Interceptor', status: 'available', officers: 2, location: 'Central Hub', log: 'Patrolling' },
    { id: 'UNIT-02', name: 'Unit 02', type: 'Ambulance', status: 'dispatched', officers: 3, location: 'MG Road Junction', log: 'En route to Medical SOS' },
    { id: 'UNIT-03', name: 'Unit 03', type: 'Patrol Car', status: 'available', officers: 2, location: 'North Division', log: 'Available' },
    { id: 'UNIT-07', name: 'Unit 07', type: 'Tactical Team', status: 'on-scene', officers: 4, location: 'Koramangala', log: 'Investigating incident' },
  ],
  crimes: [],
  missing: []
};

// Synchronously load data from file
function loadSync() {
  try {
    if (fs.existsSync(DATA_FILE)) {
      const data = fs.readFileSync(DATA_FILE, 'utf8');
      state = { ...state, ...JSON.parse(data) };
    } else {
      saveSync();
    }
  } catch (err) {
    console.error('Failed to load DB:', err);
  }
}

// Synchronously save data to file
function saveSync() {
  try {
    fs.writeFileSync(DATA_FILE, JSON.stringify(state, null, 2));
  } catch (err) {
    console.error('Failed to save DB:', err);
  }
}

// Load initially
loadSync();

function getState() {
  return state;
}

// Emergencies
function addEmergency(event) {
  state.emergencies.unshift(event);
  
  // Track on user if exists
  const user = state.users.find(u => u.id === event.userId || u.name === event.person);
  if(user) {
      user.status = 'SOS';
      user.sos = (user.sos || 0) + 1;
      user.location = event.location;
  }
  
  saveSync();
  return event;
}

function updateEmergency(id, updates) {
  const index = state.emergencies.findIndex(e => e.id === id || e.id === `INC-${id}`); 
  if (index !== -1) {
    state.emergencies[index] = { ...state.emergencies[index], ...updates };
    saveSync();
    return state.emergencies[index];
  }
  return null;
}

function getEmergencies() {
  return state.emergencies;
}

// Users (Tourists)
function updateUserLocation(userId, latitude, longitude, locationName) {
  const user = state.users.find(u => u.id === userId);
  if (user) {
    user.latitude = latitude;
    user.longitude = longitude;
    if (locationName) user.location = locationName;
    user.lastSeen = 'Just now';
    saveSync();
    return user;
  }
  return null;
}

function getUsers() {
    return state.users;
}

// Units
function getUnits() {
    return state.units;
}

function updateUnitStatus(id, newStatus, currentLog) {
    const unit = state.units.find(u => u.id === id);
    if(unit) {
        unit.status = newStatus;
        if(currentLog) unit.log = currentLog;
        saveSync();
        return unit;
    }
    return null;
}

module.exports = {
  state,
  getState,
  saveSync,
  addEmergency,
  updateEmergency,
  getEmergencies,
  updateUserLocation,
  getUsers,
  getUnits,
  updateUnitStatus,
};
