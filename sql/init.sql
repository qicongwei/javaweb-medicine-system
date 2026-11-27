-- =============================================
-- 在线药品收费系统 - 数据库初始化脚本
-- 数据库: medicine_db
-- 编码: UTF-8
-- =============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS medicine_db
    DEFAULT CHARACTER SET utf8
    DEFAULT COLLATE utf8_general_ci;

USE medicine_db;

-- =============================================
-- 1. 用户表
-- =============================================
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS medicines;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码(MD5加密)',
    realname VARCHAR(50) NOT NULL COMMENT '真实姓名',
    phone VARCHAR(20) DEFAULT '' COMMENT '手机号',
    address VARCHAR(200) DEFAULT '' COMMENT '地址',
    role VARCHAR(20) DEFAULT 'user' COMMENT '角色: admin管理员, user普通用户',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- =============================================
-- 2. 药品分类表
-- =============================================
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    description VARCHAR(200) DEFAULT '' COMMENT '分类描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药品分类表';

-- =============================================
-- 3. 药品表
-- =============================================
CREATE TABLE medicines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '药品名称',
    category_id INT COMMENT '分类ID',
    price DECIMAL(10,2) NOT NULL COMMENT '单价',
    stock INT DEFAULT 0 COMMENT '库存数量',
    specification VARCHAR(100) DEFAULT '' COMMENT '规格(如: 10mg*12片)',
    manufacturer VARCHAR(100) DEFAULT '' COMMENT '生产厂家',
    description TEXT COMMENT '药品描述/功效',
    is_prescription TINYINT DEFAULT 0 COMMENT '是否处方药: 0否 1是',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药品表';

-- =============================================
-- 4. 购物车表
-- =============================================
CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '用户ID',
    medicine_id INT NOT NULL COMMENT '药品ID',
    quantity INT DEFAULT 1 COMMENT '数量',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='购物车表';

-- =============================================
-- 5. 订单表
-- =============================================
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(50) UNIQUE NOT NULL COMMENT '订单编号',
    user_id INT NOT NULL COMMENT '用户ID',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    status VARCHAR(20) DEFAULT 'pending' COMMENT '状态: pending待付款 paid已付款 completed已完成 cancelled已取消',
    receiver_name VARCHAR(50) DEFAULT '' COMMENT '收货人姓名',
    receiver_phone VARCHAR(20) DEFAULT '' COMMENT '收货人电话',
    receiver_address VARCHAR(200) DEFAULT '' COMMENT '收货地址',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
    pay_time DATETIME COMMENT '付款时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单表';

-- =============================================
-- 6. 订单明细表
-- =============================================
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL COMMENT '订单ID',
    medicine_id INT NOT NULL COMMENT '药品ID',
    medicine_name VARCHAR(100) NOT NULL COMMENT '药品名称(快照)',
    quantity INT NOT NULL COMMENT '购买数量',
    price DECIMAL(10,2) NOT NULL COMMENT '购买时单价',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单明细表';

-- =============================================
-- 初始化数据
-- =============================================

-- 管理员账号: admin / admin123 (MD5: 0192023a7bbd73250516f069df18b500)
INSERT INTO users(username, password, realname, phone, address, role)
VALUES ('admin', '0192023a7bbd73250516f069df18b500', '系统管理员', '13800000000', '系统管理部', 'admin');

-- 测试用户: test / test123
INSERT INTO users(username, password, realname, phone, address, role)
VALUES ('test', 'cc03e747a6afbbcbf8be7668acfebee5', '测试用户', '13900000000', '江苏省镇江市江苏大学', 'user');

-- 药品分类
INSERT INTO categories(name, description) VALUES ('感冒用药', '治疗感冒、发烧、咳嗽等症状的药品');
INSERT INTO categories(name, description) VALUES ('消化系统', '治疗胃痛、腹泻、消化不良等症状的药品');
INSERT INTO categories(name, description) VALUES ('心血管', '治疗高血压、心脏病等心血管疾病的药品');
INSERT INTO categories(name, description) VALUES ('抗生素', '抗感染类药品');
INSERT INTO categories(name, description) VALUES ('维生素与营养', '补充维生素和营养的药品及保健品');
INSERT INTO categories(name, description) VALUES ('外用药品', '外用药膏、消毒用品等');

-- 药品数据
INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('布洛芬缓释胶囊', 1, 18.50, 200, '0.3g*20粒', '中美天津史克', '用于缓解轻至中度疼痛如头痛、关节痛、偏头痛、牙痛、肌肉痛、神经痛、痛经。也用于普通感冒或流行性感冒引起的发热。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('氨酚烷胺胶囊', 1, 12.00, 150, '10粒/盒', '哈药集团', '适用于缓解普通感冒及流行性感冒引起的发热、头痛、四肢酸痛、打喷嚏、流鼻涕、鼻塞、咽痛等症状。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('连花清瘟胶囊', 1, 14.80, 300, '0.35g*24粒', '以岭药业', '清瘟解毒，宣肺泄热。用于治疗流行性感冒属热毒袭肺证。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('铝碳酸镁咀嚼片', 2, 22.00, 180, '0.5g*20片', '拜耳医药', '用于胃酸过多引起的胃痛、胃灼热感（烧心）、反酸。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('蒙脱石散', 2, 16.50, 250, '3g*10袋', '博福-益普生', '用于成人及儿童急、慢性腹泻。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('奥美拉唑肠溶胶囊', 2, 35.00, 120, '20mg*14粒', '阿斯利康', '适用于胃溃疡、十二指肠溃疡、应激性溃疡、反流性食管炎和卓-艾综合征(胃泌素瘤)。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('硝苯地平控释片', 3, 28.50, 100, '30mg*7片', '拜耳医药', '用于治疗高血压和心绞痛。', 1);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('阿托伐他汀钙片', 3, 45.00, 80, '20mg*7片', '辉瑞制药', '用于治疗高胆固醇血症和冠心病。', 1);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('阿莫西林胶囊', 4, 15.00, 300, '0.5g*24粒', '联邦制药', '适用于敏感菌（不产β内酰胺酶菌株）所致的感染。', 1);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('头孢拉定胶囊', 4, 20.00, 200, '0.25g*24粒', '华北制药', '适用于敏感菌所致的急性咽炎、扁桃体炎、中耳炎、支气管炎和肺炎等呼吸道感染。', 1);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('维生素C片', 5, 8.00, 500, '100mg*100片', '东北制药', '用于预防坏血病，也可用于各种急慢性传染疾病及紫癜等的辅助治疗。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('复合维生素B片', 5, 10.00, 400, '100片/瓶', '西南药业', '用于预防和治疗B族维生素缺乏所致的营养不良、厌食、脚气病、糙皮病等。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('红花油', 6, 15.00, 200, '30ml/瓶', '广州白云山', '用于风湿骨痛，跌打损伤，蚊虫叮咬。外用，涂擦患处。', 0);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('莫匹罗星软膏', 6, 25.00, 150, '5g:0.1g', '中美史克', '用于脓疱病、疖肿、毛囊炎等原发性皮肤感染及湿疹合并感染。', 1);

INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription)
VALUES ('板蓝根颗粒', 1, 9.50, 350, '10g*20袋', '广州白云山', '清热解毒，凉血利咽。用于肺胃热盛所致的咽喉肿痛、口咽干燥。', 0);
