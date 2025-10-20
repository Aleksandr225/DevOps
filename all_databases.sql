--
-- PostgreSQL database cluster dump
--

\restrict uWc2Oe0gI4kehcp5nJDRYWigGtbZyZQ7bKHMOzC4qofi3OE2veZCu1QAEC0zzzZ

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:25xLj1NZC8eUlATou1LiUQ==$UWVg3LfMivUuIqqhxW+ol/QpPxFoybjHXzLlozfGzE4=:rkxLRC5F4IG+ELuN/TQ17YQu96evkwE0Lk3xSdK0R4Y=';

--
-- User Configurations
--








\unrestrict uWc2Oe0gI4kehcp5nJDRYWigGtbZyZQ7bKHMOzC4qofi3OE2veZCu1QAEC0zzzZ

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict Ej8jCMQd1nmpnYEhBbamV8OmLN5FldJoTqVsOGYNfqYnxKcpmeWcPG9wGhbYKw9

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict Ej8jCMQd1nmpnYEhBbamV8OmLN5FldJoTqVsOGYNfqYnxKcpmeWcPG9wGhbYKw9

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict tGi2NvB3bCpPcOm0KSnSA7WeYR2hgkeIDAuD3xeYHCkAfhoaJBPWgOnYUxFS8xz

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: edu_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edu_plan (
    spec_id integer NOT NULL,
    spec_name character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    semester "char" NOT NULL,
    plan_hours integer NOT NULL,
    exam character varying(255),
    CONSTRAINT edu_plan_semester_check CHECK (((semester)::text = ANY (ARRAY['1'::text, '2'::text])))
);


ALTER TABLE public.edu_plan OWNER TO postgres;

--
-- Name: edu_plan_spec_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_plan_spec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_plan_spec_id_seq OWNER TO postgres;

--
-- Name: edu_plan_spec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edu_plan_spec_id_seq OWNED BY public.edu_plan.spec_id;


--
-- Name: journal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journal (
    j_id integer NOT NULL,
    semester integer NOT NULL,
    year character varying(4),
    student_id integer,
    spec_id integer,
    grade integer,
    CONSTRAINT journal_grade_check CHECK ((grade = ANY (ARRAY[1, 2, 3, 4, 5]))),
    CONSTRAINT journal_semester_check CHECK ((semester = ANY (ARRAY[1, 2])))
);


ALTER TABLE public.journal OWNER TO postgres;

--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    f_name character varying(255) NOT NULL,
    s_name character varying(255) NOT NULL,
    p_name character varying(255),
    date_entry date NOT NULL,
    format character varying(20) NOT NULL,
    group_num integer NOT NULL,
    CONSTRAINT students_format_check CHECK (((format)::text = ANY (ARRAY[('Дневная'::character varying)::text, ('Заочная'::character varying)::text, ('Вечерняя'::character varying)::text])))
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: everything; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.everything AS
 SELECT students.f_name,
    students.s_name,
    students.p_name,
    students.date_entry,
    students.format,
    students.group_num,
    edu_plan.spec_name,
    edu_plan.subject,
    edu_plan.semester,
    edu_plan.plan_hours,
    edu_plan.exam,
    j.year,
    j.grade
   FROM ((public.journal j
     JOIN public.students USING (student_id))
     JOIN public.edu_plan USING (spec_id));


ALTER VIEW public.everything OWNER TO postgres;

--
-- Name: journal_j_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.journal_j_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.journal_j_id_seq OWNER TO postgres;

--
-- Name: journal_j_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.journal_j_id_seq OWNED BY public.journal.j_id;


--
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- Name: edu_plan spec_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edu_plan ALTER COLUMN spec_id SET DEFAULT nextval('public.edu_plan_spec_id_seq'::regclass);


--
-- Name: journal j_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal ALTER COLUMN j_id SET DEFAULT nextval('public.journal_j_id_seq'::regclass);


--
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- Data for Name: edu_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edu_plan (spec_id, spec_name, subject, semester, plan_hours, exam) FROM stdin;
1	Информационная безопасность	Веб-технологии	2	72	Экзамен
2	Дизайн	ui/ux-дизайн	1	35	Зачет
3	Кибербезопасность	DevOps	1	48	Зачет
\.


--
-- Data for Name: journal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journal (j_id, semester, year, student_id, spec_id, grade) FROM stdin;
1	1	2025	1	2	5
2	2	2025	2	1	3
3	2	2025	3	1	4
4	1	2025	3	3	5
5	1	2025	4	2	5
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, f_name, s_name, p_name, date_entry, format, group_num) FROM stdin;
1	Антон	Антонов	Антонович	2025-01-05	Заочная	125
2	Андрей	Курбатов	Кирилович	2025-09-01	Дневная	225
3	Михаил	Курбатов	Кирилович	2025-09-01	Дневная	225
4	Андрей	Зайцев	Артемович	2025-01-05	Заочная	125
\.


--
-- Name: edu_plan_spec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_plan_spec_id_seq', 1, false);


--
-- Name: journal_j_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.journal_j_id_seq', 5, true);


--
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 4, true);


--
-- Name: edu_plan edu_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edu_plan
    ADD CONSTRAINT edu_plan_pkey PRIMARY KEY (spec_id);


--
-- Name: journal journal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_pkey PRIMARY KEY (j_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: journal journal_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_spec_id_fkey FOREIGN KEY (spec_id) REFERENCES public.edu_plan(spec_id);


--
-- Name: journal journal_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- PostgreSQL database dump complete
--

\unrestrict tGi2NvB3bCpPcOm0KSnSA7WeYR2hgkeIDAuD3xeYHCkAfhoaJBPWgOnYUxFS8xz

--
-- PostgreSQL database cluster dump complete
--

