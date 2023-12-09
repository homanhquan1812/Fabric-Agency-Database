CREATE TABLE Operational_staff
(
    emp_id VARCHAR(15) NOT NULL,
    emp_fname VARCHAR(15) NOT NULL,
    emp_lname VARCHAR(15) NOT NULL,
    emp_gender VARCHAR(7) NOT NULL,
    e_addr VARCHAR(63) NOT NULL,
    CONSTRAINT op_staff_pk PRIMARY KEY (emp_id),
    CONSTRAINT check_op_gender CHECK (emp_gender='MALE' OR emp_gender='FEMALE')
);


CREATE TABLE Office_staff
(
    emp_id VARCHAR(15) NOT NULL,
    emp_fname VARCHAR(15) NOT NULL,
    emp_lname VARCHAR(15) NOT NULL,
    emp_gender VARCHAR(7) NOT NULL,
    e_addr VARCHAR(63) NOT NULL,
    CONSTRAINT offi_staff_pk PRIMARY KEY (emp_id),
    CONSTRAINT check_offi_gender CHECK (emp_gender='MALE' OR emp_gender='FEMALE')
);


CREATE TABLE Partner_staff
(
    emp_id VARCHAR(15) NOT NULL,
    emp_fname VARCHAR(15) NOT NULL,
    emp_lname VARCHAR(15) NOT NULL,
    emp_gender VARCHAR(7) NOT NULL,
    e_addr VARCHAR(63) NOT NULL,
    CONSTRAINT part_staff_pk PRIMARY KEY (emp_id),
    CONSTRAINT check_part_gender CHECK (emp_gender='MALE' OR emp_gender='FEMALE')
);

CREATE TABLE Ope_phone_num
(
    emp_id VARCHAR(15) NOT NULL,
    emp_phone_number VARCHAR(15) NOT NULL UNIQUE,
    CONSTRAINT op_phone_fk FOREIGN KEY (emp_id) REFERENCES Operational_staff (emp_id) ON DELETE CASCADE
);

CREATE TABLE Off_phone_num
(
    emp_id VARCHAR(15) NOT NULL,
    emp_phone_number VARCHAR(15) NOT NULL UNIQUE,
    CONSTRAINT offi_phone_fk FOREIGN KEY (emp_id) REFERENCES Office_staff (emp_id) ON DELETE CASCADE
);

CREATE TABLE Par_phone_num
(
    emp_id VARCHAR(15) NOT NULL,
    emp_phone_number VARCHAR(15) NOT NULL UNIQUE,
    CONSTRAINT part_phone_fk FOREIGN KEY (emp_id) REFERENCES Partner_staff (emp_id) ON DELETE CASCADE
);

CREATE TABLE Suppliers
(
    sup_id VARCHAR(15) NOT NULL,
    sup_name VARCHAR(15) NOT NULL,
    sup_addr VARCHAR(63) NOT NULL,
    sup_bankacc VARCHAR(31) NOT NULL UNIQUE,
    sup_taxcode VARCHAR(31)NOT NULL UNIQUE,
    e_id VARCHAR(15) NOT NULL,
    CONSTRAINT sup_pk PRIMARY KEY (sup_id),
    CONSTRAINT sup_part_fk FOREIGN KEY (e_id) REFERENCES Partner_staff (emp_id) ON DELETE CASCADE
);

CREATE TABLE Supplier_phone_num
(
    sup_id VARCHAR(15) NOT NULL,
    sup_phone_number VARCHAR(15) NOT NULL UNIQUE,
    CONSTRAINT sup_phone_fk FOREIGN KEY (sup_id) REFERENCES Suppliers (sup_id) ON DELETE CASCADE
);

CREATE TABLE Fabric_categories
(
    fab_id VARCHAR(15) NOT NULL,
    fab_name VARCHAR(15) NOT NULL,
    fab_color VARCHAR(15) NOT NULL,
    fab_quantity INT NOT NULL,
    sup_id VARCHAR(15) NOT NULL,
    CONSTRAINT fab_pk PRIMARY KEY(fab_id),  
    CONSTRAINT fab_sup_fk FOREIGN KEY (sup_id) REFERENCES Suppliers (sup_id) ON DELETE CASCADE,
    CONSTRAINT check_fab_quantity CHECK (fab_quantity >= 0)
);

CREATE TABLE Current_price
(
    fab_id VARCHAR(15) NOT NULL,
    pri_date DATE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    CONSTRAINT cur_price_pk PRIMARY KEY(fab_id, pri_date, price),
    CONSTRAINT cur_price_fab FOREIGN KEY (fab_id) REFERENCES Fabric_categories(fab_id) ON DELETE CASCADE
);

CREATE TABLE Supply
(
    sup_id VARCHAR(15) NOT NULL,
    fab_id VARCHAR(15) NOT NULL,
    purchase_date DATE NOT NULL,
    purchase_price DECIMAL (10,2),
    sup_quantity INT NOT NULL,
    CONSTRAINT supply_pk PRIMARY KEY (sup_id, fab_id),
    CONSTRAINT supply_sup_fk FOREIGN KEY (sup_id) REFERENCES Suppliers (sup_id) ON DELETE CASCADE,
    CONSTRAINT supply_fab_fk FOREIGN KEY (fab_id) REFERENCES Fabric_categories (fab_id) ON DELETE CASCADE,
    CONSTRAINT check_sup_quantity CHECK (sup_quantity >= 0)
);

CREATE TABLE Customers
(
    cus_id VARCHAR(15) NOT NULL,
    cus_fname VARCHAR(15) NOT NULL,
    cus_lname VARCHAR(15) NOT NULL,
    cus_arrearage DECIMAL(10,2) NOT NULL,
    cus_addr VARCHAR(63) NOT NULL,
    emp_id VARCHAR(15) NOT NULL,
    CONSTRAINT cus_pk PRIMARY KEY (cus_id),
    CONSTRAINT check_cus_arrearage CHECK (cus_arrearage >= 0),
    CONSTRAINT emp_proc_cus_fk FOREIGN KEY (emp_id) REFERENCES Office_staff (emp_id) ON DELETE CASCADE
);

CREATE TABLE Cus_phone_num
(
    cus_id VARCHAR(15) NOT NULL,
    cus_phone_number VARCHAR(15) NOT NULL UNIQUE,
    CONSTRAINT cus_phone_fk FOREIGN KEY (cus_id) REFERENCES Customers (cus_id) ON DELETE CASCADE
);

CREATE TABLE Orders
(
    order_id VARCHAR(15),
    order_price DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(15) NOT NULL,
    proc_date DATE,
    emp_id VARCHAR(15) NOT NULL,
    cus_id VARCHAR(15) NOT NULL,
    order_unpaid_debt DECIMAL(10,2),
    CONSTRAINT order_pk PRIMARY KEY (order_id),
    CONSTRAINT check_order_price CHECK (order_price >= 0),
    CONSTRAINT ord_emp_fk FOREIGN KEY (emp_id) REFERENCES Operational_staff (emp_id) ON DELETE CASCADE,
    CONSTRAINT ord_cus_fk FOREIGN KEY (cus_id) REFERENCES Customers (cus_id) ON DELETE CASCADE
);
/
CREATE OR REPLACE TRIGGER add_orders AFTER INSERT ON Orders 
FOR EACH ROW
BEGIN
    UPDATE Customers SET cus_arrearage=cus_arrearage+:NEW.order_price
    WHERE Customers.cus_id=:NEW.cus_id;
END;
/
CREATE OR REPLACE TRIGGER remove_orders AFTER DELETE ON Orders 
FOR EACH ROW
BEGIN
    UPDATE Customers SET cus_arrearage=cus_arrearage-:OLD.order_price
    WHERE Customers.cus_id=:OLD.cus_id;
END;
/
CREATE OR REPLACE TRIGGER update_orders AFTER UPDATE ON Orders 
FOR EACH ROW
BEGIN
    UPDATE Customers SET cus_arrearage=cus_arrearage-:OLD.order_price+:NEW.order_price
    WHERE Customers.cus_id=:OLD.cus_id;
END;
/
CREATE TABLE Bolts
(
    bolt_id VARCHAR(15),
    bolt_length DECIMAL (10,2) NOT NULL,
    fab_id VARCHAR(15),
    order_id VARCHAR(15),
    CONSTRAINT bolt_pk PRIMARY KEY(bolt_id),
    CONSTRAINT bolt_fab_fk FOREIGN KEY (fab_id) REFERENCES Fabric_categories(fab_id) ON DELETE CASCADE,
    CONSTRAINT bolt_order_fk FOREIGN KEY (order_id) REFERENCES Orders (order_id) ON DELETE CASCADE
);
/
CREATE OR REPLACE TRIGGER bolts_delete AFTER DELETE ON Bolts
FOR EACH ROW
BEGIN
    UPDATE fabric_categories SET fab_quantity=fab_quantity-1 WHERE  fabric_categories.fab_id=:OLD.fab_id;
END;
/
CREATE OR REPLACE TRIGGER bolts_add AFTER INSERT ON Bolts
FOR EACH ROW
BEGIN
    UPDATE fabric_categories SET fab_quantity=fab_quantity+1 WHERE fabric_categories.fab_id=:NEW.fab_id;
END;
/
CREATE TABLE Payments
(
    pay_id VARCHAR(15) NOT NULL,
    pay_date DATE NOT NULL,
    pay_amount DECIMAL(10,2) NOT NULL,
    order_id VARCHAR(15),
    CONSTRAINT pay_pk PRIMARY KEY(pay_id),
    CONSTRAINT pay_order_fk FOREIGN KEY (order_id) REFERENCES Orders (order_id) ON DELETE CASCADE
);
/
CREATE OR REPLACE TRIGGER payment_insert AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    UPDATE Customers SET cus_arrearage = cus_arrearage-:NEW.pay_amount
    WHERE Customers.cus_id=(SELECT cus_id FROM Orders WHERE Orders.order_id=:NEW.order_id);
    UPDATE Orders SET order_unpaid_debt = order_unpaid_debt-:NEW.pay_amount
    WHERE Orders.order_id=:NEW.order_id;
END;
/

---------------------------------INSERT DATA----------------------------------------


ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

INSERT INTO Operational_staff VALUES ('1001', 'John', 'Smith', 'MALE', '731 Fondren, Houston, TX');
INSERT INTO Operational_staff VALUES ('1002', 'Alicia', 'Zelaya', 'FEMALE', '3321 Castle, Spring, TX');
INSERT INTO Operational_staff VALUES ('1003', 'Jennifer', 'Wallace', 'FEMALE', '291 Berry, Bellaire, TX');
INSERT INTO Operational_staff VALUES ('1004', 'Franklin', 'Wong', 'MALE', '638 Voss, Houston, TX');

INSERT INTO Office_staff VALUES ('1011', 'Ramesh', 'Narayan', 'MALE', '975 Fire Oak, Humble, TX');
INSERT INTO Office_staff VALUES ('1012', 'Joyce', 'English', 'FEMALE', '5631 Rice, Houston, TX');
INSERT INTO Office_staff VALUES ('1013', 'Ahmad', 'Jabbar', 'MALE', '980 Dallas, Houston, TX');
INSERT INTO Office_staff VALUES ('1014', 'James', 'Borg', 'MALE', '450 Stone, Houston, TX');

INSERT INTO Partner_staff VALUES ('1021', 'Amit', 'Patel', 'MALE', '456 Cedar Road, Sunnyvale, CA');
INSERT INTO Partner_staff VALUES ('1022', 'Sara', 'Johnson', 'FEMALE', '542 Pine Street, Pleasantville, NY');
INSERT INTO Partner_staff VALUES ('1023', 'Carlos', 'Rodriguez', 'MALE', '789 Maple Avenue, Springfield, IL');
INSERT INTO Partner_staff VALUES ('1024', 'Emily', 'Smith', 'FEMALE', '123 Oak Lane, Riverside, CA');

INSERT INTO Ope_phone_num VALUES ('1001','(555) 789-4321');
INSERT INTO Ope_phone_num VALUES ('1002','(555) 234-5678');
INSERT INTO Ope_phone_num VALUES ('1003','(555) 876-5432');
INSERT INTO Ope_phone_num VALUES ('1004','(555) 321-0987');

INSERT INTO Off_phone_num VALUES ('1011','(555) 789-0123');
INSERT INTO Off_phone_num VALUES ('1012','(555) 456-7890');
INSERT INTO Off_phone_num VALUES ('1013','(555) 890-1234');
INSERT INTO Off_phone_num VALUES ('1014','(555) 567-8901');

INSERT INTO Par_phone_num VALUES ('1021','(555) 012-3456');
INSERT INTO Par_phone_num VALUES ('1022','(555) 234-5678');
INSERT INTO Par_phone_num VALUES ('1023','(555) 789-0123');
INSERT INTO par_phone_num VALUES ('1024','(555) 456-7890');

INSERT INTO Suppliers VALUES ('S001', 'SilkyComp', '123 Main Street, Cityville, USA', '12345678', 'ABC123XYZ', '1021');
INSERT INTO Suppliers VALUES ('S002', 'TextTreasures', '456 Oak Avenue, Townsville, USA', '87654321', 'XYZ789ABC', '1022');
INSERT INTO Suppliers VALUES ('S003', 'CottonCraft', '789 Pine Lane, Villageton, USA', '56789012', 'GPL456DEF', '1023');
INSERT INTO Suppliers VALUES ('S004', 'LinenLoom', '987 Cedar Road, TechCity, USA', '34567890', 'TII789JKL', '1024');

INSERT INTO Supplier_phone_num VALUES ('S001','(555) 103-4767');
INSERT INTO Supplier_phone_num VALUES ('S002','(555) 243-5678');
INSERT INTO Supplier_phone_num VALUES ('S003','(555) 799-0903');
INSERT INTO Supplier_phone_num VALUES ('S004','(555) 326-7120');

INSERT INTO Fabric_categories VALUES ('F001', 'SILK', 'White', 10, 'S001');
INSERT INTO Fabric_categories VALUES ('F002', 'COTTON', 'Blue', 8, 'S003');
INSERT INTO Fabric_categories VALUES ('F003', 'LINEN', 'Beige', 12, 'S004');
INSERT INTO Fabric_categories VALUES ('F004', 'VELVET', 'Black', 15, 'S002');
INSERT INTO Fabric_categories VALUES ('F005', 'WOOL', 'Gray', 7, 'S001');
INSERT INTO Fabric_categories VALUES ('F006', 'DENIM', 'Indigo', 9, 'S002');
INSERT INTO Fabric_categories VALUES ('F007', 'RAYON', 'Green', 11, 'S003');
INSERT INTO Fabric_categories VALUES ('F008', 'POLYESTER', 'Red', 14, 'S004');
INSERT INTO Fabric_categories VALUES ('F009', 'SILK', 'Gold', 10, 'S001');
INSERT INTO Fabric_categories VALUES ('F010', 'COTTON', 'White', 8, 'S003');

INSERT INTO Current_price VALUES ('F001', '23-08-2022', 21);
INSERT INTO Current_price VALUES ('F002', '15-06-2022', 18);
INSERT INTO Current_price VALUES ('F003', '15-06-2022', 25);
INSERT INTO Current_price VALUES ('F004', '23-08-2022', 30);
INSERT INTO Current_price VALUES ('F005', '23-08-2022', 15);
INSERT INTO Current_price VALUES ('F006', '15-06-2022', 28);
INSERT INTO Current_price VALUES ('F007', '25-08-2022', 22);
INSERT INTO Current_price VALUES ('F008', '25-08-2022', 19);
INSERT INTO Current_price VALUES ('F009', '13-05-2023', 24);
INSERT INTO Current_price VALUES ('F010', '13-05-2022', 17);

INSERT INTO Supply VALUES ('S001', 'F001', '20-02-2022', 15, 10);
INSERT INTO Supply VALUES ('S001', 'F005', '20-02-2022', 12, 7);
INSERT INTO Supply VALUES ('S001', 'F009', '20-02-2022', 18, 10);
INSERT INTO Supply VALUES ('S002', 'F004', '18-02-2022', 23, 15);
INSERT INTO Supply VALUES ('S002', 'F006', '18-02-2022', 20, 9);
INSERT INTO Supply VALUES ('S003', 'F002', '18-02-2022', 14, 8);
INSERT INTO Supply VALUES ('S003', 'F007', '18-02-2022', 19, 11);
INSERT INTO Supply VALUES ('S003', 'F010', '18-02-2022', 13, 8);
INSERT INTO Supply VALUES ('S004', 'F003', '18-02-2022', 19, 12);
INSERT INTO Supply VALUES ('S004', 'F008', '18-02-2022', 13, 14);

INSERT INTO Customers VALUES ('C001', 'Albus', 'Potter', 0, '122 Cedar Road, Sunnyvale, CA', '1011');
INSERT INTO Customers VALUES ('C002', 'John', 'Doe', 0, '456 Oak Lane, Riverside, CA', '1012');
INSERT INTO Customers VALUES ('C003', 'Jane', 'Smith', 0, '789 Pine Street, Pleasantville, NY', '1013');
INSERT INTO Customers VALUES ('C004', 'Robert', 'Johnson', 0, '987 Maple Avenue, Springfield, IL', '1014');
INSERT INTO Customers VALUES ('C005', 'Emily', 'Williams', 0, '543 Elm Street, Mystique City, AZ', '1014');

INSERT INTO Cus_phone_num VALUES ('C001', '(555) 173-3939');
INSERT INTO Cus_phone_num VALUES ('C001', '(555) 173-3938');
INSERT INTO Cus_phone_num VALUES ('C002', '(555) 146-7439');
INSERT INTO Cus_phone_num VALUES ('C003', '(555) 101-3482');
INSERT INTO Cus_phone_num VALUES ('C004', '(555) 563-2841');
INSERT INTO Cus_phone_num VALUES ('C005', '(555) 783-2945');

INSERT INTO Orders VALUES ('OA001', 54, 'full paid', '29-11-2023', '1001', 'C001', 54);
INSERT INTO Orders VALUES ('OA002', 42, 'full paid', '28-11-2023', '1001', 'C001', 42);
INSERT INTO Orders VALUES ('OA003', 50, 'full paid', '29-11-2023', '1002', 'C002', 42);
INSERT INTO Orders VALUES ('OA004', 90, 'full paid', '28-11-2023', '1002', 'C003', 90);
INSERT INTO Orders VALUES ('OA005', 57, 'full paid', '29-11-2023', '1003', 'C004', 57);
INSERT INTO Orders VALUES ('OA006', 66, 'full paid', '28-11-2023', '1004', 'C005', 66);

INSERT INTO Bolts VALUES ('B001', 1.4, 'F002', 'OA001');
INSERT INTO Bolts VALUES ('B002', 1.42, 'F002', 'OA001');
INSERT INTO Bolts VALUES ('B003', 1.41, 'F002', 'OA001');

INSERT INTO Bolts VALUES ('B004', 1.4, 'F001', 'OA002');
INSERT INTO Bolts VALUES ('B005', 1.42, 'F001', 'OA002');

INSERT INTO Bolts VALUES ('B006', 1.41, 'F003', 'OA003');
INSERT INTO Bolts VALUES ('B007', 1.41, 'F003', 'OA003');
INSERT INTO Bolts VALUES ('B008', 1.41, 'F003', 'OA003');

INSERT INTO Bolts VALUES ('B009', 1.21, 'F004', 'OA004');
INSERT INTO Bolts VALUES ('B010', 1.22, 'F004', 'OA004');
INSERT INTO Bolts VALUES ('B011', 1.2, 'F004', 'OA004');

INSERT INTO Bolts VALUES ('B012', 1.21, 'F009', 'OA005');
INSERT INTO Bolts VALUES ('B013', 1.22, 'F009', 'OA005');
INSERT INTO Bolts VALUES ('B014', 1.2, 'F009', 'OA005');

INSERT INTO Bolts VALUES ('B015', 1.22, 'F007', 'OA006');
INSERT INTO Bolts VALUES ('B016', 1.2, 'F007', 'OA006');
INSERT INTO Bolts VALUES ('B017', 1.21, 'F007', 'OA006');

INSERT INTO Payments VALUES ('P001', '29-11-2023', 30, 'OA001');
INSERT INTO Payments VALUES ('P002', '28-11-2023', 22, 'OA002');
INSERT INTO Payments VALUES ('P003', '29-11-2023', 25, 'OA003');
INSERT INTO Payments VALUES ('P004', '29-11-2023', 45, 'OA004');
INSERT INTO Payments VALUES ('P005', '29-11-2023', 44, 'OA005');
INSERT INTO Payments VALUES ('P006', '28-11-2023', 33, 'OA006');
