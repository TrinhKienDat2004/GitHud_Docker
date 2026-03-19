CREATE DATABASE IF NOT EXISTS cv_profile_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cv_profile_db;

CREATE TABLE IF NOT EXISTS profile (
  id           BIGINT PRIMARY KEY AUTO_INCREMENT,
  full_name    VARCHAR(100)        NOT NULL,
  major        VARCHAR(150)        NOT NULL,
  university   VARCHAR(200)        NOT NULL,
  start_year   INT                 NOT NULL,
  end_year     INT                 NOT NULL,
  gpa          DECIMAL(3,2),
  phone        VARCHAR(20),
  email        VARCHAR(150),
  address      VARCHAR(200),
  summary      TEXT
);

CREATE TABLE IF NOT EXISTS skill (
  id          BIGINT PRIMARY KEY AUTO_INCREMENT,
  profile_id  BIGINT              NOT NULL,
  name        VARCHAR(100)        NOT NULL,
  category    VARCHAR(100),
  CONSTRAINT fk_skill_profile FOREIGN KEY (profile_id)
    REFERENCES profile(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS project (
  id          BIGINT PRIMARY KEY AUTO_INCREMENT,
  profile_id  BIGINT              NOT NULL,
  name        VARCHAR(150)        NOT NULL,
  tech_stack  VARCHAR(255),
  description TEXT,
  CONSTRAINT fk_project_profile FOREIGN KEY (profile_id)
    REFERENCES profile(id) ON DELETE CASCADE
);

INSERT INTO profile (
  full_name,
  major,
  university,
  start_year,
  end_year,
  gpa,
  phone,
  email,
  address,
  summary
)
VALUES (
  'Trịnh Kiển Đạt',
  'Công nghệ Phần mềm',
  'Đại học Công nghệ TP. Hồ Chí Minh (HUTECH)',
  2022,
  2026,
  2.80,
  '0389473201',
  'Trinhkiendat2004',
  'Gò Vấp, TP. Hồ Chí Minh',
  'Sinh viên năm 4 chuyên ngành Công nghệ Phần mềm, có kinh nghiệm phát triển web với JavaScript, React và Node.js. Mong muốn trở thành Software Developer để phát triển các hệ thống web có khả năng mở rộng và đóng góp vào các dự án thực tế.'
)
ON DUPLICATE KEY UPDATE
  full_name = VALUES(full_name);

INSERT INTO skill (profile_id, name, category)
SELECT id, 'C#', 'Ngôn ngữ lập trình' FROM profile WHERE full_name = 'Trịnh Kiển Đạt'
UNION ALL
SELECT id, 'Java', 'Ngôn ngữ lập trình' FROM profile WHERE full_name = 'Trịnh Kiển Đạt'
UNION ALL
SELECT id, 'PHP', 'Ngôn ngữ lập trình' FROM profile WHERE full_name = 'Trịnh Kiển Đạt'
UNION ALL
SELECT id, 'HTML / CSS / JavaScript', 'Frontend' FROM profile WHERE full_name = 'Trịnh Kiển Đạt'
UNION ALL
SELECT id, 'ReactJS', 'Frontend' FROM profile WHERE full_name = 'Trịnh Kiển Đạt'
UNION ALL
SELECT id, 'NodeJS', 'Backend' FROM profile WHERE full_name = 'Trịnh Kiển Đạt'
UNION ALL
SELECT id, 'MySQL', 'Database' FROM profile WHERE full_name = 'Trịnh Kiển Đạt'
UNION ALL
SELECT id, 'SQL Server', 'Database' FROM profile WHERE full_name = 'Trịnh Kiển Đạt';

INSERT INTO project (profile_id, name, tech_stack, description)
SELECT
  id,
  'Website đặt Homestay',
  'HTML, CSS, JavaScript, ReactJS, NodeJS, MySQL',
  'Xây dựng trang web đặt homestay cho phép người dùng tìm kiếm, xem chi tiết và đặt phòng; quản lý thông tin phòng, lịch đặt và người dùng.'
FROM profile
WHERE full_name = 'Trịnh Kiển Đạt'
ON DUPLICATE KEY UPDATE
  tech_stack = VALUES(tech_stack);

