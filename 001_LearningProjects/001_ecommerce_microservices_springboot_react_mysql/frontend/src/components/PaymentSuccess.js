import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';

const PaymentSuccess = () => {
    const location = useLocation();
    const navigate = useNavigate();
    const { message, transactionId } = location.state || {};

    const handleLogout = () => {
        localStorage.removeItem('token');
        navigate('/login');
    };

    return (
        <div style={{ 
            padding: '40px', 
            textAlign: 'center', 
            fontFamily: 'Arial, sans-serif',
            maxWidth: '600px',
            margin: '0 auto'
        }}>
            <div style={{ marginBottom: '20px' }}>
                <button 
                    onClick={handleLogout} 
                    style={{ 
                        position: 'absolute', 
                        top: '20px', 
                        right: '20px',
                        padding: '8px 16px', 
                        backgroundColor: '#dc3545', 
                        color: 'white', 
                        border: 'none', 
                        borderRadius: '4px', 
                        cursor: 'pointer' 
                    }}
                >
                    Logout
                </button>
            </div>

            <div style={{
                backgroundColor: '#d4edda',
                border: '1px solid #c3e6cb',
                borderRadius: '8px',
                padding: '30px',
                marginBottom: '30px'
            }}>
                <h1 style={{ color: '#155724', margin: '0 0 15px 0' }}>🎉 Payment Successful!</h1>
                <p style={{ color: '#155724', fontSize: '18px', margin: '0' }}>
                    {message || 'Your payment has been processed successfully!'}
                </p>
                {transactionId && (
                    <p style={{ color: '#155724', fontSize: '14px', marginTop: '10px' }}>
                        Transaction ID: <strong>{transactionId}</strong>
                    </p>
                )}
            </div>

            <div style={{ display: 'flex', justifyContent: 'center', gap: '15px', flexWrap: 'wrap' }}>
                <Link 
                    to="/orders" 
                    style={{
                        padding: '12px 24px',
                        backgroundColor: '#007bff',
                        color: 'white',
                        textDecoration: 'none',
                        borderRadius: '6px',
                        fontSize: '16px',
                        display: 'inline-block'
                    }}
                >
                    View Orders
                </Link>
                <Link 
                    to="/products" 
                    style={{
                        padding: '12px 24px',
                        backgroundColor: '#28a745',
                        color: 'white',
                        textDecoration: 'none',
                        borderRadius: '6px',
                        fontSize: '16px',
                        display: 'inline-block'
                    }}
                >
                    Continue Shopping
                </Link>
            </div>
        </div>
    );
};

export default PaymentSuccess;