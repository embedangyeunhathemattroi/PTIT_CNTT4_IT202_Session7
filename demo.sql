-- cac du lieu
-- bang : lop hoc
-- Ma lop hoc: khoa chinh
-- ma lop hoc, chuyen nganh
-- bang : sinh vien 
-- ma sinh vien: khoa chinh
-- ho ten
-- gioi tinh
-- ngay sinh
-- que quan 
-- ma lop hoc (FK)
-- yeu cau
-- hien thi so sinh vien moi lop hoc , bao gm : ma lop, ten lop, so sinh vien
-- C1: lam thong thuong :Join 2 bang vs nhau , nhom lai theo ma lop, dem so sinh vien 
-- Select c.class_id ,c,c.class_name , count (s.stu_id) as 'Total students'
-- from classes c join students s on c.class_id = s.class_id 
-- group by c.class_id;

-- C2: truy van long
-- select class_id, class_nae ,( select count ( stu_id) from students where class_id =classes.class_id) as 'Total' from classes


-- yeu cau 2: hien thi thong tin cac lop hoc chua co sinh vien nao
-- Select class_id, class_name from classes where class_id not in ( select distinct class_id from Students);
-- sync commit
