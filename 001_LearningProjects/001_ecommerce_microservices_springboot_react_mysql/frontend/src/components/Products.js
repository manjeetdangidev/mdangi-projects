import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Link, useNavigate } from 'react-router-dom';

const Products = () => {
    const [products, setProducts] = useState([]);
    const navigate = useNavigate();
    const BACKEND_URL = 'http://localhost:8080';

    // Mock products with images
    const mockProducts = [
        { id: 1, name: 'Laptop', price: 999.99, stock: 10, image: '/images/product1.jpg' },
        { id: 2, name: 'Phone', price: 699.99, stock: 15, image: '/images/product2.jpg' },
        { id: 3, name: 'Tablet', price: 399.99, stock: 8, image: '/images/product3.jpg' },
        { id: 4, name: 'Watch', price: 299.99, stock: 20, image: '/images/product4.jpg' },
        { id: 5, name: 'Headphones', price: 199.99, stock: 25, image: '/images/product5.jpg' },
        { id: 6, name: 'Camera', price: 799.99, stock: 5, image: '/images/product6.jpg' },
        { id: 7, name: 'Speaker', price: 149.99, stock: 12, image: '/images/product7.jpg' },
        { id: 8, name: 'Keyboard', price: 89.99, stock: 30, image: '/images/product8.jpg' },
        { id: 9, name: 'Mouse', price: 49.99, stock: 40, image: '/images/product9.jpg' },
        { id: 10, name: 'Monitor', price: 349.99, stock: 7, image: '/images/product10.jpg' }
    ];

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (!token) {
            window.location.href = '/login';
            return;
        }
        setProducts(mockProducts);
    }, []);

    const handleLogout = () => {
        localStorage.removeItem('token');
        navigate('/login');
    };

    const addToCart = async (product) => {
        const token = localStorage.getItem('token');
        const username = 'admin'; // In real app, extract from JWT
        
        try {
            await axios.post(`${BACKEND_URL}/cart`, {
                username,
                productId: product.id,
                productName: product.name,
                price: product.price,
                quantity: 1,
                imageUrl: product.image
            }, {
                headers: { Authorization: `Bearer ${token}` }
            });
            alert('Added to cart!');
        } catch (err) {
            console.error('Add to cart error:', err);
            alert('Failed to add to cart');
        }
    };

    return (
        <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                <h2>Products</h2>
                <div>
                    <Link to="/orders" style={{ marginRight: '10px', textDecoration: 'none', color: '#007bff' }}>View Orders</Link>
                    <Link to="/cart" style={{ marginRight: '10px', textDecoration: 'none', color: '#007bff' }}>View Cart</Link>
                    <button onClick={handleLogout} style={{ padding: '8px 16px', backgroundColor: '#dc3545', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>Logout</button>
                </div>
            </div>
            
            <div style={{ 
                display: 'grid', 
                gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))', 
                gap: '20px',
                maxHeight: '70vh',
                overflowY: 'auto',
                padding: '10px'
            }}>
                {products.map(product => (
                    <div key={product.id} style={{
                        border: '1px solid #ddd',
                        borderRadius: '8px',
                        padding: '15px',
                        backgroundColor: '#fff',
                        boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
                        display: 'flex',
                        flexDirection: 'column',
                        height: '350px'
                    }}>
                        <img 
                            src={product.image} 
                            alt={product.name}
                            style={{
                                width: '100%',
                                height: '150px',
                                objectFit: 'cover',
                                borderRadius: '4px',
                                backgroundColor: '#f0f0f0'
                            }}
                            onError={(e) => {
                                e.target.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxNCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPk5vIEltYWdlPC90ZXh0Pjwvc3ZnPg==';
                            }}
                        />
                        <h3 style={{ margin: '10px 0', fontSize: '18px', color: '#333' }}>{product.name}</h3>
                        <p style={{ margin: '5px 0', fontSize: '20px', fontWeight: 'bold', color: '#007bff' }}>${product.price}</p>
                        <p style={{ margin: '5px 0', color: '#666' }}>Stock: {product.stock}</p>
                        <button 
                            onClick={() => addToCart(product)}
                            style={{
                                marginTop: 'auto',
                                padding: '10px',
                                backgroundColor: '#28a745',
                                color: 'white',
                                border: 'none',
                                borderRadius: '4px',
                                cursor: 'pointer',
                                fontSize: '16px'
                            }}
                            onMouseOver={(e) => e.target.style.backgroundColor = '#218838'}
                            onMouseOut={(e) => e.target.style.backgroundColor = '#28a745'}
                        >
                            Add to Cart
                        </button>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default Products;