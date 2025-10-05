import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Link, useNavigate } from 'react-router-dom';

const Orders = () => {
    const [orders, setOrders] = useState([]);
    const navigate = useNavigate();
    const BACKEND_URL = 'http://localhost:8080';

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            axios.get(`${BACKEND_URL}/orders`, {
                headers: { Authorization: `Bearer ${token}` }
            })
                .then(res => setOrders(res.data))
                .catch(err => {
                    console.error(err);
                    localStorage.removeItem('token');
                    window.location.href = '/login';
                });
        } else {
            window.location.href = '/login';
        }
    }, []);

    const handleLogout = () => {
        localStorage.removeItem('token');
        navigate('/login');
    };

    return (
        <div style={{ padding: '20px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                <h2>Orders</h2>
                <div>
                    <Link to="/products" style={{ marginRight: '10px', textDecoration: 'none', color: '#007bff' }}>Back to Products</Link>
                    <button onClick={handleLogout} style={{ padding: '8px 16px', backgroundColor: '#dc3545', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>Logout</button>
                </div>
            </div>
            <ul>
                {orders.map(o => (
                    <li key={o.id}>
                        Order #{o.id} - Product ID: {o.productId}, Qty: {o.quantity}, Total: ${o.totalPrice}, Status: {o.status}
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default Orders;