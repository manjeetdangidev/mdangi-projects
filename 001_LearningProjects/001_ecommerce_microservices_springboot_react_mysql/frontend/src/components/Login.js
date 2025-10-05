import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const Login = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const BACKEND_URL = 'http://localhost:8080'; // API Gateway URL

  const handleLogin = async (e) => {
    e.preventDefault();
    console.log('Login attempt:', { username, password }); // Debug log
    try {
      const res = await axios.post(`${BACKEND_URL}/auth/login`, { username, password });
      console.log('Login response:', res.data); // Debug: Check token
      if (res.data && res.data.length > 10) { // Basic token validity check (JWTs are long)
        localStorage.setItem('token', res.data);
        alert('Login successful!'); // Add confirmation
        navigate('/products');
      } else {
        throw new Error('Invalid token received');
      }
    } catch (err) {
      console.error('Login error details:', err.response?.data || err.message); // Detailed error
      alert(`Login failed: ${err.response?.data?.message || err.message || 'Unknown error'}`);
    }
  };

  const handleRegister = async (e) => {
    e.preventDefault();
    console.log('Register attempt:', { username, password }); // Debug log
    try {
      const res = await axios.post(`${BACKEND_URL}/auth/register`, { username, password, email: `${username}@example.com` });
      console.log('Register response:', res.data); // Debug: Check token
      if (res.data && res.data.length > 10) { // Basic token validity check
        localStorage.setItem('token', res.data);
        alert('Registration successful! Welcome!'); // Add confirmation
        navigate('/products');
      } else {
        throw new Error('Invalid token received');
      }
    } catch (err) {
      console.error('Register error details:', err.response?.data || err.message); // Detailed error
      alert(`Registration failed: ${err.response?.data?.message || err.message || 'Unknown error'}`);
    }
  };

  return (
      <div style={{ padding: '20px' }}>
        <h2>Ecommerce Login/Register</h2>
        <form onSubmit={handleLogin}>
          <input
              type="text"
              placeholder="Username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
          />
          <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
          />
          <button type="submit">Login</button>
          <button type="button" onClick={handleRegister}>Register</button>
        </form>
      </div>
  );
};

export default Login;