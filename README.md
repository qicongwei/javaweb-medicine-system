# javaweb-medicine-system

一个基于 Servlet + JSP + MVC 分层的在线药品收费系统，课程设计作品。

覆盖药品浏览与检索、购物车、下单结算、订单查询，以及后台的药品 / 用户 / 订单管理与销售统计。技术上刻意不用 Spring，把 Servlet 生命周期、过滤器链、JDBC 事务和 JSP 视图这几层基础手写一遍。

## 功能

**前台**

- 注册 / 登录（密码 MD5 摘要存储）
- 药品列表、分类筛选、关键词搜索、药品详情
- 购物车增删改，库存校验
- 下单结算、订单列表与详情

**后台**（需管理员角色）

- 仪表盘：药品数、用户数、订单数、销售额
- 药品管理：新增 / 编辑 / 上下架 / 库存调整
- 用户管理：新增 / 编辑 / 启停
- 订单管理：列表、详情、状态流转
- 销售统计

## 技术栈

| 层 | 实现 |
|---|---|
| 视图 | JSP + JSTL + 原生 CSS（27 个页面，含公共头 / 侧栏 / 页脚） |
| 控制 | Servlet 12 个，按业务域拆分 |
| 数据 | 手写 DAO 5 个 + `DBUtil` 连接工具，原生 JDBC |
| 鉴权 | `AuthFilter` 登录校验 + `AdminFilter` 角色校验 + `CartFilter` |
| 数据库 | MySQL 8，6 张表（`users` / `categories` / `medicines` / `cart_items` / `orders` / `order_items`） |
| 容器 | Tomcat 9（Servlet 4.0） |
| JDK | 8 及以上 |

## 项目结构

```
javaweb-medicine-system/
├── src/com/medicine/
│   ├── controller/     12 个 Servlet（登录注册 / 药品 / 购物车 / 订单 / 后台管理）
│   ├── dao/            5 个 DAO（User / Medicine / Category / Cart / Order）
│   ├── model/          5 个实体类
│   ├── filter/         AuthFilter / AdminFilter / CartFilter
│   └── util/           DBUtil / EncodingFilter / MD5Util
├── WebContent/
│   ├── admin/          11 个后台页面
│   ├── medicine/       列表 / 搜索 / 详情
│   ├── cart/ order/    购物车与订单
│   ├── common/         公共头、侧栏、页脚
│   ├── error/          404 / 500
│   └── WEB-INF/web.xml Servlet 与过滤器映射
├── sql/init.sql        建库建表 + 23 条种子数据
├── 启动系统.bat         一键启动：清端口 → 查 MySQL → 清 JSP 缓存 → 起 Tomcat → 开浏览器
└── 停止系统.bat
```

## 部署

**1. 建库**

```bash
mysql -u root -p < sql/init.sql
```

脚本会创建 `medicine_db`、6 张表并写入种子数据（分类 6 条、药品 15 条、演示账号 2 个）。

**2. 配置数据库连接**

源码里没有写死任何凭据，按以下优先级读取：

```bash
# 方式一：环境变量
set MEDICINE_DB_PASSWORD=你的密码
set MEDICINE_DB_USER=root
set MEDICINE_DB_URL=jdbc:mysql://localhost:3306/medicine_db?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true

# 方式二：JVM 参数（Tomcat 的 setenv.bat 里加）
-Dmedicine.db.password=你的密码
```

地址与用户名有默认值（`localhost:3306/medicine_db` / `root`），密码必须外部提供。

**3. 补依赖 jar**

`WebContent/WEB-INF/lib/` 下的 jar 未入库，需要自己放两个：

| jar | 用途 | 获取 |
|---|---|---|
| `mysql-connector-java-5.1.49.jar` | JDBC 驱动 | MySQL 官网 / Maven 中央仓库 |
| `servlet-api.jar` | 编译用 | 取自 Tomcat 的 `lib/` 目录 |

**4. 部署到 Tomcat**

把整个项目作为 Web 应用部署到 Tomcat 的 `webapps/ROOT`（或改 `启动系统.bat` 里的 `URL` 与上下文路径）。`启动系统.bat` 假设部署在 ROOT 下，启动后访问 `http://localhost:8080/`。

脚本里的 `TOMCAT_HOME` / `JAVA_HOME` 可按自己的安装位置改，或提前 `set` 好让脚本直接读。

**5. 演示账号**

| 角色 | 账号 | 密码 |
|---|---|---|
| 管理员 | `admin` | `admin123` |
| 普通用户 | `12` | `123456` |

_这两个账号来自 `sql/init.sql` 的种子数据，仅供本地演示。_

## 已知限制

1. **密码用 MD5 单次摘要**，且无盐。这在课程设计年代是常见做法，但不满足现代存储要求，仅作教学示例，不要用于真实业务。改造成 BCrypt 只需替换 `MD5Util` 与两处调用。
2. **支付是模拟的**：下单即标记为已支付，没有对接任何支付网关。
3. **无连接池**：`DBUtil` 每次 `DriverManager.getConnection`，高并发下会成为瓶颈。换 Druid / HikariCP 是标准改法。
4. **SQL 在 DAO 里拼接**，已用 `PreparedStatement` 传参，但复杂查询的可维护性一般。
5. 库存扣减与订单生成在同一事务内，但未处理超卖的重试，属教学取舍。

## 许可证

[MIT](LICENSE)
