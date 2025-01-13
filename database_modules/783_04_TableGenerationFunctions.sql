CREATE OR REPLACE FUNCTION GenerateStudentStatusAtClass()
RETURNS VOID AS $$
DECLARE
  XXXX INT;
  m INT;
  Y INT;
  CCCCC VARCHAR(5);
  JoinDate DATE;
  MidTermScore REAL;
  FinalTermScore REAL;
  Absence INT;
  UnpaidFees MONEY;
  StudentStatus VARCHAR(255);
  IELTSScore REAL;
  EndCoursePoint REAL;
  RatingStar INT;
  ClassID VARCHAR(255);
  StudentStatusID VARCHAR(255);
BEGIN
  FOR XXXX IN 1..7350 LOOP
    m := XXXX % 105;
    Y := XXXX / 105;
    IF m = 0 OR m > 100 THEN 
      CONTINUE; 
    END IF;
    IF m IN (1, 21) THEN
      EndCoursePoint := 3.5;
    ELSIF m IN (2, 15, 28) THEN
      EndCoursePoint := 4.5;
    ELSIF m IN (8, 16, 24, 32, 40) THEN
      EndCoursePoint := 5.5;
    ELSE
      EndCoursePoint := 6.5;
    END IF;

    IF XXXX BETWEEN 1 AND 1050 THEN
      JoinDate := '2022-07-04';
      IF m <= 20 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y)::VARCHAR, 5, '0');
      ELSEIF m > 20 AND m <= 40 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y + 1)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 41 AND 60 THEN
        ClassID := 'IE45' || LPAD((0001 + Y)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 61 AND 80 THEN
        ClassID := 'IE55' || LPAD((0001 + Y)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 81 AND 100 THEN
        ClassID := 'IE65' || LPAD((0001 + Y)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 101 AND 104 THEN
        CONTINUE;
      ELSEIF XXXX % 105 = 0 THEN
        CONTINUE;
      END IF;
    ELSIF XXXX BETWEEN 1051 AND 2100 THEN
      JoinDate := '2022-10-03';
      IF m <= 20 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y)::VARCHAR, 5, '0');
      ELSEIF m > 20 AND m <= 40 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y + 1)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 41 AND 60 THEN
        ClassID := 'IE45' || LPAD((0001 + Y)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 61 AND 80 THEN
        ClassID := 'IE55' || LPAD((0001 + Y)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 81 AND 100 THEN
        ClassID := 'IE65' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 101 AND 104 THEN
        CONTINUE;
      ELSEIF XXXX % 105 = 0 THEN
        CONTINUE;
      END IF;
    ELSIF XXXX BETWEEN 2101 AND 3150 THEN
      JoinDate := '2023-01-02';
      IF m <= 20 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y)::VARCHAR, 5, '0');
      ELSEIF m > 20 AND m <= 40 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y + 1)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 41 AND 60 THEN
        ClassID := 'IE45' || LPAD((0001 + Y)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 61 AND 80 THEN
        ClassID := 'IE55' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 81 AND 100 THEN
        ClassID := 'IE65' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 101 AND 104 THEN
        CONTINUE;
      ELSEIF XXXX % 105 = 0 THEN
        CONTINUE;
      END IF;
    ELSIF XXXX BETWEEN 3151 AND 4200 THEN
      JoinDate := '2023-04-03';
      IF m <= 20 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y)::VARCHAR, 5, '0');
      ELSEIF m > 20 AND m <= 40 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y + 1)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 41 AND 60 THEN
        ClassID := 'IE45' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 61 AND 80 THEN
        ClassID := 'IE55' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 81 AND 100 THEN
        ClassID := 'IE65' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 101 AND 104 OR XXXX % 105 = 0 THEN CONTINUE;
      END IF;
    ELSIF XXXX BETWEEN 4201 AND 5250 THEN
      JoinDate := '2023-07-04';
      IF m <= 20 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y)::VARCHAR, 5, '0');
      ELSEIF m > 20 AND m <= 40 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y + 1)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 41 AND 60 THEN
        ClassID := 'IE45' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 61 AND 80 THEN
        ClassID := 'IE55' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 81 AND 100 THEN
        ClassID := 'IE65' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 101 AND 104 OR XXXX % 105 = 0 THEN CONTINUE;
      END IF;
    ELSIF XXXX BETWEEN 5251 AND 6300 THEN
      JoinDate := '2023-10-03';
      IF m <= 20 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y)::VARCHAR, 5, '0');
      ELSEIF m > 20 AND m <= 40 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y + 1)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 41 AND 60 THEN
        ClassID := 'IE45' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 61 AND 80 THEN
        ClassID := 'IE55' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 81 AND 100 THEN
        ClassID := 'IE65' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 101 AND 104 OR XXXX % 105 = 0 THEN CONTINUE;
      END IF;
    ELSE
      JoinDate := '2024-01-02';
      IF m <= 20 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y)::VARCHAR, 5, '0');
      ELSEIF m > 20 AND m <= 40 THEN
        ClassID := 'IE35' || LPAD((0001 + 2*Y + 1)::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 41 AND 60 THEN
        ClassID := 'IE45' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 61 AND 80 THEN
        ClassID := 'IE55' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 81 AND 100 THEN
        ClassID := 'IE65' || LPAD(((0001 + Y))::VARCHAR, 5, '0');
      ELSEIF m BETWEEN 101 AND 104 OR XXXX % 105 = 0 THEN CONTINUE;
      END IF;
    END IF;

    MidTermScore := CASE WHEN RANDOM() < 0.2 THEN ROUND(CAST((4 + RANDOM() * 3) AS numeric) * 2) / 2
                     ELSE ROUND(CAST((7 + RANDOM() * 3) AS numeric) * 2) / 2 END;
    FinalTermScore := CASE WHEN RANDOM() < 0.2 THEN ROUND(CAST((4 + RANDOM() * 3) AS numeric) * 2) / 2
                       ELSE ROUND(CAST((7 + RANDOM() * 3) AS numeric) * 2) / 2 END;
    Absence := FLOOR(RANDOM() * 5)::INT;
    IELTSScore := ROUND(CAST((EndCoursePoint + RANDOM() * 1) AS numeric)*2)/2 END;
    RatingStar := FLOOR(1 + RANDOM() * 3)::INT;
    StudentStatusID := 'SS' || LPAD(XXXX::VARCHAR, 4, '0');

    IF (JoinDate IN ('2023-07-04', '2023-10-03', '2024-01-02') AND ClassID LIKE 'IE35%' AND EndCoursePoint = 6.5) OR
       (JoinDate = '2023-10-03' AND ClassID LIKE 'IE45%' AND EndCoursePoint = 6.5) OR
       (JoinDate = '2024-01-02' AND ClassID LIKE 'IE55%' AND EndCoursePoint = 6.5) THEN
      StudentStatus := 'Active';
      UnpaidFees := CASE WHEN RANDOM() < 0.5 THEN 0 ELSE 1000 END;
    ELSE
      StudentStatus := 'Inactive';
      UnpaidFees := 0;
    END IF;

    INSERT INTO Student_Status_At_Class (StudentStatusID, MidTermScore, FinalTermScore, Absence, UnpaidFees, StudentStatus, JoinDate, IELTSScore, EndCoursePoint, RatingStar, ClassID, StudentID)
    VALUES (StudentStatusID, MidTermScore, FinalTermScore, Absence, UnpaidFees, StudentStatus, JoinDate, IELTSScore, EndCoursePoint, RatingStar, ClassID, 'ST' || LPAD(XXXX::VARCHAR, 4, '0'));
  END LOOP;
END;
$$ LANGUAGE plpgsql;


-- Using the public schema
CREATE OR REPLACE FUNCTION public.generate_entrance_test(num_tests integer)
RETURNS void AS $$
DECLARE
  i integer;
  test_id text;
  general_score real;
  speaking_score real;
  entrance_date date;
  entrance_time time without time zone;
  meeting_link text;
  tutor_id text;
  student_id text;
BEGIN
  FOR i IN 1..num_tests LOOP
    -- Generate TestID based on StudentID
    test_id := 'TE' || LPAD(i::text, 4, '0');

    -- Generate random IELTS scores
    general_score := random() * 4.5 + 1;
    speaking_score := random() * 4.5 + 1;

    -- Generate random entrance date
    entrance_date := (
      CASE
        WHEN random() < 0.2 THEN '2020-01-01'::date
        WHEN random() < 0.4 THEN '2021-01-01'::date
        WHEN random() < 0.6 THEN '2022-01-01'::date
        WHEN random() < 0.8 THEN '2023-01-01'::date
        ELSE '2024-01-01'::date
      END
    ) + (random() * 365)::INT;

    -- Generate random entrance time
    entrance_time := '08:00'::time + (random() * 12)::INT * INTERVAL '1 hour';

    -- Generate a random Google Meet link 
    meeting_link := 'meet.google.com/' || (
      CASE
        WHEN random() < 0.5 THEN 'abc'
        ELSE 'def'
      END
    ) || (random() * 1000000)::INT::VARCHAR || '-' || (random() * 1000000)::INT::VARCHAR;
    
    -- Check if the meeting link is already in the database
    WHILE EXISTS (SELECT 1 FROM public.Entrance_Test WHERE MeetingLink = meeting_link) LOOP
      meeting_link := 'meet.google.com/' || (
        CASE
          WHEN random() < 0.5 THEN 'abc'
          ELSE 'def'
        END
      ) || (random() * 1000000)::INT::VARCHAR || '-' || (random() * 1000000)::INT::VARCHAR;
    END LOOP;

    -- Generate StudentID corresponding to TestID
    student_id := 'ST' || LPAD(i::text, 4, '0');

    -- Generate TutorID based on the number of tutors 
    tutor_id := (SELECT TutorID FROM public.Tutor ORDER BY RANDOM() LIMIT 1);

    -- Insert the new entrance test record
    INSERT INTO public.Entrance_Test (TestID, GeneralScore, SpeakingScore, EntranceDate, EntranceTime, MeetingLink, TutorID, StudentID) VALUES (
      test_id,
      general_score,
      speaking_score,
      entrance_date,
      entrance_time,
      meeting_link,
      tutor_id,
      student_id
    );
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Call the function to generate 100 entrance tests
SELECT public.generate_entrance_test(100);

Modify the test function above, but keep the TestID, StudentID, TutorID,
MeetingLink the same.
First, the function takes 2 parameters: start and end, both integers. 
It will start generating from TE(start) to TE(end).
Second, the entrance date is randomly generated from a 
range that can be modified, for example from '2022-06-06' to '2022-03-07'.
EntranceTime is randomly generated from '08:00' to '20:00'.


---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************
---- **********************************

CREATE OR REPLACE FUNCTION public.generate_entrance_test(
    start_test integer,
    end_test integer,
    start_date date,
    end_date date,
    start_time time without time zone,
    end_time time without time zone,
    start_general_score real,
    end_general_score real,
    start_speaking_score real,
    end_speaking_score real
)
RETURNS void AS $$
DECLARE
  i integer;
  test_id text;
  general_score real;
  speaking_score real;
  entrance_date date;
  entrance_time time without time zone;
  meeting_link text;
  tutor_id text;
  student_id text;
BEGIN
  FOR i IN start_test..end_test LOOP
    -- Generate TestID based on StudentID
    test_id := 'TE' || LPAD(i::text, 4, '0');

    -- Generate random IELTS scores (handling 0.5 increments)
    general_score := start_general_score + (random() * (end_general_score - start_general_score) * 2)::INT * 0.5;
    speaking_score := start_speaking_score + (random() * (end_speaking_score - start_speaking_score) * 2)::INT * 0.5;

    -- Generate random entrance date
    entrance_date := start_date + (random() * (end_date - start_date)::INT)::INT;

    -- Generate random entrance time
    entrance_time := start_time + (random() * (end_time - start_time)::INTERVAL)::TIME;

    -- Generate a random Google Meet link 
    meeting_link := 'meet.google.com/' || (
      CASE
        WHEN random() < 0.5 THEN 'abc'
        ELSE 'def'
      END
    ) || (random() * 1000000)::INT::VARCHAR || '-' || (random() * 1000000)::INT::VARCHAR;
    
    -- Check if the meeting link is already in the database
    WHILE EXISTS (SELECT 1 FROM public.Entrance_Test WHERE MeetingLink = meeting_link) LOOP
      meeting_link := 'meet.google.com/' || (
        CASE
          WHEN random() < 0.5 THEN 'abc'
          ELSE 'def'
        END
      ) || (random() * 1000000)::INT::VARCHAR || '-' || (random() * 1000000)::INT::VARCHAR;
    END LOOP;

    -- Generate StudentID corresponding to TestID
    student_id := 'ST' || LPAD(i::text, 4, '0');

    -- Generate TutorID based on the number of tutors 
    tutor_id := (SELECT TutorID FROM public.Tutor ORDER BY RANDOM() LIMIT 1);

    -- Insert the new entrance test record
    INSERT INTO public.Entrance_Test (TestID, GeneralScore, SpeakingScore, EntranceDate, EntranceTime, MeetingLink, TutorID, StudentID) VALUES (
      test_id,
      general_score,
      speaking_score,
      entrance_date,
      entrance_time,
      meeting_link,
      tutor_id,
      student_id
    );
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Example usage:
-- Generate tests from TE0001 to TE0100 with scores between 4.0 and 7.0
SELECT public.generate_entrance_test(1, 100, '2022-06-06', '2022-03-07', '08:00', '20:00', 1.0, 3.5, 1.0, 3.5);



CREATE OR REPLACE FUNCTION public.generate_counselors(num_counselors integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  i integer := 1;
  first_name text;
  last_name text;
  counselor_id text;
  full_name text;
  phone_prefix text;
  bank_prefix text;
  first_name_array text[] := ARRAY[
    'Alain', 'Alex', 'Alexandre', 'Alfred', 'Alice', 'Amandine', 'André', 'Angélique', 'Antoine', 'Arthur',
    'Audrey', 'Baptiste', 'Benjamin', 'Bertrand', 'Camille', 'Carole', 'Caroline', 'Catherine', 'Charles', 'Charlotte',
    'Chloé', 'Christian', 'Claire', 'Clément', 'David', 'Denis', 'Diane', 'Didier', 'Édouard', 'Élise',
    'Émilie', 'Emma', 'Éric', 'Estelle', 'Ethan', 'Fabien', 'Fanny', 'Florence', 'François', 'Gabriel',
    'Gaël', 'Geoffrey', 'Grégory', 'Guillaume', 'Héléne', 'Henri', 'Hugo', 'Inès', 'Isabelle', 'Jacques',
    'Jade', 'Jean', 'Jean-Baptiste', 'Jean-Pierre', 'Jérémie', 'Jérôme', 'Jessica', 'Julie', 'Jules', 'Justine',
    'Laura', 'Laurent', 'Léa', 'Léon', 'Léonie', 'Léo', 'Lionel', 'Louis', 'Lucas', 'Lucien',
    'Lucille', 'Ludovic', 'Maël', 'Magali', 'Mahaut', 'Marc', 'Margot', 'Marie', 'Marion', 'Martin',
    'Mathilde', 'Mathieu', 'Maxime', 'Mélanie', 'Michel', 'Morgan', 'Nathan', 'Nathanaël', 'Nicolas', 'Noémie',
    'Olivia', 'Paul', 'Pauline', 'Pierre', 'Quentin', 'Raphaël', 'Rémi', 'Romane', 'Romain', 'Samuel',
    'Sarah', 'Sébastien', 'Simon', 'Sophie', 'Sylvain', 'Téo', 'Théodore', 'Thomas', 'Timéo', 'Tom',
    'Valentin', 'Valérie', 'Victor', 'Victoria', 'Vincent', 'Virginie', 'William', 'Yann', 'Yannis', 'Yohann',
    'Zoe', 'Adrien', 'Agathe', 'Alexandre', 'Alexis', 'Anaïs', 'André', 'Anthony', 'Arnaud', 'Aude',
    'Augustin', 'Barbara', 'Benoît', 'Bernard', 'Cécile', 'Cédric', 'Céline', 'Célestin', 'Clémentine', 'Corentin',
    'Dorian', 'Elsa', 'Emeline', 'Emilien', 'Enora', 'Éric', 'Éric', 'Estelle', 'Étienne', 'Fabrice',
    'Félix', 'Florian', 'Gaëtan', 'Gaspard', 'Gauthier', 'Guillaume', 'Héloïse', 'Hugo', 'Jérémy', 'Joachim',
    'Jonathan', 'Joseph', 'Julien', 'Léa', 'Lilian', 'Lily', 'Lisa', 'Louise', 'Lucas', 'Maëlys',
    'Manon', 'Marc', 'Margot', 'Marie', 'Marine', 'Marlon', 'Martin', 'Mathéo', 'Mathis', 'Maxence',
    'Maxime', 'Mélanie', 'Morgane', 'Nathan', 'Noa', 'Nolan', 'Noémie', 'Océane', 'Paul', 'Pierre',
    'Quentin', 'Raphaël', 'Rémi', 'Romain', 'Sacha', 'Sarah', 'Simon', 'Solène', 'Théo', 'Thibault',
    'Thomas', 'Timothée', 'Valentin', 'Victor', 'Vincent', 'Virginie', 'William', 'Yann', 'Yannis', 'Yvan'
  ];
  last_name_array text[] := ARRAY[
    'Becker', 'Bauer', 'Berger', 'Brandt', 'Braun', 'Breuer', 'Busch', 'Fischer', 'Frank', 'Freidrich',
    'Gärtner', 'Geiger', 'Glaser', 'Goldmann', 'Groß', 'Haas', 'Hartmann', 'Haußmann', 'Heidelbach', 'Hein',
    'Heller', 'Hoffmann', 'Huber', 'Jäger', 'Jakob', 'Jansen', 'Jung', 'Kaiser', 'Keller', 'Klein',
    'Koch', 'Köhler', 'Krause', 'Kuhn', 'Lang', 'Lehmann', 'Lenz', 'Löffler', 'Lorenz', 'Ludwig',
    'Maier', 'Martin', 'Mayer', 'Meier', 'Müller', 'Neumann', 'Nickel', 'Nöth', 'Paul', 'Pfeiffer',
    'Ritter', 'Schmidt', 'Schneider', 'Schröder', 'Schubert', 'Schulz', 'Schuster', 'Schwarz', 'Seidel', 'Simon',
    'Sommer', 'Steiner', 'Stein', 'Stiegler', 'Stoll', 'Storch', 'Straub', 'Strobel', 'Thomas', 'Walter',
    'Weber', 'Weis', 'Weiß', 'Werner', 'Wolf', 'Zimmermann', 'Adam', 'Albert', 'Albrecht', 'Alexander',
    'Andreas', 'Anton', 'Arnold', 'Bach', 'Bauer', 'Beck',
    'Berger', 'Bertram', 'Bischoff', 'Böhm', 'Brand', 'Breuer', 'Brunner', 'Busch', 'Buttmann',
    'Christ', 'Christian', 'Daniel', 'David', 'Degenhardt', 'Dietrich', 'Dittmann', 'Eberhardt', 'Eckhardt', 'Edelmann',
    'Engelhardt', 'Ernst', 'Fiedler', 'Fischer', 'Fleischer', 'Förster', 'Franz', 'Friedrich', 'Gärtner', 'Geiger',
    'Gieseler', 'Glaser', 'Göbel', 'Goldmann', 'Großmann', 'Günther', 'Haas', 'Hagen', 'Hahn', 'Haller',
    'Hartmann', 'Haußmann', 'Heidelbach', 'Heinemann', 'Hein', 'Heller', 'Hermann', 'Hesse', 'Hoffmann', 'Holzer',
    'Huber', 'Huck', 'Jäger', 'Jakob', 'Jansen', 'Jentzsch', 'Jung', 'Kaiser', 'Kandler', 'Keller',
    'Kienle', 'Klein', 'Koch', 'Köhler', 'Krause', 'Kremer', 'Kuhn', 'Kunz', 'Lang', 'Lehmann',
    'Lehner', 'Lenz', 'Lieb', 'Löffler', 'Lorenz', 'Ludwig', 'Lutz', 'Maier', 'Mann', 'Marx',
    'Mayer', 'Meier', 'Michel', 'Mielke', 'Möller', 'Müller', 'Neumann', 'Nickel', 'Nöth', 'Ochs',
    'Paul', 'Peters', 'Pfeiffer', 'Pfleiderer', 'Pohl', 'Rauch', 'Reichelt', 'Reiß', 'Reuter', 'Ritter',
    'Rösler', 'Roth', 'Rupp', 'Sauer', 'Schachner', 'Scheibe', 'Schießer', 'Schiller', 'Schindler', 'Schirmer',
    'Schmidt', 'Schneider', 'Schröder', 'Schubert', 'Schuhmann', 'Schulz', 'Schuster', 'Schwarz', 'Seidel', 'Seifert',
    'Selzer', 'Siebert', 'Simon', 'Sommer', 'Sorg', 'Spieß', 'Stein', 'Steiner', 'Steinhauer', 'Stiegler',
    'Stoll', 'Storch', 'Straub', 'Strobel', 'Sturm', 'Thoma', 'Thomas', 'Walter', 'Weber', 'Weis',
    'Weiß', 'Werner', 'Wiese', 'Wilhelm', 'Wolf', 'Zimmermann'
  ];
BEGIN
  WHILE i <= num_counselors LOOP 
    -- Generate random French first names
    first_name := first_name_array[floor(random() * array_upper(first_name_array, 1)) + 1];
    -- Generate random German last names
    last_name := last_name_array[floor(random() * array_upper(last_name_array, 1)) + 1];
    full_name := first_name || ' ' || last_name;
    -- Generate sequential CounselorID
    counselor_id := 'CS' || LPAD(i::text, 4, '0');

    -- Generate random phone number with specific prefixes
    phone_prefix := (
      CASE
        WHEN random() < 0.2 THEN '021'
        WHEN random() < 0.4 THEN '022'
        WHEN random() < 0.6 THEN '023'
        WHEN random() < 0.8 THEN '024'
        ELSE '025'
      END
    );
    -- Generate random bank account with specific prefixes
    bank_prefix := (
      CASE
        WHEN random() < 0.16666666666666666 THEN '0021'
        WHEN random() < 0.3333333333333333 THEN '0022'
        WHEN random() < 0.5 THEN '0023'
        WHEN random() < 0.6666666666666666 THEN '0024'
        WHEN random() < 0.8333333333333333 THEN '0025'
        ELSE '0025'
      END
    );

    -- Insert the new counselor record directly (no need to check for duplicates)
    IF NOT EXISTS (SELECT 1 FROM public.Counselor WHERE CounselorName = full_name) THEN
      INSERT INTO public.Counselor (CounselorID, CounselorName, PhoneNumber, BankAccount) VALUES (
        counselor_id,
        full_name,
        phone_prefix || (random() * 10000000)::INT::VARCHAR,
        bank_prefix || (random() * 100000000000)::BIGINT::VARCHAR
      );
      i := i + 1;
    END IF;
  END LOOP;
END;
$$;

