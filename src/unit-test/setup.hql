
-- Create Employee table
CREATE TABLE Employee (
    id INT, -- Hive不支持AUTO_INCREMENT，因此移除此属性
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    group_id INT NOT NULL
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE; -- Hive需要指定存储格式，这里使用文本文件作为示例


-- Create Manager table
CREATE TABLE Manager (
    id INT, -- Hive不支持AUTO_INCREMENT，因此移除此属性
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    department VARCHAR(100) NOT NULL,
    group_id INT UNIQUE NOT NULL
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE; -- Hive需要指定存储格式，这里使用文本文件作为示例


-- 插入示例数据到Manager表（Hive不支持直接的INSERT INTO ... VALUES语句，通常使用LOAD DATA或INSERT INTO ... SELECT语句，但这里为了示例，我们假设有一个变通方法或工具支持这种插入）

-- 注意：在实际Hive使用中，数据通常通过外部文件加载或查询结果插入

-- INSERT INTO Manager ... VALUES 语句在Hive中不直接支持，这里仅作示意

-- 可以通过其他方式（如LOAD DATA INPATH）将数据加载到表中


-- 插入示例数据到Employee表（同上，Hive不支持直接的INSERT INTO ... VALUES语句）

-- INSERT INTO Employee ... VALUES 语句在Hive中不直接支持，这里仅作示意