# Split Payment Feature Guide

## Overview

The split payment feature allows customers to pay for a single order using multiple payment methods. This is useful for group orders, corporate accounts, or when customers want to split the bill between different payment methods.

## How to Use Split Payments

### 1. Adding Items to Cart
- Add items to the cart as usual
- The total amount will be calculated automatically

### 2. Initiating Split Payment
- Click the "Checkout" button in the cart section
- In the checkout dialog, click the "Split Payment" button (blue button with wallet icon)
- This will open the split payment dialog

### 3. Configuring Split Payments

#### Customer Information (Optional)
- **Customer Name**: Enter the main customer name for the order
- **Customer Phone**: Enter the main customer phone number
- **Customer Email**: Enter the main customer email address
- **Notes**: Add any special instructions or notes

#### Payment Methods
- **Add Payment**: Click to add additional payment methods
- **Remove Payment**: Click the red remove button to delete a payment (minimum 1 payment required)

#### For Each Payment:
- **Amount**: Enter the amount for this payment method
- **Payment Method**: Select from available options:
  - Cash
  - Credit Card
  - Debit Card
  - Mobile Payment
  - Check
- **Customer Name** (Optional): Specific customer name for this payment
- **Customer Phone** (Optional): Specific phone number for this payment
- **Reference** (Optional): Payment reference number (e.g., transaction ID)

### 4. Validation
The system will validate:
- All payment amounts must be greater than 0
- Payment methods must be selected
- Total of all payments must equal the order total
- If amounts don't match, you'll see a "Remaining" amount in red

### 5. Completing the Split Payment
- Click "Complete Split Payment" when validation passes
- The system will process all payments
- Cart will be cleared automatically
- Success message will be displayed

## Business Rules

### Payment Validation
- **Total Match**: Sum of all payment amounts must equal the order total
- **Minimum Payments**: At least one payment method is required
- **Amount Validation**: Each payment amount must be greater than 0

### Status Management
- **Completed**: When all payments are received and total is matched
- **Pending**: When partial payments are received
- **Refunded**: When refunds are processed

### Customer Information
- **Main Customer**: Optional overall customer for the order
- **Per-Payment Customer**: Optional individual customer info for each payment
- **Guest Orders**: Can proceed without customer information

## API Endpoints

The split payment feature uses these backend endpoints:

### Create Split Sale
```
POST /api/sales/split
```

### Add Payment to Existing Sale
```
POST /api/sales/{saleId}/payments
```

### Refund Split Payment
```
POST /api/sales/{saleId}/refund
```

### Get Split Billing Statistics
```
GET /api/sales/split/stats
```

## Use Cases

### 1. Group Dining
- Multiple people splitting a restaurant bill
- Each person pays their portion with different methods
- Example: $100 bill split as $40 credit card, $35 cash, $25 debit card

### 2. Corporate Accounts
- Company pays part of the bill
- Employee pays remaining amount
- Example: $50 meal with $30 company card, $20 personal cash

### 3. Gift Cards + Other Payment
- Customer uses gift card for partial payment
- Pays remaining amount with cash or card
- Example: $75 purchase with $50 gift card, $25 credit card

### 4. Multiple Cards
- Customer splits payment across multiple cards
- Useful when individual cards have spending limits
- Example: $200 purchase with $100 on each of two cards

## Troubleshooting

### Common Issues

1. **Amounts Don't Match**
   - Ensure total payment amount equals order total
   - Check for rounding errors (system allows small differences)

2. **Payment Method Not Available**
   - Verify the payment method is supported by your system
   - Contact administrator if additional methods are needed

3. **Customer Information Required**
   - Customer information is optional for split payments
   - You can proceed with guest checkout

4. **System Errors**
   - Check network connection
   - Verify backend API is running
   - Contact support if issues persist

### Error Messages

- **"Amount must be greater than 0"**: Enter a valid payment amount
- **"Payment method is required"**: Select a payment method for each payment
- **"Total payments must equal order total"**: Adjust payment amounts to match total

## Best Practices

1. **Verify Amounts**: Double-check payment amounts before completing
2. **Clear Communication**: Explain split payment process to customers
3. **Receipt Management**: Provide clear receipts showing all payment methods
4. **Customer Information**: Collect customer info when possible for better tracking
5. **Reference Numbers**: Use reference numbers for card payments when available

## Support

For technical support or questions about the split payment feature:
- Check the API documentation
- Review system logs for error details
- Contact the development team with specific error messages 