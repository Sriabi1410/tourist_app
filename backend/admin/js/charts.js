// Dashboard Charts
document.addEventListener('DOMContentLoaded', () => {
  const trendCtx = document.getElementById('trendChart');
  if (trendCtx) {
    new Chart(trendCtx.getContext('2d'), {
      type: 'line',
      data: {
        labels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
        datasets: [{
          label: 'Emergencies',
          data: [12, 18, 15, 22, 19, 25, 14, 16, 20, 17, 13, 15],
          borderColor: '#6C63FF',
          backgroundColor: 'rgba(108,99,255,0.1)',
          fill: true,
          tension: 0.4,
          borderWidth: 2,
          pointRadius: 4,
          pointBackgroundColor: '#6C63FF',
        }]
      },
      options: {
        responsive: true,
        plugins: { legend: { labels: { color: '#b0b8cc' } } },
        scales: {
          x: { ticks: { color: '#6b7280' }, grid: { color: '#1e254020' } },
          y: { ticks: { color: '#6b7280' }, grid: { color: '#1e254020' } }
        }
      }
    });
  }

  const typeCtx = document.getElementById('typeChart');
  if (typeCtx) {
    new Chart(typeCtx.getContext('2d'), {
      type: 'doughnut',
      data: {
        labels: ['Medical', 'Police', 'Fire', 'Theft', 'Harassment', 'Accident'],
        datasets: [{
          data: [45, 38, 12, 28, 15, 18],
          backgroundColor: ['#FF3B5C', '#3B82F6', '#FF8C00', '#EC4899', '#F59E0B', '#EF4444'],
          borderWidth: 0,
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { position: 'bottom', labels: { color: '#b0b8cc', padding: 16 } }
        }
      }
    });
  }
});
