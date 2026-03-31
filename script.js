document.addEventListener('DOMContentLoaded', () => {
    // DOM Elements
    const liveClock = document.getElementById('live-clock');
    const networkStatus = document.getElementById('network-status');
    const alertsList = document.getElementById('alerts-list');
    const caseDetailsPanel = document.getElementById('case-details-panel');
    const statTotal = document.getElementById('stat-total');
    const statActive = document.getElementById('stat-active');
    const statResolved = document.getElementById('stat-resolved');
    const notificationBadge = document.getElementById('notification-badge');
    const filterBtns = document.querySelectorAll('.filter-btn');

    // State
    let alertsData = [
        {
            "id": "EMG-0892",
            "touristName": "Emma Watson",
            "userId": "U-T984",
            "type": "Medical",
            "location": { "lat": 48.8584, "lng": 2.2945, "address": "Eiffel Tower, Paris" },
            "time": "11:15 AM",
            "status": "Pending",
            "criticality": "high",
            "contact": "+33 6 12 34 56 78"
        },
        {
            "id": "EMG-0893",
            "touristName": "Ken Adams",
            "userId": "U-T102",
            "type": "Theft",
            "location": { "lat": 48.8606, "lng": 2.3376, "address": "Louvre Museum, Paris" },
            "time": "11:20 AM",
            "status": "Responding",
            "criticality": "medium",
            "contact": "+33 6 98 76 54 32"
        },
        {
            "id": "EMG-0894",
            "touristName": "Sarah Lee",
            "userId": "U-T455",
            "type": "Lost Person",
            "location": { "lat": 48.8738, "lng": 2.2950, "address": "Arc de Triomphe, Paris" },
            "time": "11:22 AM",
            "status": "Pending",
            "criticality": "low",
            "contact": "+1 415 555 2671"
        },
        {
            "id": "EMG-0880",
            "touristName": "Michael Chang",
            "userId": "U-T771",
            "type": "Accident",
            "location": { "lat": 48.8530, "lng": 2.3499, "address": "Notre-Dame de Paris" },
            "time": "10:05 AM",
            "status": "Resolved",
            "criticality": "high",
            "contact": "+44 7700 900077"
        },
        {
            "id": "EMG-0895",
            "touristName": "Carlos Mendoza",
            "userId": "U-T112",
            "type": "Assault",
            "location": { "lat": 48.8867, "lng": 2.3431, "address": "Montmartre, Paris" },
            "time": "11:25 AM",
            "status": "Pending",
            "criticality": "high",
            "contact": "+34 600 123 456"
        }
    ];
    let activeFilter = 'all'; // 'all' or 'critical'
    let selectedAlertId = null;
    let map = null;
    let mapMarkers = {};

    // 1. Live Clock
    function updateClock() {
        const now = new Date();
        liveClock.textContent = now.toLocaleTimeString('en-US', { hour12: false });
    }
    setInterval(updateClock, 1000);
    updateClock();

    // 2. Network Status
    function updateNetworkStatus() {
        if (navigator.onLine) {
            networkStatus.className = 'network-status online';
            networkStatus.querySelector('.status-text').textContent = 'Online';
        } else {
            networkStatus.className = 'network-status offline';
            networkStatus.querySelector('.status-text').textContent = 'Offline';
        }
    }
    window.addEventListener('online', updateNetworkStatus);
    window.addEventListener('offline', updateNetworkStatus);
    updateNetworkStatus();

    // 3. Initialize Map (Leaflet)
    function initMap() {
        // Center of Paris
        map = L.map('map').setView([48.8566, 2.3522], 13);
        
        L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OSM</a> &copy; <a href="https://carto.com/">CARTO</a>',
            subdomains: 'abcd',
            maxZoom: 20
        }).addTo(map);
    }

    // Custom Icon
    const getMarkerIcon = (isCritical, isSelected) => {
        let classes = 'custom-marker';
        if (isCritical) classes += ' pulse';
        if (isSelected) classes += ' selected';
        
        return L.divIcon({
            className: classes,
            iconSize: [16, 16],
            iconAnchor: [8, 8],
            popupAnchor: [0, -10]
        });
    };

    // 4. Load Data
    function loadData() {
        // Data is hardcoded above to avoid CORS issues on local file:// protocol
        renderDashboard();
    }

    // 5. Render Functions
    function renderDashboard() {
        updateStats();
        renderAlerts();
        updateMapMarkers();
        updateNotificationBadge();
    }

    function updateStats() {
        const total = alertsData.length;
        const active = alertsData.filter(a => a.status === 'Pending' || a.status === 'Responding').length;
        const resolved = alertsData.filter(a => a.status === 'Resolved').length;

        animateValue(statTotal, parseInt(statTotal.textContent) || 0, total, 500);
        animateValue(statActive, parseInt(statActive.textContent) || 0, active, 500);
        animateValue(statResolved, parseInt(statResolved.textContent) || 0, resolved, 500);
    }

    function updateNotificationBadge() {
        const unread = alertsData.filter(a => a.status === 'Pending').length;
        notificationBadge.textContent = unread;
    }

    function renderAlerts() {
        alertsList.innerHTML = '';
        
        const filteredData = alertsData.filter(alert => {
            if (activeFilter === 'critical') return alert.criticality === 'high';
            return true;
        });

        if (filteredData.length === 0) {
            alertsList.innerHTML = '<p style="color:var(--text-secondary);text-align:center;padding:20px;">No alerts match this filter.</p>';
            return;
        }

        filteredData.forEach(alert => {
            const isCritical = alert.criticality === 'high';
            const isActiveCase = alert.id === selectedAlertId;
            
            const card = document.createElement('div');
            card.className = `alert-card ${isCritical ? 'critical' : ''} ${isActiveCase ? 'active-case' : ''}`;
            card.onclick = () => selectAlert(alert.id);

            const statusClass = alert.status.toLowerCase();

            card.innerHTML = `
                <div class="alert-header">
                    <div class="tourist-info">
                        <h3 class="name">${alert.touristName}</h3>
                        <span class="id">${alert.id} &bull; ${alert.userId}</span>
                    </div>
                    <span class="tag ${statusClass}">${alert.status}</span>
                </div>
                <div class="alert-details">
                    <div class="detail-row">
                        <i class="ph ${getTypeIcon(alert.type)} text-${getTypeColor(alert.type)}"></i>
                        <span>${alert.type}</span>
                    </div>
                    <div class="detail-row">
                        <i class="ph ph-map-pin"></i>
                        <span>${alert.location.address}</span>
                    </div>
                    <div class="detail-row">
                        <i class="ph ph-clock"></i>
                        <span>${alert.time}</span>
                    </div>
                </div>
            `;
            alertsList.appendChild(card);
        });
    }

    function updateMapMarkers() {
        // Clear existing markers
        Object.values(mapMarkers).forEach(marker => map.removeLayer(marker));
        mapMarkers = {};

        alertsData.forEach(alert => {
            const isCritical = alert.criticality === 'high';
            const isSelected = alert.id === selectedAlertId;
            
            const marker = L.marker([alert.location.lat, alert.location.lng], {
                icon: getMarkerIcon(isCritical, isSelected)
            }).addTo(map);

            marker.bindPopup(`
                <div style="font-family:Inter; padding:4px;">
                    <strong style="color:var(--text-primary); font-size:14px;">${alert.type} - ${alert.touristName}</strong><br>
                    <span style="color:var(--text-secondary); font-size:12px;">${alert.location.address}</span><br>
                    <span style="color:${alert.status === 'Resolved' ? 'var(--accent-green)' : 'var(--accent-red)'}; font-size:12px; font-weight:bold;">${alert.status}</span>
                </div>
            `);

            marker.on('click', () => selectAlert(alert.id));
            mapMarkers[alert.id] = marker;
            
            if (isSelected) {
                marker.openPopup();
            }
        });
    }

    function selectAlert(id) {
        selectedAlertId = id;
        renderAlerts(); // update active styling
        
        const alert = alertsData.find(a => a.id === id);
        if (alert) {
            // Center map
            map.flyTo([alert.location.lat, alert.location.lng], 16, { animate: true, duration: 1 });
            
            // Open popup
            setTimeout(() => {
                if (mapMarkers[id]) mapMarkers[id].openPopup();
            }, 500);

            renderCaseDetails(alert);
        }
    }

    function renderCaseDetails(alert) {
        const isPending = alert.status === 'Pending';
        const isResponding = alert.status === 'Responding';
        const isResolved = alert.status === 'Resolved';

        let actionButtons = '';
        if (isPending) {
            actionButtons = `<button class="action-btn btn-primary" onclick="window.updateAlertStatus('${alert.id}', 'Responding')">
                                <i class="ph ph-siren"></i> Accept Case
                             </button>
                             <button class="action-btn btn-success" onclick="window.updateAlertStatus('${alert.id}', 'Resolved')">
                                <i class="ph ph-check-circle"></i> Mark Resolved
                             </button>`;
        } else if (isResponding) {
             actionButtons = `<button class="action-btn btn-success" onclick="window.updateAlertStatus('${alert.id}', 'Resolved')">
                                <i class="ph ph-check-circle"></i> Mark Resolved
                             </button>`;
        } else {
             actionButtons = `<button class="action-btn btn-secondary" disabled>
                                <i class="ph ph-lock-key"></i> Case Closed
                             </button>`;
        }

        caseDetailsPanel.innerHTML = `
            <div class="case-info-content fade-in">
                <div class="case-info-main">
                    <div class="case-info-header">
                        <div class="case-meta">
                            <h2>${alert.type} Emergency</h2>
                            <p>Reported at ${alert.time} &bull; ID: ${alert.id}</p>
                        </div>
                        <span class="tag ${alert.status.toLowerCase()}">${alert.status}</span>
                    </div>
                    
                    <div class="case-data-grid">
                        <div class="data-group">
                            <span class="data-label">Tourist Name</span>
                            <span class="data-value"><i class="ph ph-user"></i> ${alert.touristName} (${alert.userId})</span>
                        </div>
                        <div class="data-group">
                            <span class="data-label">Contact</span>
                            <span class="data-value"><i class="ph ph-phone"></i> ${alert.contact}</span>
                        </div>
                        <div class="data-group">
                            <span class="data-label">Location</span>
                            <span class="data-value"><i class="ph ph-map-pin"></i> ${alert.location.address}</span>
                        </div>
                        <div class="data-group">
                            <span class="data-label">Coordinates</span>
                            <span class="data-value" style="font-family:monospace; font-size:11px;"><i class="ph ph-crosshair"></i> ${alert.location.lat.toFixed(4)}, ${alert.location.lng.toFixed(4)}</span>
                        </div>
                    </div>
                </div>
                
                <div class="case-actions">
                    ${actionButtons}
                    <button class="action-btn btn-secondary" onclick="window.openLocation('${alert.location.lat}', '${alert.location.lng}')">
                        <i class="ph ph-navigation-arrow"></i> Directions
                    </button>
                </div>
            </div>
        `;
    }

    // Global action handlers for inline HTML onclick
    window.updateAlertStatus = (id, newStatus) => {
        const alertIndex = alertsData.findIndex(a => a.id === id);
        if (alertIndex !== -1) {
            alertsData[alertIndex].status = newStatus;
            
            // Re-render everything with new state
            renderDashboard();
            if (selectedAlertId === id) {
                renderCaseDetails(alertsData[alertIndex]);
                mapMarkers[id].bindPopup(`
                    <div style="font-family:Inter; padding:4px;">
                        <strong style="color:var(--text-primary); font-size:14px;">${alertsData[alertIndex].type} - ${alertsData[alertIndex].touristName}</strong><br>
                        <span style="color:var(--text-secondary); font-size:12px;">${alertsData[alertIndex].location.address}</span><br>
                        <span style="color:${newStatus === 'Resolved' ? 'var(--accent-green)' : 'var(--accent-red)'}; font-size:12px; font-weight:bold;">${newStatus}</span>
                    </div>
                `).openPopup();
            }
        }
    };

    window.openLocation = (lat, lng) => {
        map.flyTo([lat, lng], 18, { animate: true, duration: 1.5 });
    };

    // Filter Controls
    filterBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            filterBtns.forEach(b => b.classList.remove('active'));
            e.target.classList.add('active');
            activeFilter = e.target.dataset.filter;
            renderAlerts();
        });
    });

    // Helper functions
    function getTypeIcon(type) {
        switch(type.toLowerCase()) {
            case 'medical': return 'ph-first-aid';
            case 'theft': return 'ph-mask-sad';
            case 'lost person': return 'ph-users';
            case 'accident': return 'ph-car-profile';
            case 'assault': return 'ph-warning-octagon';
            default: return 'ph-warning';
        }
    }

    function getTypeColor(type) {
        switch(type.toLowerCase()) {
            case 'medical': return 'red';
            case 'theft': return 'yellow';
            case 'lost person': return 'blue';
            case 'accident': return 'red';
            default: return 'red';
        }
    }

    // Number animation
    function animateValue(obj, start, end, duration) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            obj.innerHTML = Math.floor(progress * (end - start) + start);
            if (progress < 1) {
                window.requestAnimationFrame(step);
            } else {
                // Ensure final value is exact
                obj.innerHTML = end;
            }
        };
        window.requestAnimationFrame(step);
    }

    // Add fade-in CSS dynamically
    const style = document.createElement('style');
    style.innerHTML = `
        .fade-in { animation: fadeIn 0.4s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }
    `;
    document.head.appendChild(style);

    // Initialize
    initMap();
    loadData();
});
