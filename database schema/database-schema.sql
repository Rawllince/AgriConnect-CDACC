
-- AGRICONNECT DATABASE SCHEMA (3NF NORMALIZED)
-- Entities: Users, Categories, Produce, Orders, Order_Items


-- 1. USERS TABLE
-- Stores both produce sellers ('farmer') and purchasers ('buyer').
CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Unique identifier for each user
    name VARCHAR(100) NOT NULL,                      -- Full name of the farmer or buyer
    email VARCHAR(150) NOT NULL UNIQUE,              -- Unique login email address
    password VARCHAR(255) NOT NULL,                  -- Bcrypt-hashed password (never plain text)
    role ENUM('farmer', 'buyer') NOT NULL,           -- Controls access to Farmer Dashboard vs Buyer Checkout
    phone VARCHAR(20) NOT NULL,                      -- Safaricom/Airtel number for M-Pesa STK Push & contact
    location VARCHAR(100),                           -- County or town (e.g., Homa Bay, Migori, Kisumu)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP   -- Account registration timestamp
);

-- 2. CATEGORIES TABLE
-- Lookup table used to classify produce for catalogue filtering.
CREATE TABLE Categories (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Unique category identifier
    name VARCHAR(80) NOT NULL UNIQUE,                -- Category title (e.g., Vegetables, Fruits, Grains)
    description TEXT,                                -- Brief overview of items in this category
    icon_url VARCHAR(255)                            -- Optional UI icon or banner path
);

-- 3. PRODUCE TABLE
-- Stores active farm listings created by registered farmers.
CREATE TABLE Produce (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Unique produce listing ID
    farmer_id INT NOT NULL,                          -- Links listing to the farmer who posted it
    category_id INT NOT NULL,                        -- Links listing to its produce category
    name VARCHAR(120) NOT NULL,                      -- Crop/product title (e.g., Grade-A Red Tomatoes)
    description TEXT,                                -- Quality details, harvest date, or farming notes
    price_per_unit DECIMAL(10, 2) NOT NULL CHECK (price_per_unit >= 0), -- Unit price in KES
    unit VARCHAR(30) NOT NULL DEFAULT 'kg',          -- Selling unit (kg, crate, bag, tray, litre)
    quantity_available INT NOT NULL DEFAULT 0 CHECK (quantity_available >= 0), -- Live stock count
    image_url VARCHAR(255),                          -- Path or URL to produce photo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date/time listing was published

    -- Foreign Key Constraints
    CONSTRAINT fk_produce_farmer
        FOREIGN KEY (farmer_id) REFERENCES Users(id)
        ON DELETE CASCADE,                           -- Remove listings if farmer account is deleted
    CONSTRAINT fk_produce_category
        FOREIGN KEY (category_id) REFERENCES Categories(id)
        ON DELETE RESTRICT                           -- Prevent deleting a category that still has produce
);

-- 4. ORDERS TABLE
-- Stores checkout headers, delivery destinations, and M-Pesa payment status.
CREATE TABLE Orders (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Unique order tracking ID
    buyer_id INT NOT NULL,                           -- Links order to the purchasing buyer
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0), -- Grand total (items + delivery) in KES
    delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 300.00, -- County transport fee in KES
    delivery_county VARCHAR(100) NOT NULL,           -- Destination county for logistics
    delivery_address VARCHAR(255) NOT NULL,          -- Specific town, market, or drop-off point
    payment_method ENUM('mpesa', 'cod') NOT NULL DEFAULT 'mpesa', -- M-Pesa Express or Cash on Delivery
    mpesa_receipt VARCHAR(50) UNIQUE,                -- Safaricom transaction code (e.g., QK89X21L), NULL until paid
    status ENUM('pending', 'confirmed', 'in_transit', 'delivered', 'cancelled')
        NOT NULL DEFAULT 'pending',                  -- Tracks order lifecycle from checkout to delivery
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Order placement timestamp

    -- Foreign Key Constraints
    CONSTRAINT fk_orders_buyer
        FOREIGN KEY (buyer_id) REFERENCES Users(id)
        ON DELETE RESTRICT                           -- Preserve financial order history even if user deactivates
);

-- 5. ORDER_ITEMS TABLE (Junction / Associative Entity)
-- Resolves the Many-to-Many (M:N) relationship between Orders and Produce.
CREATE TABLE Order_Items (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Unique line-item identifier
    order_id INT NOT NULL,                           -- Parent order ID
    produce_id INT NOT NULL,                         -- Specific produce item purchased
    quantity INT NOT NULL CHECK (quantity > 0),      -- Number of units purchased (must be at least 1)
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0), -- Locked-in price at time of order (protects against future price edits)
    subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),     -- Calculated line total (quantity * unit_price)

    -- Foreign Key Constraints
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES Orders(id)
        ON DELETE CASCADE,                           -- Automatically delete line items if parent order is deleted
    CONSTRAINT fk_order_items_produce
        FOREIGN KEY (produce_id) REFERENCES Produce(id)
        ON DELETE RESTRICT                           -- Prevent deleting produce referenced in past receipts
);


-- PERFORMANCE INDEXES
-- Speeds up common catalogue searches, farmer dashboards, and order tracking.

CREATE INDEX idx_produce_category ON Produce(category_id);
CREATE INDEX idx_produce_farmer ON Produce(farmer_id);
CREATE INDEX idx_orders_buyer ON Orders(buyer_id);
CREATE INDEX idx_orders_status ON Orders(status);
CREATE INDEX idx_order_items_order ON Order_Items(order_id);
