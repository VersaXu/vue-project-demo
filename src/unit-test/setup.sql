-- Create Employee table
CREATE TABLE Employee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    group_id INT NOT NULL
);

-- Create Manager table
CREATE TABLE Manager (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    department VARCHAR(100) NOT NULL,
    group_id INT UNIQUE NOT NULL
);

-- Add foreign key constraint
ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (group_id) REFERENCES Manager(group_id);

-- Insert sample data into Manager table
INSERT INTO Manager (first_name, last_name, email, phone_number, hire_date, department, group_id)
VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '2020-01-01', 'IT', 1),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', '2019-05-15', 'HR', 2);

-- Insert sample data into Employee table
INSERT INTO Employee (first_name, last_name, email, phone_number, hire_date, job_title, salary, group_id)
VALUES 
('Alice', 'Johnson', 'alice.johnson@example.com', '555-123-4567', '2021-03-10', 'Software Developer', 75000.00, 1),
('Bob', 'Williams', 'bob.williams@example.com', '555-987-6543', '2021-04-22', 'HR Specialist', 65000.00, 2),
('Charlie', 'Brown', 'charlie.brown@example.com', '555-246-8135', '2021-06-30', 'System Administrator', 70000.00, 1);