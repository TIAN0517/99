// 全局类型定义

export interface User {
    id: string;
    username: string;
    role: 'admin' | 'manager' | 'employee';
    name: string;
    avatar?: string;
    lastLogin?: Date;
}

export interface GasProduct {
    id: string;
    name: string;
    type: 'lpg' | 'natural' | 'industrial';
    size: string; // 如：5kg, 15kg, 50kg
    price: number;
    cost: number;
    stock: number;
    supplier: string;
    lastUpdated: Date;
}

export interface Order {
    id: string;
    customerId: string;
    customerName: string;
    customerPhone: string;
    customerAddress: string;
    products: OrderItem[];
    totalAmount: number;
    status: 'pending' | 'processing' | 'delivered' | 'cancelled';
    orderDate: Date;
    deliveryDate?: Date;
    notes?: string;
}

export interface OrderItem {
    productId: string;
    productName: string;
    quantity: number;
    unitPrice: number;
    subtotal: number;
}

export interface Customer {
    id: string;
    name: string;
    phone: string;
    address: string;
    email?: string;
    customerType: 'individual' | 'business';
    registrationDate: Date;
    totalOrders: number;
    totalSpent: number;
}

export interface FinancialRecord {
    id: string;
    type: 'income' | 'expense';
    category: string;
    amount: number;
    description: string;
    date: Date;
    relatedOrderId?: string;
}

export interface AIChat {
    id: string;
    message: string;
    response: string;
    timestamp: Date;
    userId: string;
}

export interface DashboardStats {
    todayRevenue: number;
    monthlyRevenue: number;
    totalOrders: number;
    pendingOrders: number;
    lowStockProducts: number;
    totalCustomers: number;
}

// Electron API 类型
declare global {
    interface Window {
        electronAPI: {
            window: {
                minimize: () => Promise<void>;
                maximize: () => Promise<void>;
                close: () => Promise<void>;
            };
            ai: {
                chat: (message: string) => Promise<any>;
            };
            system: {
                platform: string;
                version: string;
            };
            developer: {
                team: string;
                aiName: string;
            };
        };
    }
}
