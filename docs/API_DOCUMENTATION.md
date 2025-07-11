# POS Engine API Documentation

## Base URL
```
http://localhost:3000/api
```

## Authentication
All endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Test Credentials
- **Email:** maria.esposito@example.com
- **Password:** password123
- **Business ID:** 1

---

## Authentication Endpoints

### Login
**POST** `/auth/login`

**Required Fields:**
- `email` (string)
- `password` (string)

**Request Body:**
```json
{
  "email": "maria.esposito@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "maria.esposito@example.com",
    "businessId": 1
  }
}
```

---

## Sales Endpoints

### Create Sale (Simple)
**POST** `/sales`

**Required Fields:**
- `userId` (integer)
- `totalAmount` (number)

**Optional Fields:**
- `customerId` (integer)
- `taxAmount` (number)
- `discountAmount` (number)
- `finalAmount` (number)
- `paymentMethod` (string: "cash", "card", "check")
- `status` (string: "pending", "completed", "cancelled", "refunded")
- `notes` (string)

**Request Body:**
```json
{
  "userId": 1,
  "totalAmount": 1193.49,
  "customerId": 1,
  "taxAmount": 93.50,
  "discountAmount": 0,
  "finalAmount": 1193.49,
  "paymentMethod": "card",
  "status": "completed",
  "notes": "Customer requested extra napkins"
}
```

**Response:**
```json
{
  "message": "Sale created successfully",
  "sale": {
    "id": 1,
    "userId": 1,
    "totalAmount": 1193.49,
    "status": "completed",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

### Create Sale with Items
**POST** `/sales/with-items`

**Required Fields:**
- `orderItems` (array of objects with `itemId`, `quantity`, `unitPrice`)

**Optional Fields:**
- `customerName`, `customerEmail`, `subtotal`, `tax`, `discount`, `total`, `paymentMethod`, `status`

**Request Body:**
```json
{
  "customerName": "John Doe",
  "total": 1193.49,
  "orderItems": [
    {
      "itemId": 1,
      "quantity": 2,
      "unitPrice": 599.99
    },
    {
      "itemId": 2,
      "quantity": 1,
      "unitPrice": 299.99
    }
  ]
}
```

### Get All Sales
**GET** `/sales`

**Query Parameters:**
- `page` (optional, default: 1)
- `limit` (optional, default: 10)
- `status` (optional: "pending", "completed", "cancelled")
- `userId` (optional: integer)
- `startDate` (optional: YYYY-MM-DD)
- `endDate` (optional: YYYY-MM-DD)

**Response:**
```json
[
  {
    "id": 1,
    "customerName": "John Doe",
    "total": 1193.49,
    "status": "completed",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
]
```

### Get Sales Statistics
**GET** `/sales/stats`

**Response:**
```json
{
  "totalSales": 15000.50,
  "totalTransactions": 45,
  "averageOrderValue": 333.34,
  "topSellingItems": [
    {
      "itemId": 1,
      "totalQuantity": 25
    }
  ]
}
```

### Get Sales by User
**GET** `/sales/user/{userId}`

**Path Parameters:**
- `userId` (integer, required)

### Get Sale by ID
**GET** `/sales/{id}`

**Path Parameters:**
- `id` (integer, required)

### Update Sale
**PUT** `/sales/{id}`

**Path Parameters:**
- `id` (integer, required)

**Request Body:** (all fields optional)
```json
{
  "customerName": "Jane Doe",
  "total": 1299.99,
  "status": "completed"
}
```

### Delete Sale
**DELETE** `/sales/{id}`

**Path Parameters:**
- `id` (integer, required)

---

## Split Billing Endpoints

The API supports split billing through the sales endpoints, allowing multiple payments for a single sale.

### Create Sale with Split Payments
**POST** `/sales/split`

Creates a sale with multiple payments from different customers.

**Required Fields:**
- `userId` (integer) - User ID who created the sale
- `totalAmount` (number) - Total sale amount
- `payments` (array) - Array of payment objects

**Optional Fields:**
- `customerName` (string) - Customer name
- `customerPhone` (string) - Customer phone
- `customerEmail` (string) - Customer email
- `notes` (string) - Sale notes
- `items` (array) - Array of sale items

**Payment Object Required Fields:**
- `amount` (number) - Payment amount
- `method` (string) - Payment method (cash, credit_card, debit_card, mobile_payment, etc.)

**Payment Object Optional Fields:**
- `customerName` (string) - Customer name for this payment
- `customerPhone` (string) - Customer phone for this payment
- `reference` (string) - Payment reference number

**Request Body:**
```json
{
  "userId": 1,
  "totalAmount": 100.00,
  "customerName": "Group Order",
  "customerPhone": "555-1234",
  "customerEmail": "group@example.com",
  "notes": "Split between 3 people",
  "items": [
    {
      "itemId": 1,
      "quantity": 2,
      "unitPrice": 25.00
    },
    {
      "itemId": 2,
      "quantity": 1,
      "unitPrice": 50.00
    }
  ],
  "payments": [
    {
      "amount": 40.00,
      "method": "credit_card",
      "customerName": "John Doe",
      "customerPhone": "555-1111",
      "reference": "CC123456"
    },
    {
      "amount": 35.00,
      "method": "cash",
      "customerName": "Jane Smith",
      "customerPhone": "555-2222"
    },
    {
      "amount": 25.00,
      "method": "debit_card",
      "customerName": "Bob Wilson",
      "customerPhone": "555-3333",
      "reference": "DC789012"
    }
  ]
}
```

**Response:**
```json
{
  "message": "Split sale created successfully",
  "sale": {
    "id": 1,
    "totalAmount": 100.00,
    "status": "completed",
    "payments": [
      {
        "amount": 40.00,
        "method": "credit_card",
        "customerName": "John Doe",
        "customerPhone": "555-1111",
        "reference": "CC123456",
        "paidAt": "2025-01-01T00:00:00.000Z"
      }
    ],
    "createdAt": "2025-01-01T00:00:00.000Z"
  }
}
```

**Business Logic Requirements:**
- Total of all payment amounts must equal the totalAmount
- Sale status is automatically set to "completed" when all payments are received
- Each payment is timestamped with paidAt

### Add Payment to Existing Sale
**POST** `/sales/{saleId}/payments`

Adds an additional payment to an existing sale (useful for partial payments).

**Path Parameters:**
- `saleId` (integer, required) - Sale ID

**Required Fields:**
- `amount` (number) - Payment amount
- `method` (string) - Payment method

**Optional Fields:**
- `customerName` (string) - Customer name for this payment
- `customerPhone` (string) - Customer phone for this payment
- `reference` (string) - Payment reference number

**Request Body:**
```json
{
  "amount": 25.00,
  "method": "cash",
  "customerName": "Alice Johnson",
  "customerPhone": "555-4444",
  "reference": "CASH001"
}
```

**Response:**
```json
{
  "message": "Payment added successfully",
  "sale": {
    "id": 1,
    "totalAmount": 100.00,
    "status": "completed",
    "payments": [...],
    "totalPaid": 100.00
  }
}
```

**Business Logic Requirements:**
- Sale status updates to "completed" when totalPaid >= totalAmount
- Sale status remains "pending" if totalPaid < totalAmount

### Get Sale with Split Payment Details
**GET** `/sales/{id}`

Retrieves a sale with all its split payment details.

**Path Parameters:**
- `id` (integer, required) - Sale ID

**Response:**
```json
{
  "id": 1,
  "totalAmount": 100.00,
  "status": "completed",
  "customerName": "Group Order",
  "customerPhone": "555-1234",
  "customerEmail": "group@example.com",
  "notes": "Split between 3 people",
  "payments": [
    {
      "amount": 40.00,
      "method": "credit_card",
      "customerName": "John Doe",
      "customerPhone": "555-1111",
      "reference": "CC123456",
      "paidAt": "2025-01-01T00:00:00.000Z"
    },
    {
      "amount": 35.00,
      "method": "cash",
      "customerName": "Jane Smith",
      "customerPhone": "555-2222",
      "paidAt": "2025-01-01T00:00:00.000Z"
    },
    {
      "amount": 25.00,
      "method": "debit_card",
      "customerName": "Bob Wilson",
      "customerPhone": "555-3333",
      "reference": "DC789012",
      "paidAt": "2025-01-01T00:00:00.000Z"
    }
  ],
  "totalPaid": 100.00,
  "remainingAmount": 0.00,
  "createdAt": "2025-01-01T00:00:00.000Z",
  "updatedAt": "2025-01-01T00:00:00.000Z"
}
```

**Business Logic Requirements:**
- totalPaid = sum of all payment amounts
- remainingAmount = totalAmount - totalPaid
- If remainingAmount <= 0, sale is considered fully paid

### Refund a Split Payment
**POST** `/sales/{saleId}/refund`

Refunds a specific payment from a split sale.

**Path Parameters:**
- `saleId` (integer, required) - Sale ID

**Required Fields:**
- `paymentIndex` (integer) - Index of the payment to refund (0-based)
- `refundAmount` (number) - Amount to refund

**Optional Fields:**
- `reason` (string) - Reason for refund

**Request Body:**
```json
{
  "paymentIndex": 0,
  "refundAmount": 20.00,
  "reason": "Customer requested partial refund"
}
```

**Response:**
```json
{
  "message": "Refund processed successfully",
  "sale": {
    "id": 1,
    "totalAmount": 100.00,
    "status": "completed",
    "refundAmount": 20.00,
    "totalPaid": 80.00
  }
}
```

**Business Logic Requirements:**
- refundAmount cannot exceed the original payment amount
- Refund is added as a negative payment to the payments array
- Sale status updates based on new totalPaid amount
- If totalPaid < 0, sale status becomes "refunded"

### Get Split Billing Statistics
**GET** `/sales/split/stats`

Retrieves statistics about split billing usage.

**Response:**
```json
{
  "totalSplitSales": 15,
  "totalAmount": 2500.00,
  "averageSplitAmount": 166.67,
  "averagePaymentsPerSale": 2.8
}
```

**Business Logic Requirements:**
- Only counts sales with more than 1 payment
- Provides insights for business analytics

---

## Orders Endpoints (Restaurant/Food Service)

### Create Order
**POST** `/orders`

**Required Fields:**
- `orderType` (string: "dine_in", "takeaway", "delivery")
- `items` (array of objects with `itemId`, `quantity`)

**Optional Fields:**
- `customerId` (number)
- `tableId` (number)
- `notes` (string)

**Request Body:**
```json
{
  "orderType": "dine_in",
  "tableId": 1,
  "items": [
    {
      "itemId": 1,
      "quantity": 2,
      "notes": "Extra spicy"
    },
    {
      "itemId": 2,
      "quantity": 1
    }
  ],
  "notes": "Window seat"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "orderNumber": "ORD-1704067200000-123",
    "orderType": "dine_in",
    "status": "pending",
    "subtotal": 25.98,
    "taxAmount": 2.60,
    "totalAmount": 28.58,
    "orderItems": [...]
  },
  "message": "Order created successfully"
}
```

---

## Items Endpoints

### Get All Items
**GET** `/items`

**Query Parameters:**
- `page` (optional, default: 1)
- `limit` (optional, default: 10)

**Response:**
```json
[
  {
    "id": 1,
    "name": "Margherita Pizza",
    "price": 12.99,
    "category": "Pizza",
    "description": "Classic tomato and mozzarella",
    "sku": "PIZZA-001",
    "barcode": "1234567890123"
  }
]
```

### Search Items
**GET** `/items/search`

**Query Parameters:**
- `q` (string, required) - Search term

### Get Items by Category
**GET** `/items/category/{category}`

**Path Parameters:**
- `category` (string, required)

### Get Item by ID
**GET** `/items/{id}`

**Path Parameters:**
- `id` (integer, required)

### Create Item
**POST** `/items`

**Required Fields:**
- `name` (string)
- `price` (number)
- `stock` (integer)
- `category` (string)
- `sku` (string)

**Optional Fields:**
- `description` (string)
- `barcode` (string)

**Request Body:**
```json
{
  "name": "Pepperoni Pizza",
  "price": 14.99,
  "stock": 50,
  "category": "Pizza",
  "sku": "PEP001",
  "description": "Spicy pepperoni with cheese",
  "barcode": "1234567890124"
}
```

### Update Item
**PUT** `/items/{id}`

**Path Parameters:**
- `id` (integer, required)

**Request Body:** (all fields optional)
```json
{
  "name": "Updated Pizza Name",
  "price": 15.99,
  "stock": 45
}
```

### Delete Item
**DELETE** `/items/{id}`

**Path Parameters:**
- `id` (integer, required)

### Update Item Stock
**PUT** `/items/{id}/stock`

**Path Parameters:**
- `id` (integer, required)

---

## Error Responses

All endpoints return errors in this format:
```json
{
  "error": "Error message description"
}
```

Common HTTP Status Codes:
- `400` - Bad Request (missing required fields)
- `401` - Unauthorized (invalid or missing token)
- `404` - Not Found
- `500` - Internal Server Error

---

## Important Notes

1. **For Simple Sales**: Use `POST /sales` with just `customerName` and `total`
2. **For Sales with Items**: Use `POST /sales/with-items` with `orderItems` array (each item needs `itemId`, `quantity`, `unitPrice`)
3. **For Restaurant Orders**: Use `POST /orders` with `orderType` and `items` array (each item needs `itemId`, `quantity`)
4. **Authentication**: Always include `Authorization: Bearer <token>` header
5. **Business Context**: All operations are scoped to the authenticated user's business

---

## Complete Swagger Specification

For the complete OpenAPI 3.0 specification, see `swagger.yaml` in the project root. This file contains the full API documentation that can be imported into Swagger UI, Postman, or other API tools.