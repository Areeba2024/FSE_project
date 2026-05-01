const API_BASE = 'http://localhost:5000/api';

const getToken = () => localStorage.getItem('scms_token');

const headers = () => ({
  'Content-Type': 'application/json',
  ...(getToken() ? { 'Authorization': `Bearer ${getToken()}` } : {})
});

const api = {
  async post(path, body) {
    const r = await fetch(`${API_BASE}${path}`, { method: 'POST', headers: headers(), body: JSON.stringify(body) });
    return r.json();
  },
  async get(path) {
    const r = await fetch(`${API_BASE}${path}`, { headers: headers() });
    return r.json();
  },
  async put(path, body) {
    const r = await fetch(`${API_BASE}${path}`, { method: 'PUT', headers: headers(), body: JSON.stringify(body) });
    return r.json();
  },
  async postForm(path, formData) {
    const r = await fetch(`${API_BASE}${path}`, {
      method: 'POST',
      headers: { ...(getToken() ? { 'Authorization': `Bearer ${getToken()}` } : {}) },
      body: formData
    });
    return r.json();
  }
};

export default api;
