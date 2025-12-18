--
-- PostgreSQL database dump
--

\restrict WDcs2hklPadoQpqbFF4nMm8biLFLlBCffRyvcRzd6cYO60Y17HHnr35CcGjHR7z

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-09-09 19:40:05

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
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16402)
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
-- TOC entry 216 (class 1259 OID 16401)
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
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 216
-- Name: edu_plan_spec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edu_plan_spec_id_seq OWNED BY public.edu_plan.spec_id;


--
-- TOC entry 221 (class 1259 OID 16424)
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
-- TOC entry 219 (class 1259 OID 16414)
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
    CONSTRAINT students_format_check CHECK (((format)::text = ANY ((ARRAY['Дневная'::character varying, 'Заочная'::character varying, 'Вечерняя'::character varying])::text[])))
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16457)
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
-- TOC entry 220 (class 1259 OID 16423)
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
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 220
-- Name: journal_j_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.journal_j_id_seq OWNED BY public.journal.j_id;


--
-- TOC entry 218 (class 1259 OID 16413)
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
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 218
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- TOC entry 4750 (class 2604 OID 16405)
-- Name: edu_plan spec_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edu_plan ALTER COLUMN spec_id SET DEFAULT nextval('public.edu_plan_spec_id_seq'::regclass);


--
-- TOC entry 4752 (class 2604 OID 16427)
-- Name: journal j_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal ALTER COLUMN j_id SET DEFAULT nextval('public.journal_j_id_seq'::regclass);


--
-- TOC entry 4751 (class 2604 OID 16417)
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- TOC entry 4910 (class 0 OID 16402)
-- Dependencies: 217
-- Data for Name: edu_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edu_plan (spec_id, spec_name, subject, semester, plan_hours, exam) FROM stdin;
1	Информационная безопасность	Веб-технологии	2	72	Экзамен
2	Дизайн	ui/ux-дизайн	1	35	Зачет
3	Кибербезопасность	DevOps	1	48	Зачет
\.


--
-- TOC entry 4914 (class 0 OID 16424)
-- Dependencies: 221
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
-- TOC entry 4912 (class 0 OID 16414)
-- Dependencies: 219
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, f_name, s_name, p_name, date_entry, format, group_num) FROM stdin;
1	Антон	Антонов	Антонович	2025-01-05	Заочная	125
2	Андрей	Курбатов	Кирилович	2025-09-01	Дневная	225
3	Михаил	Курбатов	Кирилович	2025-09-01	Дневная	225
4	Андрей	Зайцев	Артемович	2025-01-05	Заочная	125
\.


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 216
-- Name: edu_plan_spec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_plan_spec_id_seq', 1, false);


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 220
-- Name: journal_j_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.journal_j_id_seq', 5, true);


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 218
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 4, true);


--
-- TOC entry 4758 (class 2606 OID 16411)
-- Name: edu_plan edu_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edu_plan
    ADD CONSTRAINT edu_plan_pkey PRIMARY KEY (spec_id);


--
-- TOC entry 4762 (class 2606 OID 16431)
-- Name: journal journal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_pkey PRIMARY KEY (j_id);


--
-- TOC entry 4760 (class 2606 OID 16422)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- TOC entry 4763 (class 2606 OID 16432)
-- Name: journal journal_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_spec_id_fkey FOREIGN KEY (spec_id) REFERENCES public.edu_plan(spec_id);


--
-- TOC entry 4764 (class 2606 OID 16437)
-- Name: journal journal_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


-- Completed on 2025-09-09 19:40:05

--
-- PostgreSQL database dump complete
--

\unrestrict WDcs2hklPadoQpqbFF4nMm8biLFLlBCffRyvcRzd6cYO60Y17HHnr35CcGjHR7z

