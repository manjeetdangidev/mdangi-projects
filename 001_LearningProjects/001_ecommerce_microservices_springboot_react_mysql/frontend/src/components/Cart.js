import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Link, useNavigate } from 'react-router-dom';

const Cart = () => {
    const [cartItems, setCartItems] = useState([]);
    const navigate = useNavigate();
    const BACKEND_URL = 'http://localhost:8080';
    const username = 'admin'; // In real app, extract from JWT

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (!token) {
            window.location.href = '/login';
            return;
        }
        
        fetchCart();
    }, []);

    const fetchCart = async () => {
        try {
            const token = localStorage.getItem('token');
            const res = await axios.get(`${BACKEND_URL}/cart/${username}`, {
                headers: { Authorization: `Bearer ${token}` }
            });
            setCartItems(res.data);
        } catch (err) {
            console.error('Cart fetch error:', err);
        }
    };

    const handleLogout = () => {
        localStorage.removeItem('token');
        navigate('/login');
    };

    const getTotalPrice = () => {
        return cartItems.reduce((total, item) => total + (item.price * item.quantity), 0).toFixed(2);
    };

    const handlePayment = async () => {
        try {
            const token = localStorage.getItem('token');
            const paymentData = {
                username,
                items: cartItems,
                totalAmount: getTotalPrice()
            };

            const res = await axios.post(`${BACKEND_URL}/payment/process`, paymentData, {
                headers: { Authorization: `Bearer ${token}` }
            });

            if (res.data.status === 'success') {
                // Clear cart after successful payment
                await axios.delete(`${BACKEND_URL}/cart/${username}`, {
                    headers: { Authorization: `Bearer ${token}` }
                });
                
                navigate('/payment-success', { 
                    state: { 
                        message: res.data.message, 
                        transactionId: res.data.transactionId 
                    } 
                });
            }
        } catch (err) {
            console.error('Payment error:', err);
            alert('Payment failed. Please try again.');
        }
    };

    return (
        <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                <h2>Shopping Cart</h2>
                <div>
                    <Link to="/products" style={{ marginRight: '10px', textDecoration: 'none', color: '#007bff' }}>Back to Products</Link>
                    <button onClick={handleLogout} style={{ padding: '8px 16px', backgroundColor: '#dc3545', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>Logout</button>
                </div>
            </div>

            {cartItems.length === 0 ? (
                <p>Your cart is empty. <Link to="/products">Continue shopping</Link></p>
            ) : (
                <div>
                    <div style={{ marginBottom: '20px' }}>
                        {cartItems.map(item => (
                            <div key={item.id} style={{
                                display: 'flex',
                                alignItems: 'center',
                                padding: '15px',
                                border: '1px solid #ddd',
                                borderRadius: '8px',
                                marginBottom: '10px',
                                backgroundColor: '#fff'
                            }}>
                                <img 
                                    src={item.imageUrl} 
                                    alt={item.productName}
                                    style={{
                                        width: '80px',
                                        height: '80px',
                                        objectFit: 'cover',
                                        borderRadius: '4px',
                                        marginRight: '15px',
                                        backgroundColor: '#f0f0f0'
                                    }}
                                    onError={(e) => {
                                        e.target.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iODAiIGhlaWdodD0iODAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0iI2RkZCIvPjx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBmb250LWZhbWlseT0iQXJpYWwiIGZvbnQtc2l6ZT0iMTAiIGZpbGw9IiM5OTkiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGR5PSIuM2VtIj5ObyBJbWFnZTwvdGV4dD48L3N2Zz4=';
                                    }}
                                />
                                <div style={{ flex: 1 }}>
                                    <h4 style={{ margin: '0 0 5px 0' }}>{item.productName}</h4>
                                    <p style={{ margin: '0', color: '#666' }}>Quantity: {item.quantity}</p>
                                    <p style={{ margin: '5px 0 0 0', fontSize: '18px', fontWeight: 'bold', color: '#007bff' }}>${item.price}</p>
                                </div>
                            </div>
                        ))}
                    </div>

                    <div style={{ 
                        padding: '20px', 
                        border: '2px solid #007bff', 
                        borderRadius: '8px', 
                        backgroundColor: '#f8f9fa',
                        textAlign: 'center'
                    }}>
                        <h3 style={{ margin: '0 0 15px 0' }}>Total: ${getTotalPrice()}</h3>
                        <button 
                            onClick={handlePayment}
                            style={{
                                padding: '12px 30px',
                                backgroundColor: '#007bff',
                                color: 'white',
                                border: 'none',
                                borderRadius: '6px',
                                cursor: 'pointer',
                                fontSize: '18px',
                                fontWeight: 'bold'
                            }}
                            onMouseOver={(e) => e.target.style.backgroundColor = '#0056b3'}
                            onMouseOut={(e) => e.target.style.backgroundColor = '#007bff'}
                        >
                            Pay Now
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Cart;