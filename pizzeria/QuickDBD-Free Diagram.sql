-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/OfPyoX
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

SET XACT_ABORT ON

BEGIN TRANSACTION QUICKDBD

CREATE TABLE [order] (
    [row_id] int NOT NULL PRIMARY KEY,
    [order_id] varchar(10) NOT NULL,
    [created_at] datetime NOT NULL,
    [item_id] varchar(10) NOT NULL,
    [quantity] int NOT NULL,
    [cust_id] int NOT NULL,
    [delivery] bit NOT NULL,
    [add_id] int NOT NULL
)

CREATE TABLE [customers] (
    [cust_id] int NOT NULL PRIMARY KEY,
    [cust_firstname] varchar(50) NOT NULL,
    [cust_lastname] varchar(50) NOT NULL
)

CREATE TABLE [address] (
    [add_id] int NOT NULL PRIMARY KEY,
    [delivery_address1] varchar(200) NOT NULL,
    [delivery_address2] varchar(200) NULL,
    [delivery_city] varchar(50) NOT NULL,
    [delivery_zipcode] varchar(20) NOT NULL
)

CREATE TABLE [item] (
    [item_id] varchar(10) NOT NULL PRIMARY KEY,
    [sku] varchar(20) NOT NULL,
    [item_name] varchar(50) NOT NULL,
    [item_cat] varchar(50) NOT NULL,
    [item_size] varchar(20) NOT NULL,
    [item_price] decimal(5,2) NOT NULL
)

CREATE TABLE [ingredient] (
    [ing_id] varchar(10) NOT NULL PRIMARY KEY,
    [ing_name] varchar(200) NOT NULL,
    [ing_weight] int NOT NULL,
    [ing_meas] varchar(20) NOT NULL,
    [ing_price] decimal(5,2) NOT NULL
)

CREATE TABLE [recipe] (
    [row_id] int NOT NULL PRIMARY KEY,
    [recipe_id] varchar(10) NOT NULL, -- Changed to match item_id length
    [ing_id] varchar(10) NOT NULL,
    [quantity] int NOT NULL,
    CONSTRAINT [FK_recipe_item] FOREIGN KEY ([recipe_id]) REFERENCES [item] ([item_id])
)

CREATE TABLE [inventory] (
    [inv_id] int NOT NULL PRIMARY KEY,
    [item_id] varchar(10) NOT NULL,
    [quantity] int NOT NULL,
    CONSTRAINT [FK_inventory_item] FOREIGN KEY ([item_id]) REFERENCES [item] ([item_id])
)

CREATE TABLE [shift] (
    [shift_id] varchar(20) NOT NULL PRIMARY KEY,
    [days_of_week] varchar(10) NOT NULL,
    [start_time] time NOT NULL,
    [end_time] time NOT NULL
)

CREATE TABLE [staff] (
    [staff_id] varchar(20) NOT NULL PRIMARY KEY,
    [first_name] varchar(50) NOT NULL,
    [last_name] varchar(50) NOT NULL,
    [position] varchar(100) NOT NULL,
    [hourly_rate] decimal(5,2) NOT NULL
)

CREATE TABLE [rota] (
    [row_id] int NOT NULL PRIMARY KEY,
    [rota_id] varchar(20) NOT NULL,
    [date] datetime NOT NULL,
    [shift_id] varchar(20) NOT NULL,
    [staff_id] varchar(20) NOT NULL,
    CONSTRAINT [FK_rota_staff] FOREIGN KEY ([staff_id]) REFERENCES [staff] ([staff_id]),
    CONSTRAINT [FK_rota_shift] FOREIGN KEY ([shift_id]) REFERENCES [shift] ([shift_id])
)

-- Define foreign key relationships
ALTER TABLE [order]
ADD CONSTRAINT [FK_order_customers] FOREIGN KEY([cust_id]) REFERENCES [customers]([cust_id]),
    CONSTRAINT [FK_order_address] FOREIGN KEY([add_id]) REFERENCES [address]([add_id]),
    CONSTRAINT [FK_order_item] FOREIGN KEY([item_id]) REFERENCES [item]([item_id])

ALTER TABLE [recipe]
ADD CONSTRAINT [FK_recipe_ingredient] FOREIGN KEY([ing_id]) REFERENCES [ingredient]([ing_id])

COMMIT TRANSACTION QUICKDBD
