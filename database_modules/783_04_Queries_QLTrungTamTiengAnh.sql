-- *************************************************
-- *************************************************
-- Phan Hoàng Hải - 1 - 10
-- *************************************************
-- *************************************************
-- *************************************************



-- Function 1: Hàm hiển thị danh sách học viên của một lớp cùng với điểm giữa kỳ, 
-- cuối kỳ và điểm tổng kết của một lớp:

CREATE OR REPLACE FUNCTION public.get_student_scores(score_type VARCHAR(255), class_id VARCHAR(255))
RETURNS TABLE (
  StudentID VARCHAR(255),
  MidtermScore REAL,
  FinaltermScore REAL,
  TotalScore REAL
)
AS $$
BEGIN
  IF score_type = 'List' THEN
    RETURN QUERY
    SELECT
      s.StudentID,
      s.MidTermScore::real,
      s.FinalTermScore::real,
      ((s.MidTermScore * 0.3 + s.FinalTermScore * 0.7))::real AS TotalScore
    FROM public.Student_Status_At_Class s
    WHERE s.ClassID = get_student_scores.class_id;
  
  ELSIF score_type = 'Average' THEN
    RETURN QUERY
    SELECT 
      'Class Average'::varchar(255) AS StudentID,
      (AVG(s.MidTermScore))::real AS MidtermScore,
      (AVG(s.FinalTermScore))::real AS FinaltermScore,
      (AVG(s.MidTermScore * 0.3 + s.FinalTermScore * 0.7))::real AS TotalScore
    FROM public.Student_Status_At_Class s
    WHERE s.ClassID = get_student_scores.class_id;

  ELSE
    RAISE EXCEPTION 'Invalid score_type parameter. Use "List" or "Average".';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Example usage:
SELECT * FROM public.get_student_scores('List', 'IE3500001');
-- SELECT * FROM public.get_student_scores('Average', 'IE3500001');

-- Function 2: Hàm trả về 100 học sinh tiêu biểu để tuyên dương ở trung tâm:
CREATE OR REPLACE FUNCTION public.good_students_for_reward()
RETURNS TABLE (
    StudentID VARCHAR(255),
    StudentName VARCHAR(255),
    PhoneNumber VARCHAR(255),
    StudentAddress VARCHAR(255),
    CounselorID VARCHAR(255),
    ClassID VARCHAR(255),
    ClassName VARCHAR(255),
    IELTSScore REAL,
    EndCoursePoint REAL,
    Difference REAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ssac.StudentID,
    s.StudentName,
    s.PhoneNumber,
    s.StudentAddress,
    s.CounselorID,
    ssac.ClassID,
    c.ClassName,
    ssac.IELTSScore,
    ssac.EndCoursePoint,
    ssac.IELTSScore - ssac.EndCoursePoint AS Difference
  FROM public.Student_Status_At_Class ssac
  JOIN public.Student s ON ssac.StudentID = s.StudentID
  JOIN public.clazz c ON ssac.ClassID = c.ClassID
  WHERE ssac.IELTSScore IS NOT NULL
  ORDER BY ssac.IELTSScore DESC, ssac.IELTSScore - ssac.EndCoursePoint DESC
  LIMIT 100;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM public.good_students_for_reward();

-- Function 3: Hiển thị nội dung bài học, bài tập và ngày học - giờ học của một học viên:
CREATE OR REPLACE FUNCTION public.get_student_lesson_schedule10(student_id character varying)
RETURNS TABLE(
    student_name character varying(255),
    class_id character varying(255),
    lesson_unit character varying(255), 
    lesson_homework character varying(255),
    lesson_date date,  
    day_of_week text, 
    date_time text    
)
LANGUAGE plpgsql
AS $$
DECLARE
  opendate1 DATE;
  opendate2 DATE;
  opentime1 TIME;
  opentime2 TIME;
  endcoursepoint REAL;
  class_id VARCHAR(255);
  student_name VARCHAR(255); 
  start_course VARCHAR(255);
  end_course VARCHAR(255);
BEGIN
  SELECT 
    c.opendate1::DATE, c.opendate2::DATE, c.opentime1, c.opentime2, ss.endcoursepoint, ss.classid, s.studentname,
    CASE WHEN ss.classid LIKE 'IE35%' THEN 'IE35'  
         WHEN ss.classid LIKE 'IE45%' THEN 'IE45'
         WHEN ss.classid LIKE 'IE55%' THEN 'IE55'
         WHEN ss.classid LIKE 'IE65%' THEN 'IE65'
         ELSE NULL END AS start_course,
    CASE WHEN ss.endcoursepoint = 3.5 THEN 'IE35'
         WHEN ss.endcoursepoint = 4.5 THEN 'IE45'
         WHEN ss.endcoursepoint = 5.5 THEN 'IE55'
         WHEN ss.endcoursepoint = 6.5 THEN 'IE65'
         ELSE NULL END AS end_course
  INTO opendate1, opendate2, opentime1, opentime2, endcoursepoint, class_id, student_name, start_course, end_course
  FROM public.Student_Status_At_Class ss
  JOIN public.Clazz c ON ss.ClassID = c.ClassID
  JOIN public.Student s ON ss.StudentID = s.StudentID
  WHERE ss.StudentID = student_id;

  RETURN QUERY
  SELECT 
    student_name, 
    class_id,
    l.content AS lesson_unit,
    l.homework AS lesson_homework,
    CASE 
      WHEN MOD(CAST(SUBSTRING(l.lessonid, 5, 2) AS INT), 2) = 0 THEN (opendate2 + (CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) - 1) / 2 * INTERVAL '7 days')::DATE
      ELSE (opendate1 + (CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) - 1) / 2 * INTERVAL '7 days')::DATE
    END AS lesson_date,
    to_char(CASE 
              WHEN MOD(CAST(SUBSTRING(l.lessonid, 5, 2) AS INT), 2) = 0 THEN (opendate2 + (CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) - 1) / 2 * INTERVAL '7 days')::DATE
              ELSE (opendate1 + (CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) - 1) / 2 * INTERVAL '7 days')::DATE
            END, 'Day') AS day_of_week,
    to_char(CASE 
              WHEN MOD(CAST(SUBSTRING(l.lessonid, 5, 2) AS INT), 2) = 0 THEN (opendate2 + (CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) - 1) / 2 * INTERVAL '7 days')::DATE
              ELSE (opendate1 + (CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) - 1) / 2 * INTERVAL '7 days')::DATE
            END, 'Day') || ', ' ||
    to_char(CASE 
              WHEN MOD(CAST(SUBSTRING(l.lessonid, 5, 2) AS INT), 2) = 0 THEN opendate2 + (CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) - 1) / 2 * INTERVAL '7 days'
              ELSE opendate1 + (CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) - 1) / 2 * INTERVAL '7 days'
            END, 'YYYY-MM-DD') || ', ' ||
    to_char(CASE 
              WHEN CAST(SUBSTRING(l.lessonid, 5, 2) AS INT) % 2 = 1 THEN opentime1
              ELSE opentime2
            END, 'HH24:MI:SS') AS date_time
  FROM public.Lesson l
  WHERE l.courseid IN (
    SELECT unnested_course_id 
    FROM UNNEST(ARRAY[start_course, 'IE45', 'IE55', 'IE65']) AS unnested_course_id
    WHERE unnested_course_id IS NOT NULL 
    AND unnested_course_id <= end_course
  )
  ORDER BY l.lessonid;
END;
$$;

-- explain analyse
select * from public.get_student_lesson_schedule10('ST0071')

-- Function 4: Hàm để thêm thông tin học viên khi học viên đến trung tâm và 
-- tạo bài test đầu vào cho học viên đó:


CREATE OR REPLACE FUNCTION public.add_student_and_entrance_test(
    student_name character varying,
    phone_number character varying,
    student_address character varying,
    counselor_id character varying,
    entrance_date date,
    entrance_time time without time zone
) RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  new_student_id character varying;
  new_test_id character varying;
  meeting_link character varying;
  is_duplicate boolean;
BEGIN
  SELECT 'ST' || LPAD((COALESCE(MAX(SUBSTRING(StudentID, 3)::INT), 0) + 1)::TEXT, 4, '0') 
  INTO new_student_id
  FROM public.Student;

  INSERT INTO public.Student (StudentID, StudentName, PhoneNumber, StudentAddress, CounselorID) 
  VALUES (new_student_id, student_name, phone_number, student_address, counselor_id);

  new_test_id := 'TE' || SUBSTRING(new_student_id, 3);

  LOOP
    meeting_link := 'meet.google.com/' || (
      CASE
        WHEN random() < 0.5 THEN 'abc'
        ELSE 'def'
      END
    ) || (random() * 1000000)::INT::VARCHAR || '-' || (random() * 1000000)::INT::VARCHAR;

    SELECT EXISTS(SELECT 1 FROM public.Entrance_Test WHERE MeetingLink = meeting_link) INTO is_duplicate;
    IF NOT is_duplicate THEN
      EXIT;
    END IF;
  END LOOP;

  INSERT INTO public.Entrance_Test (TestID, GeneralScore, SpeakingScore, EntranceDate, EntranceTime, MeetingLink, TutorID, StudentID) 
  VALUES (new_test_id, NULL, NULL, entrance_date, entrance_time, meeting_link, NULL, new_student_id);
END;
$$;

-- Function 5: Hàm để cập nhật điểm bài test đầu vào sau khi giáo viên đã chấm xong:
CREATE OR REPLACE FUNCTION public.update_entrance_test_score(
  tutor_id VARCHAR(255),
  student_id VARCHAR(255),
  general_score REAL,
  speaking_score REAL
) RETURNS VOID AS $$
BEGIN
  UPDATE public.Entrance_Test
  SET GeneralScore = general_score,
      SpeakingScore = speaking_score,
      TutorID = tutor_id 
  WHERE StudentID = student_id;
END;
$$ LANGUAGE plpgsql;

SELECT public.update_entrance_test_score('TU0023', 'ST0005', 6.0, 5.5);

-- Function 6: Hàm để hiển thị các lớp học trùng giờ:
CREATE OR REPLACE FUNCTION public.find_overlapping_classes4(
    input_date DATE, 
    class_time TIME WITHOUT TIME ZONE
)
RETURNS TABLE (
    ClassID VARCHAR(255)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT c1.ClassID
    FROM public.Clazz AS c1
    JOIN public.Clazz AS c2 ON c1.ClassID <> c2.ClassID 
        AND c1.OpenDate1 <= c2.OpenDate2 AND c1.OpenDate2 >= c2.OpenDate1
        AND c1.OpenTime1 <= c2.OpenTime2 AND c1.OpenTime2 >= c2.OpenTime1
    WHERE 
        input_date BETWEEN c1.OpenDate1 AND c1.OpenDate2
        AND class_time BETWEEN c1.OpenTime1 AND c1.OpenTime2
        AND class_time BETWEEN c2.OpenTime1 AND c2.OpenTime2;
END;
$$ LANGUAGE plpgsql;

select * from public.find_overlapping_classes4('2022-07-04', '14:00:00');

-- Function 7: tìm ra danh sách học viên nghỉ học quá nhiều - có điểm tổng kết dưới 7 - 
-- hủy cam kết đầu ra:

CREATE OR REPLACE FUNCTION public.identify_at_risk_students2()
RETURNS TABLE (
  Student_ID VARCHAR(255),
  Problem TEXT
)
AS $$
BEGIN
  -- Update StudentStatus based on absence rate and score
  UPDATE public.Student_Status_At_Class
  SET StudentStatus = CASE 
                        WHEN (0.3 * MidTermScore + 0.7 * FinalTermScore) < 7  AND Absence::decimal / 
                             CASE 
                               WHEN ClassID LIKE 'IE35%' THEN 80
                               WHEN ClassID LIKE 'IE45%' THEN 60
                               WHEN ClassID LIKE 'IE55%' THEN 40
                               WHEN ClassID LIKE 'IE65%' THEN 20
                               ELSE NULL
                             END >= 0.3 THEN 'Active* - Low score and high absence'
                        WHEN (0.3 * MidTermScore + 0.7 * FinalTermScore) < 7 THEN 'Active* - Low score'
                        WHEN Absence::decimal / 
                             CASE 
                               WHEN ClassID LIKE 'IE35%' THEN 80
                               WHEN ClassID LIKE 'IE45%' THEN 60
                               WHEN ClassID LIKE 'IE55%' THEN 40
                               WHEN ClassID LIKE 'IE65%' THEN 20
                               ELSE NULL
                             END >= 0.3 THEN 'Active* - High absence'
                        ELSE StudentStatus 
                      END
  WHERE StudentStatus = 'Active' 
    AND ((0.3 * MidTermScore + 0.7 * FinalTermScore) < 7 
        OR Absence::decimal / 
           CASE 
              WHEN ClassID LIKE 'IE35%' THEN 80
              WHEN ClassID LIKE 'IE45%' THEN 60
              WHEN ClassID LIKE 'IE55%' THEN 40
              WHEN ClassID LIKE 'IE65%' THEN 20
              ELSE NULL 
           END >= 0.3);

  -- Return a table of students marked as "Active*" and their respective problems
  RETURN QUERY 
  SELECT StudentID,
         CASE 
           WHEN (0.3 * MidTermScore + 0.7 * FinalTermScore) < 7 AND Absence::decimal / 
                CASE 
                   WHEN ClassID LIKE 'IE35%' THEN 80
                   WHEN ClassID LIKE 'IE45%' THEN 60
                   WHEN ClassID LIKE 'IE55%' THEN 40
                   WHEN ClassID LIKE 'IE65%' THEN 20
                   ELSE NULL 
                END >= 0.3 THEN 'Low average score and high absence rate'
           WHEN (0.3 * MidTermScore + 0.7 * FinalTermScore) < 7 THEN 'Low average score'
           WHEN Absence::decimal / 
                CASE 
                   WHEN ClassID LIKE 'IE35%' THEN 80
                   WHEN ClassID LIKE 'IE45%' THEN 60
                   WHEN ClassID LIKE 'IE55%' THEN 40
                   WHEN ClassID LIKE 'IE65%' THEN 20
                   ELSE NULL 
                END >= 0.3 THEN 'High absence rate'
           ELSE NULL 
         END AS Problem
  FROM public.Student_Status_At_Class
  WHERE StudentStatus LIKE 'Active*%'; 
END;
$$ LANGUAGE plpgsql;

select * from public.identify_at_risk_students2();

-- Function 8: Đưa ra khuyến nghị lớp cho học viên dựa theo kết quả test đầu vào,
-- và thời gian học viên đăng ký khóa học:

CREATE OR REPLACE FUNCTION public.recommend_classes(student_id text, input_year int, quarter_number int) 
RETURNS TABLE (classid varchar(255))
LANGUAGE plpgsql
AS $$
DECLARE
    entrance_average_score REAL;
    recommended_course_id TEXT;
    quarter_start_month INT;
BEGIN
    SELECT (GeneralScore + SpeakingScore) / 2 
    INTO entrance_average_score
    FROM public.Entrance_Test
    WHERE StudentID = recommend_classes.student_id;

    recommended_course_id := CASE 
        WHEN entrance_average_score >= 0 AND 
        entrance_average_score < 3.5 THEN 'IE35'
        WHEN entrance_average_score >= 3.5 AND 
        entrance_average_score < 4.5 THEN 'IE45'
        WHEN entrance_average_score >= 4.5 AND 
        entrance_average_score < 5.5 THEN 'IE55'
        WHEN entrance_average_score >= 5.5  THEN 'IE65'
        ELSE NULL 
    END;

    quarter_start_month := (quarter_number - 1) * 3 + 1;

    RETURN QUERY
    SELECT cl.ClassID
    FROM public.Clazz cl
    WHERE cl.CourseID = recommended_course_id
      AND EXTRACT(MONTH FROM cl.OpenDate1) = quarter_start_month
      AND EXTRACT(YEAR FROM cl.OpenDate1) = input_year;
END;
$$;

select * from public.recommend_classes('ST0001', 2022, 3);

-- Function 9-10(Trigger):  Trigger để báo lỗi và ngăn chặn
--  thay đổi khi số điện thoại và số tài khoản ngân hàng sai format 

CREATE OR REPLACE FUNCTION public.validate_phone_number()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.PhoneNumber !~ '^0\d{9}$' THEN
    RAISE EXCEPTION 'So dien thoai phai bat dau bang so 0 va co 10 chu so';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.validate_bank_account()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.BankAccount !~ '^\d{9,12}$' THEN
    RAISE EXCEPTION 'So tai khoan ngan hang phai co tu 9 den 12 chu so';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tutor_phone_validation
BEFORE INSERT OR UPDATE ON public.Tutor
FOR EACH ROW
EXECUTE PROCEDURE public.validate_phone_number();

CREATE TRIGGER tutor_bank_account_validation
BEFORE INSERT OR UPDATE ON public.Tutor
FOR EACH ROW
EXECUTE PROCEDURE public.validate_bank_account();

CREATE TRIGGER student_phone_validation
BEFORE INSERT OR UPDATE ON public.Student
FOR EACH ROW
EXECUTE PROCEDURE public.validate_phone_number();

CREATE TRIGGER counselor_phone_validation
BEFORE INSERT OR UPDATE ON public.Counselor
FOR EACH ROW
EXECUTE PROCEDURE public.validate_phone_number();

CREATE TRIGGER counselor_bank_account_validation
BEFORE INSERT OR UPDATE ON public.Counselor
FOR EACH ROW
EXECUTE PROCEDURE public.validate_bank_account();


-- *************************************************
-- *************************************************
-- Hoàng Yến Nhi - 11 - 20
-- *************************************************
-- *************************************************
-- *************************************************

-- Function 11: Hàm tính doanh thu theo lớp ở trong trung tâm:
CREATE OR REPLACE FUNCTION public.calculate_class_revenue(class_id text) RETURNS money
    LANGUAGE plpgsql
    AS $$
DECLARE
    revenue MONEY := 0;
    starting_point TEXT;
    student_record RECORD;
BEGIN
    starting_point := CASE
        WHEN class_id LIKE 'IE35%' THEN 'IE35'
        WHEN class_id LIKE 'IE45%' THEN 'IE45'
        WHEN class_id LIKE 'IE55%' THEN 'IE55'
        WHEN class_id LIKE 'IE65%' THEN 'IE65'
        ELSE NULL 
    END;

    IF starting_point IS NULL THEN
        RETURN 0;
    END IF;

    FOR student_record IN (
        SELECT ssac.EndCoursePoint, c.fee 
        FROM public.Student_Status_At_Class ssac
        JOIN public.Clazz cl ON ssac.ClassID = cl.ClassID
        JOIN public.Course c ON cl.CourseID = c.CourseID
        WHERE ssac.ClassID = calculate_class_revenue.class_id
    ) LOOP
        IF student_record.EndCoursePoint >= 3.5 AND starting_point = 'IE35' THEN 
            revenue := revenue + student_record.fee;
        END IF;
        IF student_record.EndCoursePoint >= 4.5 AND starting_point IN ('IE35', 'IE45') THEN
            revenue := revenue + student_record.fee;
        END IF;
        IF student_record.EndCoursePoint >= 5.5 AND starting_point IN ('IE35', 'IE45', 'IE55') THEN
            revenue := revenue + student_record.fee;
        END IF;
        IF student_record.EndCoursePoint >= 6.5 AND starting_point IN ('IE35', 'IE45', 'IE55', 'IE65') THEN
            revenue := revenue + student_record.fee;
        END IF;
    END LOOP;

    RETURN revenue;
END;
$$;

select * from public.calculate_class_revenue('IE5500001')

-- Function 12: Hàm tính lương tháng giáo viên trong 1 tháng:
CREATE OR REPLACE FUNCTION public.calculate_tutor_salary2(tutor_id text, salary_month text) 
RETURNS TABLE (
    entrance_test_salary MONEY,
    class_salary MONEY
)
LANGUAGE plpgsql
AS $$
DECLARE
    entrance_test_salary MONEY := 0;
    class_salary MONEY := 0;
    class_record RECORD;
    month_diff INT;
    payment_months INT;
BEGIN
    SELECT COUNT(*) * 5::money
    INTO entrance_test_salary
    FROM public.Entrance_Test
    WHERE TutorID = calculate_tutor_salary2.tutor_id
    AND to_char(EntranceDate, 'YYYY-MM') = calculate_tutor_salary2.salary_month;

    FOR class_record IN (
        SELECT cl.ClassID, cl.OpenDate1, cl.OpenDate2, c.fee
        FROM public.Clazz cl
        JOIN public.Course c ON cl.CourseID = c.CourseID
        WHERE cl.TutorID = calculate_tutor_salary2.tutor_id
    ) LOOP
        CASE 
            WHEN class_record.ClassID LIKE 'IE35%' THEN
                payment_months := 9;
            WHEN class_record.ClassID LIKE 'IE45%' THEN
                payment_months := 7;
            WHEN class_record.ClassID LIKE 'IE55%' THEN
                payment_months := 5;
            WHEN class_record.ClassID LIKE 'IE65%' THEN
                payment_months := 3;
            ELSE
                payment_months := 0;  
        END CASE;

        IF payment_months > 0 THEN
            month_diff := (EXTRACT(YEAR FROM to_date(salary_month || '-01', 'YYYY-MM-DD')) - EXTRACT(YEAR FROM class_record.OpenDate1)) * 12 +
                          EXTRACT(MONTH FROM to_date(salary_month || '-01', 'YYYY-MM-DD')) - EXTRACT(MONTH FROM class_record.OpenDate1);
            
            IF month_diff >= 0 AND month_diff < payment_months THEN
                class_salary := class_salary +
                               (public.calculate_class_revenue(class_record.ClassID) * 0.3) / payment_months;
            END IF;
        END IF;
    END LOOP;

    RETURN QUERY SELECT entrance_test_salary, class_salary;
END;
$$;

select * from public.calculate_tutor_salary2('TU0001', '2023-01')

-- Function 13: Hàm tính lương theo tư vấn viên:
CREATE FUNCTION public.calculate_counselor_wage(counselor_id text) RETURNS money
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_tuition money := 0;
    starting_point text;
    student_record RECORD;
BEGIN
    FOR student_record IN (
        SELECT ssac.EndCoursePoint, c.fee, cl.CourseID
        FROM public.Student_Status_At_Class ssac
        JOIN public.Student s ON ssac.StudentID = s.StudentID
        JOIN public.Clazz cl ON ssac.ClassID = cl.ClassID
        JOIN public.Course c ON cl.CourseID = c.CourseID
        WHERE s.CounselorID = calculate_counselor_wage.counselor_id
    ) LOOP
        starting_point := CASE
            WHEN student_record.CourseID = 'IE35' THEN 'IE35'
            WHEN student_record.CourseID = 'IE45' THEN 'IE45'
            WHEN student_record.CourseID = 'IE55' THEN 'IE55'
            WHEN student_record.CourseID = 'IE65' THEN 'IE65'
            ELSE NULL 
        END;
        
        IF student_record.EndCoursePoint >= 3.5 AND starting_point = 'IE35' THEN 
            total_tuition := total_tuition + student_record.fee;
        END IF;
        IF student_record.EndCoursePoint >= 4.5 AND starting_point IN ('IE35', 'IE45') THEN
            total_tuition := total_tuition + student_record.fee;
        END IF;
        IF student_record.EndCoursePoint >= 5.5 AND starting_point IN ('IE35', 'IE45', 'IE55') THEN
            total_tuition := total_tuition + student_record.fee;
        END IF;
        IF student_record.EndCoursePoint >= 6.5 AND starting_point IN ('IE35', 'IE45', 'IE55', 'IE65') THEN
            total_tuition := total_tuition + student_record.fee;
        END IF;
    END LOOP;

    RETURN total_tuition * 0.1;
END;
$$;

select * from public.calculate_counselor_wage('CS0040')

-- Function 14: Hàm tính tỉ lệ đi học của học viên trong toàn bộ khóa học:
CREATE OR REPLACE FUNCTION public.calculate_student_absence_rate(student_id text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    absence_count integer;
    total_lessons integer;
    class_id text;
    absence_rate real;
BEGIN
    SELECT ssac.Absence, ssac.ClassID
    INTO absence_count, class_id
    FROM public.Student_Status_At_Class ssac
    WHERE ssac.StudentID = calculate_student_absence_rate.student_id;

    total_lessons := CASE
        WHEN class_id LIKE 'IE35%' THEN 80
        WHEN class_id LIKE 'IE45%' THEN 60
        WHEN class_id LIKE 'IE55%' THEN 40
        WHEN class_id LIKE 'IE65%' THEN 20
        ELSE NULL
    END;

    IF total_lessons > 0 THEN
        absence_rate := absence_count::real / total_lessons;
    ELSE 
        absence_rate := 0;
    END IF;

    RETURN (absence_rate * 100)::text || '%';  
END;
$$;

SELECT public.calculate_student_absence_rate('ST0002'); 

-- Function 15: Hàm tính rating star trung bình của một lớp.
CREATE OR REPLACE FUNCTION public.calculate_average_rating(class_id VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    average_rating NUMERIC;
BEGIN
    -- Tính rating star trung bình của một lớp
    SELECT AVG(ratingstar) INTO average_rating
    FROM public.student_status_at_class
    WHERE classid = class_id;

    RETURN COALESCE(average_rating, 0);
END;
$$ LANGUAGE plpgsql;

select public.calculate_average_rating('IE3500001');

-- Function 16: Hàm hiển thị danh sách các bài test đầu vào mà giáo viên chấm trong ngày.
CREATE OR REPLACE FUNCTION public.list_entrance_tests(tutor_id VARCHAR, year INT, month INT, day INT)
RETURNS TABLE(test_id VARCHAR, general_score REAL, speaking_score REAL, entrance_time DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT testid, generalscore, speakingscore, entrancedate
    FROM public.entrance_test
    WHERE tutorid = tutor_id
      AND EXTRACT(YEAR FROM entrancedate) = year
      AND EXTRACT(MONTH FROM entrancedate) = month
      AND EXTRACT(DAY FROM entrancedate) = day;
END;
$$ LANGUAGE plpgsql;

select * from public.list_entrance_tests('TU0001', 2022, 6, 24);

-- Function 17: Hàm tính doanh thu theo quý của toàn bộ trung tâm
CREATE OR REPLACE FUNCTION public.calculate_quarterly_revenue(input_year INT, quarter_number INT) RETURNS money
    LANGUAGE plpgsql
    AS $$
DECLARE
    quarterly_revenue MONEY := 0;
    quarter_start_month INT;
    class_record RECORD;
BEGIN
    quarter_start_month := (quarter_number - 1) * 3 + 1;

    FOR class_record IN (
        SELECT ClassID
        FROM public.Clazz
        WHERE EXTRACT(MONTH FROM OpenDate1) = quarter_start_month
          AND EXTRACT(YEAR FROM OpenDate1) = input_year
    ) LOOP
        quarterly_revenue := quarterly_revenue + public.calculate_class_revenue(class_record.ClassID);
    END LOOP;

    RETURN quarterly_revenue;
END;
$$;

select public.calculate_quarterly_revenue(2022, 1);

-- Function 19: Danh sách học viên còn nợ học phí
select s.studentid, s.phonenumber, s.studentaddress
from public.student s join public.student_status_at_class ssc
using(studentid)
where ssc.unpaidfees::numeric >0;

-- Function 20: Truy vấn tính rating star trung bình của tất cả các lớp.
select avg(ratingstar) as average_rating_star
from public.student_status_at_class;

-- *************************************************
-- *************************************************
-- Nguyễn Hoàng Phúc - 21 - 30
-- *************************************************
-- *************************************************
-- *************************************************


-- Function 21: Hàm hiển thị bài test đầu vào khi biết mã học sinh
CREATE OR REPLACE FUNCTION public.get_student_entrance_test_result(student_id VARCHAR(255))
RETURNS TABLE (
  "Test_ID" VARCHAR(255),
  "General Score" REAL,
  "Speaking Score" REAL,
  "Entrance Date" DATE,
  "Entrance Time" TIME
) AS $$
BEGIN
  RETURN QUERY
  SELECT Entrance_Test.TestID, Entrance_Test.GeneralScore, Entrance_Test.SpeakingScore, Entrance_Test.EntranceDate, Entrance_Test.EntranceTime
  FROM public.Entrance_Test
  WHERE Entrance_Test.StudentID = student_id;
END; $$
LANGUAGE 'plpgsql';

select * from public.get_student_entrance_test_result('ST0001');

-- Function 22:  Liệt kê các học sinh có điểm test đầu vào > 6.5
-- (không có lớp học phù hợp tại trung tâm):
SELECT StudentID, (GeneralScore + SpeakingScore) / 2 AS AverageScore
FROM public.Entrance_Test
WHERE (GeneralScore + SpeakingScore) > 13;


-- Function 23:  Hàm hiển thị điểm giữa kỳ, cuối kỳ, số buổi nghỉ và học phí nợ của học viên:
CREATE OR REPLACE FUNCTION public.get_student_grades(student_id VARCHAR(255))
RETURNS TABLE (
  midterm_score REAL,
  finalterm_score REAL,
  absence INT,
  unpaid_fees MONEY
)
AS $$
BEGIN
  RETURN QUERY
  SELECT
    ssc.MidTermScore,
    ssc.FinalTermScore,
    ssc.Absence,
    ssc.UnpaidFees
  FROM public.Student_Status_At_Class ssc
  WHERE ssc.StudentID = get_student_grades.student_id;
END;
$$ LANGUAGE plpgsql;

select * from public.get_student_grades('ST0001');

-- Function 24: Hàm đưa ra danh sách các lớp học phù hợp cho học viên 
-- dựa theo thời gian học và kết quả test đầu vào:

CREATE OR REPLACE FUNCTION public.recommend_classes(student_id text, input_year int, quarter_number int) 
RETURNS TABLE (classid varchar(255))
LANGUAGE plpgsql
AS $$
DECLARE
    entrance_average_score REAL;
    recommended_course_id TEXT;
    quarter_start_month INT;
BEGIN
    SELECT (GeneralScore + SpeakingScore) / 2 
    INTO entrance_average_score
    FROM public.Entrance_Test
    WHERE StudentID = recommend_classes.student_id;

    recommended_course_id := CASE 
        WHEN entrance_average_score >= 0 AND 
        entrance_average_score < 3.5 THEN 'IE35'
        WHEN entrance_average_score >= 3.5 AND 
        entrance_average_score < 4.5 THEN 'IE45'
        WHEN entrance_average_score >= 4.5 AND 
        entrance_average_score < 5.5 THEN 'IE55'
        WHEN entrance_average_score >= 5.5  THEN 'IE65'
        ELSE NULL 
    END;

    quarter_start_month := (quarter_number - 1) * 3 + 1;

    RETURN QUERY
    SELECT cl.ClassID
    FROM public.Clazz cl
    WHERE cl.CourseID = recommended_course_id
      AND EXTRACT(MONTH FROM cl.OpenDate1) = quarter_start_month
      AND EXTRACT(YEAR FROM cl.OpenDate1) = input_year;
END;
$$;

select * from public.recommend_classes('ST0001', 2022, 3);

-- Function 25:  Hàm lập danh sách học sinh giỏi trong 1 lớp học:
CREATE OR REPLACE FUNCTION public.get_class_details(class_id text, mode text)
RETURNS TABLE (
    student_id character varying(255),
    student_name character varying(255),
    phone_number character varying(255),
    student_address character varying(255),
    midterm_score real,
    finalterm_score real,
    ielts_score real
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF mode = 'Class' THEN
        RETURN QUERY 
        SELECT 
            st.StudentID,
            st.StudentName,
            st.PhoneNumber,
            st.StudentAddress,
            ssac.MidTermScore,
            ssac.FinalTermScore,
            ieltsscore AS ieltsscore 
        FROM public.Student st
        JOIN public.Student_Status_At_Class ssac ON st.StudentID = ssac.StudentID
        WHERE ssac.ClassID = class_id
          AND (ssac.MidTermScore * 0.3 + ssac.FinalTermScore * 0.7) >= 8;

    ELSIF mode = 'IELTS' THEN
        RETURN QUERY
        SELECT 
            st.StudentID,
            st.StudentName,
            st.PhoneNumber,
            st.StudentAddress,
            midtermscore AS midtermscore,
            finaltermscore AS finaltermscore,
            ssac.IELTSScore 
        FROM public.Student st
        JOIN public.Student_Status_At_Class ssac ON st.StudentID = ssac.StudentID
        WHERE ssac.ClassID = class_id
          AND ssac.IELTSScore >= ssac.EndCoursePoint;

    ELSE
        RAISE EXCEPTION 'Invalid mode. Please use "Class" or "IELTS".';
    END IF;
END;
$$;

select * from public.get_class_details('IE3500001', 'Class');


-- Function 26:  Liệt kê các lớp học vẫn đang học tới thời điểm hiện tại

CREATE OR REPLACE FUNCTION public.find_active_classes()
RETURNS TABLE (
    class_id character varying(255),
    class_name character varying(255),
    course_id character varying(255),
    tutor_id character varying(255),
    open_date1 date,
    open_time1 time without time zone
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.ClassID,
        c.ClassName,
        c.CourseID,
        c.TutorID,
        c.OpenDate1,
        c.OpenTime1
    FROM public.Clazz c
    WHERE EXISTS (
        SELECT 1
        FROM public.Student_Status_At_Class ssac
        WHERE ssac.ClassID = c.ClassID
          AND (ssac.StudentStatus = 'Active' OR ssac.StudentStatus = 'Active*')
    );
END;
$$;

select * from public.find_active_classes();

-- Function 27: Hiển thị số lượng của từng band điểm mà học sinh đạt được
SELECT COUNT(*), (GeneralScore + SpeakingScore) / 2 AS ScoreGroup
FROM public.Entrance_Test
GROUP BY ScoreGroup
ORDER BY ScoreGroup;

-- Function 28: Hàm hiển thị tỉ lệ phần trăm học viên đi học các cấp độ:
WITH StudentCounts AS (
    SELECT 
        EndCoursePoint,
        COUNT(*) AS total_students
    FROM 
        public.Student_Status_At_Class
    GROUP BY 
        EndCoursePoint
),
TotalStudents AS (
    SELECT COUNT(*) AS all_students FROM public.Student_Status_At_Class
)
SELECT 
    sc.EndCoursePoint,
    (sc.total_students::decimal / ts.all_students) * 100 AS percentage
FROM 
    StudentCounts sc
JOIN
    TotalStudents ts ON 1=1;


-- Function 29: Tính số học viên cho từng tư vấn viên
CREATE OR REPLACE FUNCTION count_students_advised(counselor_id VARCHAR(255))
RETURNS INTEGER AS $$
DECLARE
    student_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO student_count
    FROM student
    WHERE counselorid = counselor_id;

    RETURN student_count;
END;
$$ LANGUAGE plpgsql;

-- Function 30: Liệt kê các lớp tutor còn đang dạy
CREATE OR REPLACE FUNCTION public.get_active_classes_for_tutor(tutor_id VARCHAR(255))
RETURNS TABLE (class_id VARCHAR(255)) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT c.ClassID
  FROM Clazz AS c
  JOIN Student_Status_At_Class AS ssac ON c.ClassID = ssac.ClassID
  WHERE c.TutorID = tutor_id
  AND ssac.StudentStatus like 'Active%'; 
END;
$$ LANGUAGE plpgsql;












