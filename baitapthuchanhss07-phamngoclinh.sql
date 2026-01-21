CREATE DATABASE baitapthuchanhtrenlop;
USE baitapthuchanhtrenlop;

CREATE TABLE student (
    stu_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    class VARCHAR(255)
);

CREATE TABLE subject (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(255),
    credit INT
);

CREATE TABLE exam (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    stu_id INT,
    subject_id INT,
    exam_date DATE,
    mark INT,
    FOREIGN KEY (stu_id) REFERENCES student(stu_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id)
);
INSERT INTO student VALUES
(1,'An','CNTT1'),
(2,'Binh','CNTT1'),
(3,'Chi','CNTT2');

INSERT INTO subject VALUES
(1,'SQL',3),
(2,'Java',4),
(3,'OOP',3);

INSERT INTO exam VALUES
(1,1,1,'2024-06-01',8),
(2,1,1,'2024-07-01',9),
(3,2,1,'2024-06-01',6),
(4,2,1,'2024-06-01',7),
(5,3,1,'2024-06-01',9);

-- BÀI 1 – SUBQUERY
-- Sinh viên có điểm cao hơn điểm trung bình môn SQL
SELECT DISTINCT s.* FROM student s
JOIN exam e ON s.stu_id = e.stu_id
JOIN subject sub ON e.subject_id = sub.subject_id
WHERE sub.subject_name = 'SQL'
AND e.mark >
(
    SELECT AVG(e2.mark)
    FROM exam e2
    JOIN subject sub2 ON e2.subject_id = sub2.subject_id
    WHERE sub2.subject_name = 'SQL'
);

-- BÀI 2 – ANY
-- Sinh viên có ít nhất 1 môn ≥ ANY điểm của stu_id = 1
SELECT DISTINCT s.* FROM student s
JOIN exam e ON s.stu_id = e.stu_id
WHERE e.mark >= ANY
(
    SELECT mark
    FROM exam
    WHERE stu_id = 1
);

-- BÀI 3 – ALL
-- Sinh viên có tất cả điểm > ALL điểm của stu_id = 2
SELECT DISTINCT s.* FROM student s
JOIN exam e ON s.stu_id = e.stu_id
WHERE e.mark > ALL
(
    SELECT mark
    FROM exam
    WHERE stu_id = 2
);
-- BÀI 4 – EXISTS
-- Sinh viên đã từng thi môn SQL
SELECT s.* FROM student s
WHERE EXISTS
(
    SELECT 1
    FROM exam e
    JOIN subject sub ON e.subject_id = sub.subject_id
    WHERE e.stu_id = s.stu_id
    AND sub.subject_name = 'SQL'
);


-- BÀI 5 – JOIN + GROUP BY + HAVING
-- Môn học có điểm trung bình ≥ 8
SELECT sub.subject_name, AVG(e.mark) AS avg_mark
FROM exam e
JOIN subject sub ON e.subject_id = sub.subject_id
GROUP BY sub.subject_name
HAVING AVG(e.mark) >= 8;

-- BÀI 6 – SUBQUERY TRONG FROM
-- Mỗi sinh viên – điểm cao nhất của mỗi môn
SELECT s.stu_id, s.name, sub.subject_name, t.max_mark
FROM
(
    SELECT stu_id, subject_id, MAX(mark) AS max_mark
    FROM exam
    GROUP BY stu_id, subject_id
) t
JOIN student s ON t.stu_id = s.stu_id
JOIN subject sub ON t.subject_id = sub.subject_id;


-- BÀI 7 – WINDOW FUNCTION (RANK)
-- Xếp hạng sinh viên theo điểm cao nhất môn SQL
SELECT s.stu_id, s.name,
       MAX(e.mark) AS max_mark,
       RANK() OVER (ORDER BY MAX(e.mark) DESC) AS rank_sql
FROM student s
JOIN exam e ON s.stu_id = e.stu_id
JOIN subject sub ON e.subject_id = sub.subject_id
WHERE sub.subject_name = 'SQL'
GROUP BY s.stu_id, s.name;

-- BÀI 8 – ROW_NUMBER
-- Mỗi sinh viên & môn: lấy lần thi điểm cao nhất
-- (nếu trùng điểm → lấy lần thi sớm nhất)
SELECT *
FROM
(
    SELECT e.*,
           ROW_NUMBER() OVER (
               PARTITION BY stu_id, subject_id
               ORDER BY mark DESC, exam_date ASC
           ) AS rn
    FROM exam e
) t
WHERE rn = 1;

-- BÀI 9 – CTE (WITH)
-- Sinh viên có điểm trung bình cao nhất
WITH avg_score AS
(
    SELECT stu_id, AVG(mark) AS avg_mark
    FROM exam
    GROUP BY stu_id
)
SELECT s.* FROM student s
JOIN avg_score a ON s.stu_id = a.stu_id
WHERE a.avg_mark = (SELECT MAX(avg_mark) FROM avg_score);

-- BÀI 10 – TRUY VẤN THỰC TẾ
-- ≥ 2 môn ≥ 8 và không có môn nào < 5
SELECT s.* FROM student s WHERE
(
    SELECT COUNT(DISTINCT subject_id)
    FROM exam e
    WHERE e.stu_id = s.stu_id
    AND e.mark >= 8
) >= 2
AND NOT EXISTS
(
    SELECT 1
    FROM exam e
    WHERE e.stu_id = s.stu_id
    AND e.mark < 5
);
-- sync commit
