--
-- PostgreSQL database cluster dump
--

-- Started on 2025-06-10 22:52:57

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:6C8k90VzULzhZl4buUslhg==$lbpIg/+6Up9/k4skJXzGo/2jdE2bHlZByEiBz5W0CAo=:BWWi2CfEq+LEY5QI1cjEj8F0BAeJnYM6nzgn/yLFrk4=';

--
-- User Configurations
--








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

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 17.4

-- Started on 2025-06-10 22:52:58

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2025-06-10 22:53:06

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 17.4

-- Started on 2025-06-10 22:53:06

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2025-06-10 22:53:14

--
-- PostgreSQL database dump complete
--

--
-- Database "railway" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 17.4

-- Started on 2025-06-10 22:53:14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3429 (class 1262 OID 16384)
-- Name: railway; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE railway WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE railway OWNER TO postgres;

\connect railway

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 24577)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24580)
-- Name: archived_task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.archived_task (
    id integer NOT NULL,
    original_task_id integer,
    task_name character varying(200),
    employee_id integer,
    department_id integer,
    status character varying(50),
    date date,
    description text,
    archived_at timestamp without time zone
);


ALTER TABLE public.archived_task OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24585)
-- Name: archived_task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.archived_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.archived_task_id_seq OWNER TO postgres;

--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 217
-- Name: archived_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.archived_task_id_seq OWNED BY public.archived_task.id;


--
-- TOC entry 218 (class 1259 OID 24586)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24589)
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.department_id_seq OWNER TO postgres;

--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 219
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.department.id;


--
-- TOC entry 220 (class 1259 OID 24590)
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    department_id integer NOT NULL,
    password character varying(255) NOT NULL,
    username character varying(50) NOT NULL,
    role character varying(50),
    manager_id integer,
    phone character varying(20),
    job_title character varying(100),
    email character varying(120),
    country character varying(100),
    profile_image character varying(255),
    is_manager boolean,
    is_ceo boolean,
    is_hr boolean
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24593)
-- Name: employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_id_seq OWNER TO postgres;

--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 221
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_id_seq OWNED BY public.employee.id;


--
-- TOC entry 225 (class 1259 OID 40969)
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id integer NOT NULL,
    message character varying(500),
    is_read boolean DEFAULT false,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    task_id integer,
    employee_id integer
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 40968)
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_id_seq OWNER TO postgres;

--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 224
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_id_seq OWNED BY public.notification.id;


--
-- TOC entry 222 (class 1259 OID 24594)
-- Name: task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task (
    id integer NOT NULL,
    task_name character varying(200) NOT NULL,
    department_id integer NOT NULL,
    status character varying(50) NOT NULL,
    date date NOT NULL,
    employee_id integer NOT NULL,
    description text
);


ALTER TABLE public.task OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24599)
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_id_seq OWNER TO postgres;

--
-- TOC entry 3434 (class 0 OID 0)
-- Dependencies: 223
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_id_seq OWNED BY public.task.id;


--
-- TOC entry 227 (class 1259 OID 41001)
-- Name: task_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_tag (
    id integer NOT NULL,
    task_id integer NOT NULL,
    employee_id integer NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.task_tag OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 41000)
-- Name: task_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_tag_id_seq OWNER TO postgres;

--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 226
-- Name: task_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_tag_id_seq OWNED BY public.task_tag.id;


--
-- TOC entry 3232 (class 2604 OID 24600)
-- Name: archived_task id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archived_task ALTER COLUMN id SET DEFAULT nextval('public.archived_task_id_seq'::regclass);


--
-- TOC entry 3233 (class 2604 OID 24601)
-- Name: department id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 3234 (class 2604 OID 24602)
-- Name: employee id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN id SET DEFAULT nextval('public.employee_id_seq'::regclass);


--
-- TOC entry 3236 (class 2604 OID 40972)
-- Name: notification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification ALTER COLUMN id SET DEFAULT nextval('public.notification_id_seq'::regclass);


--
-- TOC entry 3235 (class 2604 OID 24603)
-- Name: task id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task ALTER COLUMN id SET DEFAULT nextval('public.task_id_seq'::regclass);


--
-- TOC entry 3239 (class 2604 OID 41004)
-- Name: task_tag id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tag ALTER COLUMN id SET DEFAULT nextval('public.task_tag_id_seq'::regclass);


--
-- TOC entry 3411 (class 0 OID 24577)
-- Dependencies: 215
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.alembic_version (version_num) VALUES ('cd9cea4a313b');


--
-- TOC entry 3412 (class 0 OID 24580)
-- Dependencies: 216
-- Data for Name: archived_task; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (1, 7, 'الاجتماع مع الداعم GIZ', 1, 5, 'مكتمل', '2025-04-05', 'الاجتماع مع الداعم من أجل مناقشة خطة العمل الجديدة', NULL);
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (2, 1, 'كتابة تقرير جديد', 1, 5, 'مكتمل', '2025-04-05', NULL, NULL);
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (3, 5, 'الاجتماع مع الإدارة', 1, 5, 'مكتمل', '2025-04-05', NULL, NULL);
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (4, 4, 'اجتماع مع الفريق الميداني', 2, 1, 'مكتمل', '2025-04-04', '', NULL);
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (5, NULL, 'تطوير النماذج', 1, 5, 'مكتمل', '2025-05-29', 'تطوير نماذج المراقبة والتقييم', '2025-05-25 09:47:07.747615');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (6, NULL, 'التنسيق والتخطيط لاجتماع الربعي لمشروع وتد في منطقتي عفرين والقامشلي', 4, 1, 'مكتمل', '2025-06-02', 'تشكيل مجموعة واتساب والتصويت على وقت الاجتماع', '2025-05-29 14:02:39.704383');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (7, NULL, 'متابعة التدريبات التقنية لمشروع وتد', 4, 1, 'مكتمل', '2025-06-02', 'متابعة تدريب المناصرة مع نذير', '2025-05-30 08:07:37.788719');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (8, NULL, 'متابعة التدريبات المعرفية لمشروع وتد', 4, 1, 'مكتمل', '2025-06-02', 'الوساطة والتفاوض مع سويس بيس', '2025-05-30 08:07:56.023045');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (9, NULL, 'متابعة توثيقات الدرايف', 4, 1, 'مكتمل', '2025-06-02', 'توثيقات التدريبات', '2025-05-30 08:07:57.428942');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (10, NULL, 'متابعة التواصل مع فريق الدعم النفسي / مشروع تكامل', 4, 1, 'مكتمل', '2025-06-02', 'تشكيل مجموعة واتساب والاتفاق على اجتماع لشرح المشروع', '2025-05-30 08:07:58.848139');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (11, NULL, 'البدء بوضع الخطوط العريضة لخارطة الخدمات في حلب', 4, 1, 'مكتمل', '2025-06-02', 'التعاون مع IM officer البدء بوضع خارطة الخدمات', '2025-05-30 08:08:00.264575');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (12, NULL, 'مقابلات عمل لمشروع وتد', 4, 1, 'مكتمل', '2025-06-02', 'تعيين اخصائي تحليل بيانات ومستشار العنف القائم على النوع الاجتماعي', '2025-05-30 08:08:01.67059');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (13, NULL, 'متابعة تشكيل فريق الدعم النفسي بحلب', 4, 1, 'مكتمل', '2025-05-26', 'متابعة مقابلات العمل الخاصة بتشكيل الفريق', '2025-05-30 08:08:23.704151');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (14, NULL, 'الاطار المنظقي لمشروع CFLI', 1, 5, 'مكتمل', '2025-05-28', 'المشاركة في اعداد الاطار المنظقي لمشروع CFLI واعداد خطة المراقبة', '2025-05-30 16:47:24.946277');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (15, NULL, 'جلسة تعريفية بطريقة التعامل مع الماتركس', 1, 5, 'مكتمل', '2025-05-26', 'التعريف بنظام الماتركس وتدريب الفريق على استخدامه خلال الأسبوع القادم', '2025-05-30 17:21:41.590674');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (16, NULL, 'مقابلات موظف المراقبة', 1, 5, 'مكتمل', '2025-05-30', 'التجهيز لمقابلات المتطوع في مكتب حلب هذا الاسبوع', '2025-05-30 17:34:32.749028');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (17, NULL, 'المتابعة الفنية للفريق', 1, 5, 'مكتمل', '2025-05-26', 'متابعة أداء الفريق فنياً خلال الأسبوع الأول لضمان سير العمل بسلاسة، مع متابعة كافة التوثيقات', '2025-05-30 17:35:39.813389');
INSERT INTO public.archived_task (id, original_task_id, task_name, employee_id, department_id, status, date, description, archived_at) VALUES (18, NULL, 'التنسيق مع فريق البرامج والشراكات', 1, 5, 'مكتمل', '2025-05-26', 'التواصل مع الفريق لجمع أرشيف المشاريع السابقة لتوثيقها وتحليلها.', '2025-05-30 17:36:34.312615');


--
-- TOC entry 3414 (class 0 OID 24586)
-- Dependencies: 218
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.department (id, name) VALUES (6, 'Administrative');
INSERT INTO public.department (id, name) VALUES (1, 'Program');
INSERT INTO public.department (id, name) VALUES (2, 'Operations');
INSERT INTO public.department (id, name) VALUES (3, 'Media');
INSERT INTO public.department (id, name) VALUES (4, 'Partnerships');
INSERT INTO public.department (id, name) VALUES (5, 'MEAL');


--
-- TOC entry 3416 (class 0 OID 24590)
-- Dependencies: 220
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (8, 'Alan Khalil', 2, 'darmn&K4', 'a_khalil', 'manager', 2, '+90 533 843 12 49', 'Operation Manager', 'akhalil@dar.ngo', 'Aleppo / Syria', 'dar.png', true, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (10, 'Hasan Daas', 2, 'darrs(0', 'h_daas', 'employee', 8, '+90 539 791 64 84', 'Finance Officer', 'Hdaas@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (11, 'Abd Alkader Sabbagh', 2, 'dartu)M6', 'a_sabbagh', 'employee', 8, '+352 681 562 096', 'Finance & Logistics Coordinator', 'asabbagh@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (12, 'Malik Omo', 2, 'darvw+N2', 'm_omo', 'employee', 8, '+963 938 730 076', 'Finance & Logistics Assistant', 'momo@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (13, 'Ebrahem Shehnabe', 2, 'darzy=J9', 'e_shehnabe', 'employee', 8, '+963 991 917 586', 'Finance & Logistics Assistant', 'inabi@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (14, 'Hussaim Morad', 2, 'darxz;R7', 'h_morad', 'employee', 8, '+964 750 408 0817', 'Head of the KRI Mission', 'liaison@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (15, 'Hazem Alzeer', 3, 'darye:T4', 'h_alzeer', 'manager', 2, '+964 750 391 7425', 'Media Officer', 'Hmohammad@dar.ngo', 'Aleppo / Syria', 'dar.png', true, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (16, 'Felix Legrand', 4, 'darwq''F1', 'f_legrand', 'manager', 2, '+33 7 45 68 80 18', 'Partnerships Supervisor', 'fLegrand@dar.ngo', 'Aleppo / Syria', 'dar.png', true, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (17, 'Raian Ani', 4, 'darli"D8', 'r_ani', 'employee', 16, '+963 995 038 276', 'Partnerships Officer', 'ralani@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (18, 'Silvart Salloum', 4, 'darsp?H5', 's_salloum', 'employee', 16, '+963 988 902 599', 'Partnerships Volunteer', 'ssalloum@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (9, 'Hiba Almanadili', 2, 'darop*V3', 'h_almanadili', 'employee', 8, '+963 982 245 836', 'HR Officer', 'hr@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, true);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (1, 'Mhedy Alkhaldi', 5, 'Metallica.com123', 'mhedy', 'admin', 2, '+90 531 953 56 99', 'MEAL Officer', 'malkhaldi@dar.ngo', 'Aleppo / Syria', 'dar.png', NULL, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (2, 'Samar Kattan', 6, 'darab!X5', 's_kattan', 'admin', NULL, '+33 6 68 82 46 03', 'CEO', 'skattan@dar.ngo', 'Aleppo / Syria', 'dar.png', false, true, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (3, 'Soulaf Abou Hamdan', 1, 'darcd#L8', 's_hamdan', 'manager', 1, '+962 7 8612 6291', 'Programs Coordinator', 'shamdan@dar.ngo', 'Aleppo / Syria', 'dar.png', true, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (4, 'Raghad Alabo', 1, 'daref$Q2', 'r_alabo', 'employee', 3, '+964 775 624 8939', 'Administrative Officer', 'ralabo@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (5, 'Khunaf Shammo', 1, 'dargh@W7', 'k_shammo', 'employee', 3, '+963 998 796 819', 'Area Coordinator', 'kshamo@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (6, 'Alia Shams', 1, 'darij%Z1', 'a_shams', 'employee', 3, '+963 993 630 858', 'Area Coordinator', 'Ashams@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);
INSERT INTO public.employee (id, name, department_id, password, username, role, manager_id, phone, job_title, email, country, profile_image, is_manager, is_ceo, is_hr) VALUES (7, 'Mohammad Alhadi', 1, 'darkl^P9', 'm_alhadi', 'employee', 3, '+90 535 577 12 97', 'Area Coordinator', 'Malhadi@dar.ngo', 'Aleppo / Syria', 'dar.png', false, NULL, NULL);


--
-- TOC entry 3421 (class 0 OID 40969)
-- Dependencies: 225
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (1, 'المهمة ''اجتماع ممثل قطاع الحماية HAC - الاحد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (2, 'المهمة ''اجتماع شراكات وتحديد خطة آيار وتوزع الادوار'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (3, 'المهمة ''تقرير نساء المتوسط - تقييم مبادرات محلية'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (4, 'المهمة ''اجتماع تنسيقي مع محافظ حلب - الاثنين'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (5, 'المهمة ''المشاركة بمناقشة واعداد كونسبت الكندي CFLI'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (6, 'المهمة ''تقرير زيارة حلب والاجتماعات'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (7, 'المهمة ''متابعة المحاسب القانوني - مراجعة البنك ، حل مشكلة الحوالات'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (8, 'المهمة ''اجتماع برامج - مقابلات تكامل اختيار الفريق'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (9, 'المهمة ''اجتماع مع مستشارة fdf آنييس لمشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (10, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (11, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (12, 'المهمة ''تثبيت اسماء متدربات مشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (13, 'المهمة ''اجتماع مع قطاع الحماية'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (14, 'المهمة ''مقابلات عمل لمشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (15, 'المهمة ''نشر بوست بخصوص تدريبات وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (16, 'المهمة ''متابعة نشر اعلانات مشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (17, 'المهمة ''التخطيط للبدء بمقابلات تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (18, 'المهمة ''الاجتماع مع فريق دار في حلب'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (19, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (20, 'المهمة ''متابعة التدريبات المعرفية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (21, 'المهمة ''متابعة توثيقات الدرايف'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 10:59:22.24863', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (22, 'المهمة ''اجتماع ممثل قطاع الحماية HAC - الاحد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (23, 'المهمة ''اجتماع شراكات وتحديد خطة آيار وتوزع الادوار'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (24, 'المهمة ''تقرير نساء المتوسط - تقييم مبادرات محلية'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (25, 'المهمة ''اجتماع تنسيقي مع محافظ حلب - الاثنين'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (26, 'المهمة ''المشاركة بمناقشة واعداد كونسبت الكندي CFLI'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (27, 'المهمة ''تقرير زيارة حلب والاجتماعات'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (28, 'المهمة ''متابعة المحاسب القانوني - مراجعة البنك ، حل مشكلة الحوالات'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (29, 'المهمة ''اجتماع برامج - مقابلات تكامل اختيار الفريق'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (30, 'المهمة ''اجتماع مع مستشارة fdf آنييس لمشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (31, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (32, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (33, 'المهمة ''تثبيت اسماء متدربات مشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (34, 'المهمة ''اجتماع مع قطاع الحماية'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (35, 'المهمة ''مقابلات عمل لمشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (36, 'المهمة ''نشر بوست بخصوص تدريبات وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (37, 'المهمة ''متابعة نشر اعلانات مشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (38, 'المهمة ''التخطيط للبدء بمقابلات تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (39, 'المهمة ''الاجتماع مع فريق دار في حلب'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (40, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (41, 'المهمة ''متابعة التدريبات المعرفية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (42, 'المهمة ''متابعة توثيقات الدرايف'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:04:51.647717', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (43, 'المهمة ''اجتماع ممثل قطاع الحماية HAC - الاحد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (44, 'المهمة ''اجتماع شراكات وتحديد خطة آيار وتوزع الادوار'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (45, 'المهمة ''تقرير نساء المتوسط - تقييم مبادرات محلية'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (46, 'المهمة ''اجتماع تنسيقي مع محافظ حلب - الاثنين'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (47, 'المهمة ''المشاركة بمناقشة واعداد كونسبت الكندي CFLI'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (48, 'المهمة ''تقرير زيارة حلب والاجتماعات'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (49, 'المهمة ''متابعة المحاسب القانوني - مراجعة البنك ، حل مشكلة الحوالات'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (50, 'المهمة ''اجتماع برامج - مقابلات تكامل اختيار الفريق'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (51, 'المهمة ''اجتماع مع مستشارة fdf آنييس لمشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (52, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (53, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (54, 'المهمة ''تثبيت اسماء متدربات مشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (55, 'المهمة ''اجتماع مع قطاع الحماية'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (56, 'المهمة ''مقابلات عمل لمشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (57, 'المهمة ''نشر بوست بخصوص تدريبات وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (58, 'المهمة ''متابعة نشر اعلانات مشروع تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (59, 'المهمة ''التخطيط للبدء بمقابلات تكامل'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (60, 'المهمة ''الاجتماع مع فريق دار في حلب'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (61, 'المهمة ''متابعة التدريبات التقنية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (62, 'المهمة ''متابعة التدريبات المعرفية لمشروع وتد'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (63, 'المهمة ''متابعة توثيقات الدرايف'' متأخرة ولم تُنجز حتى الآن.', false, '2025-05-20 11:40:00.968878', NULL, NULL);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (65, 'المهمة ''اجتماع برامج - مقابلات تكامل اختيار الفريق'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:21.01601', 19, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (66, 'المهمة ''متابعة المحاسب القانوني - مراجعة البنك ، حل مشكلة الحوالات'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:21.23343', 18, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (67, 'المهمة ''تقرير زيارة حلب والاجتماعات'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:21.459139', 17, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (68, 'المهمة ''المشاركة بمناقشة واعداد كونسبت الكندي CFLI'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:21.68359', 16, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (69, 'المهمة ''اجتماع تنسيقي مع محافظ حلب - الاثنين'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:21.876706', 15, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (70, 'المهمة ''تقرير نساء المتوسط - تقييم مبادرات محلية'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:22.065372', 14, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (71, 'المهمة ''اجتماع شراكات وتحديد خطة آيار وتوزع الادوار'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:22.262757', 13, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (72, 'المهمة ''اجتماع ممثل قطاع الحماية HAC - الاحد'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:22.456071', 12, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (73, 'المهمة ''نشر بوست بخصوص تدريبات وتد'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 09:51:22.964882', 49, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (75, 'المهمة ''اجتماع ممثل قطاع الحماية HAC - الاحد'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:19.007675', 12, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (76, 'المهمة ''اجتماع شراكات وتحديد خطة آيار وتوزع الادوار'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:19.19429', 13, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (77, 'المهمة ''تقرير نساء المتوسط - تقييم مبادرات محلية'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:19.376342', 14, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (78, 'المهمة ''اجتماع تنسيقي مع محافظ حلب - الاثنين'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:19.562109', 15, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (79, 'المهمة ''المشاركة بمناقشة واعداد كونسبت الكندي CFLI'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:19.74122', 16, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (80, 'المهمة ''تقرير زيارة حلب والاجتماعات'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:19.935138', 17, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (81, 'المهمة ''متابعة المحاسب القانوني - مراجعة البنك ، حل مشكلة الحوالات'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:20.111312', 18, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (82, 'المهمة ''اجتماع برامج - مقابلات تكامل اختيار الفريق'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:20.296875', 19, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (84, 'المهمة ''نشر بوست بخصوص تدريبات وتد'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', false, '2025-05-21 14:12:20.648596', 49, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (85, 'المهمة ''اجتماع ممثل قطاع الحماية HAC - الاحد'' متأخرة', false, '2025-05-21 14:24:15.455573', 12, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (86, 'المهمة ''اجتماع شراكات وتحديد خطة آيار وتوزع الادوار'' متأخرة', false, '2025-05-21 14:24:15.637795', 13, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (87, 'المهمة ''تقرير نساء المتوسط - تقييم مبادرات محلية'' متأخرة', false, '2025-05-21 14:24:15.828557', 14, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (88, 'المهمة ''اجتماع تنسيقي مع محافظ حلب - الاثنين'' متأخرة', false, '2025-05-21 14:24:16.025639', 15, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (89, 'المهمة ''المشاركة بمناقشة واعداد كونسبت الكندي CFLI'' متأخرة', false, '2025-05-21 14:24:16.224854', 16, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (90, 'المهمة ''تقرير زيارة حلب والاجتماعات'' متأخرة', false, '2025-05-21 14:24:16.407932', 17, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (91, 'المهمة ''متابعة المحاسب القانوني - مراجعة البنك ، حل مشكلة الحوالات'' متأخرة', false, '2025-05-21 14:24:16.59557', 18, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (92, 'المهمة ''اجتماع برامج - مقابلات تكامل اختيار الفريق'' متأخرة', false, '2025-05-21 14:24:16.784433', 19, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (94, 'المهمة ''نشر بوست بخصوص تدريبات وتد'' متأخرة', false, '2025-05-21 14:24:17.157917', 49, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (93, 'المهمة ''اجتماع مع مستشارة fdf آنييس لمشروع تكامل'' متأخرة', true, '2025-05-21 14:24:16.963885', 20, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (64, 'المهمة ''اجتماع مع مستشارة fdf آنييس لمشروع تكامل'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', true, '2025-05-21 09:51:20.796811', 20, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (83, 'المهمة ''اجتماع مع مستشارة fdf آنييس لمشروع تكامل'' متأخرة (كانت من المقرر إنجازها في 2025-05-19)', true, '2025-05-21 14:12:20.477014', 20, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (96, 'تمت الإشارة إليك في المهمة ''انهاء عقود شهر 5 لكل المشاريع'' بواسطة Hiba Almanadili', false, '2025-05-24 09:37:46.558105', 74, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (97, 'تمت الإشارة إليك في المهمة ''العمل على تعديلات تقرير مشروع الجيز الاخير'' بواسطة Hiba Almanadili', false, '2025-05-24 09:41:48.455018', 77, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (132, 'المهمة ''متابعة نشاط التدريبات في مشروع وتد \درايف مع التقييم -انهاء تدريبات مع المتدربات\توثيق مع المنسقين ورغد'' متأخرة', false, '2025-05-30 20:55:30.999891', 96, 3);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (100, 'المهمة ''التنسيق مع حسن من اجل النظام المالي الجديد'' متأخرة', false, '2025-05-26 06:56:37.822413', 71, 12);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (101, 'المهمة ''التنسيق مع خناف في مشروع وتد'' متأخرة', false, '2025-05-26 06:56:38.12977', 72, 12);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (102, 'المهمة ''التنسيق مع خناف فيما يخص مشروع نوى '' متأخرة', false, '2025-05-26 06:56:38.436398', 73, 12);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (103, 'المهمة ''تحديث ملف List of Experiences '' متأخرة', false, '2025-05-26 06:56:38.74226', 81, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (106, 'المهمة ''إستكمال إرفاق و إضافة الملفات الخاصة ب قسم الشراكات'' متأخرة', false, '2025-05-28 09:06:44.156948', 32, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (107, 'المهمة ''Activities Bank إنشاء ملف'' متأخرة', false, '2025-05-28 09:06:44.471996', 33, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (108, 'المهمة ''المشاركة مع ريعان في صياغة CFLI Proposed Concept'' متأخرة', false, '2025-05-28 09:06:44.787497', 34, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (109, 'المهمة ''إطلاق Dashboard للمشاريع'' متأخرة', false, '2025-05-28 09:06:45.102253', 28, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (110, 'المهمة ''توثيق مشروع وتد للتقرير الربعي'' متأخرة', false, '2025-05-28 09:06:45.417308', 26, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (115, 'المهمة ''العمل على تعديلات تقرير مشروع الجيز الاخير'' متأخرة', false, '2025-05-28 09:06:47.630351', 77, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (116, 'المهمة ''تقديم concept ل ISDB '' متأخرة', false, '2025-05-28 09:06:48.106194', 82, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (117, 'المهمة ''كتابة ال Concept ل Rich '' متأخرة', false, '2025-05-28 09:06:48.422295', 87, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (118, 'المهمة ''تجهيز التقارير المالية '' متأخرة', false, '2025-05-28 09:06:48.737964', 86, 10);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (119, 'المهمة ''PDM مشروع نوى'' متأخرة', false, '2025-05-29 10:18:52.50279', 70, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (120, 'المهمة ''انهاء عقود شهر 5 لكل المشاريع'' متأخرة', false, '2025-05-29 10:18:53.271355', 74, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (121, 'المهمة ''العمل على تقرير وتد'' متأخرة', false, '2025-05-29 10:18:53.731622', 78, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (122, 'المهمة ''العمل على تقرير نوى'' متأخرة', false, '2025-05-29 10:18:54.037942', 80, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (133, 'تمت الإشارة إليك في المهمة ''اجتماع مع ربا غانم استشاري تصميم الاستبيان لمباشرة العمل على خطة النشاط الثاني في مشروع وتد'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 20:58:53.272144', 97, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (124, 'تمت الإشارة إليك في المهمة ''تكملة تصاميم مركز حلب'' بواسطة Hazem Alzeer', false, '2025-05-29 12:09:02.532299', 90, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (125, 'تمت الإشارة إليك في المهمة ''موشن غرافيك مشروع نوى'' بواسطة Hazem Alzeer', false, '2025-05-29 12:20:55.423277', 91, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (126, 'تمت الإشارة إليك في المهمة ''تغطية برومو مشروع نوى'' بواسطة Hazem Alzeer', false, '2025-05-29 12:27:39.144833', 92, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (127, 'المهمة ''التنسيق مع مالك ومسعود ومحمد الهادي من اجل جرد الصناديق والتاكد من اعتماد النماذج الجديدة '' متأخرة', false, '2025-05-30 08:07:00.702785', 89, 10);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (128, 'المهمة ''التنسيق من أجل اجتماع الكلاسترات '' متأخرة', false, '2025-05-30 08:07:01.015616', 88, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (181, 'المهمة ''نظام الشكاوى'' متأخرة', false, '2025-06-10 13:07:32.307492', 95, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (98, 'تمت الإشارة إليك في المهمة ''الاطار المنظقي لمشروع CFLI'' بواسطة Mhedy Alkhaldi', false, '2025-05-24 10:04:31.622706', NULL, 17);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (123, 'المهمة ''الاطار المنظقي لمشروع CFLI'' متأخرة', false, '2025-05-29 10:18:54.651073', NULL, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (112, 'المهمة ''جلسة تعريفية بطريقة التعامل مع الماتركس'' متأخرة', false, '2025-05-28 09:06:46.210433', NULL, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (99, 'تمت الإشارة إليك في المهمة ''مقابلات موظف المراقبة'' بواسطة Mhedy Alkhaldi', true, '2025-05-24 10:05:42.132652', NULL, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (104, 'المهمة ''المتابعة الفنية للفريق'' متأخرة', false, '2025-05-28 09:06:43.524774', NULL, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (105, 'المهمة ''التنسيق مع فريق البرامج والشراكات'' متأخرة', false, '2025-05-28 09:06:43.842134', NULL, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (129, 'تمت الإشارة إليك في المهمة ''متابعة نشاط التدريبات في مشروع وتد \درايف مع التقييم -انهاء تدريبات مع المتدربات\توثيق مع المنسقين ورغد'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 20:55:25.275333', 96, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (130, 'تمت الإشارة إليك في المهمة ''متابعة نشاط التدريبات في مشروع وتد \درايف مع التقييم -انهاء تدريبات مع المتدربات\توثيق مع المنسقين ورغد'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 20:55:25.275336', 96, 5);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (131, 'تمت الإشارة إليك في المهمة ''متابعة نشاط التدريبات في مشروع وتد \درايف مع التقييم -انهاء تدريبات مع المتدربات\توثيق مع المنسقين ورغد'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 20:55:25.275339', 96, 7);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (134, 'المهمة ''اجتماع مع ربا غانم استشاري تصميم الاستبيان لمباشرة العمل على خطة النشاط الثاني في مشروع وتد'' متأخرة', false, '2025-05-30 20:58:59.089588', 97, 3);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (135, 'تمت الإشارة إليك في المهمة ''عقد اجتماع بين الاستشارية والمستفيدات للتحضير لاستبيان الوصمة'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 21:13:46.923059', 98, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (111, 'المهمة ''متابعة تشكيل فريق الدعم النفسي بحلب'' متأخرة', true, '2025-05-28 09:06:45.895376', NULL, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (136, 'تمت الإشارة إليك في المهمة ''عقد اجتماع بين الاستشارية والمستفيدات للتحضير لاستبيان الوصمة'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 21:13:46.923064', 98, 5);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (137, 'تمت الإشارة إليك في المهمة ''عقد اجتماع بين الاستشارية والمستفيدات للتحضير لاستبيان الوصمة'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 21:13:46.923065', 98, 7);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (138, 'تمت الإشارة إليك في المهمة ''اجتماع متابعة انطلاق فريق مشروع تكامل'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 21:22:26.716107', 99, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (139, 'تمت الإشارة إليك في المهمة ''متابعة استكمال درايف نوى '' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 21:26:07.404486', 100, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (140, 'تمت الإشارة إليك في المهمة ''متابعة استكمال درايف نوى '' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 21:26:07.404489', 100, 5);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (141, 'تمت الإشارة إليك في المهمة ''متابعة اوراق اثر الاساسية (برزنتيشن اطلاق\خطة زمنية\تفكيك الانشطة)'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 21:32:46.883243', 101, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (142, 'تمت الإشارة إليك في المهمة ''متابعة اوراق اثر الاساسية (برزنتيشن اطلاق\خطة زمنية\تفكيك الانشطة)'' بواسطة Soulaf Abou Hamdan', false, '2025-05-30 21:32:46.883247', 101, 6);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (143, 'المهمة ''مقابلات عمل لمشروع تكامل'' متأخرة', false, '2025-05-31 07:23:26.999965', 75, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (144, 'المهمة ''مقابلات عمل لمشروع وتد'' متأخرة', false, '2025-05-31 07:23:27.316099', 76, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (145, 'تمت الإشارة إليك في المهمة ''استكمال إعادة تأهيل مركز حلب '' بواسطة Alan Khalil', false, '2025-05-31 08:36:53.195923', 113, 11);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (146, 'تمت الإشارة إليك في المهمة ''استكمال إعادة تأهيل مركز حلب '' بواسطة Alan Khalil', false, '2025-05-31 08:37:05.839579', 114, 11);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (147, 'تمت الإشارة إليك في المهمة ''استكمال تقرير وتد الأولي '' بواسطة Alan Khalil', false, '2025-05-31 08:39:24.932261', 115, 10);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (148, 'تمت الإشارة إليك في المهمة ''استكمال تقرير وتد الأولي '' بواسطة Alan Khalil', false, '2025-05-31 08:39:24.932264', 115, 11);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (149, 'تمت الإشارة إليك في المهمة ''استكمال تقرير وتد الأولي '' بواسطة Alan Khalil', false, '2025-05-31 08:39:24.932265', 115, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (150, 'تمت الإشارة إليك في المهمة ''إنهاء استكملات تقرير نوى الأول للمشروع الزراعي '' بواسطة Alan Khalil', false, '2025-05-31 08:40:57.907207', 116, 10);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (151, 'تمت الإشارة إليك في المهمة ''إنهاء استكملات تقرير نوى الأول للمشروع الزراعي '' بواسطة Alan Khalil', false, '2025-05-31 08:40:57.90721', 116, 11);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (152, 'تمت الإشارة إليك في المهمة ''إنهاء استكملات تقرير نوى الأول للمشروع الزراعي '' بواسطة Alan Khalil', false, '2025-05-31 08:40:57.90721', 116, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (153, 'تمت الإشارة إليك في المهمة ''استكمال التدريبات للقسم المالي واللوجستي '' بواسطة Alan Khalil', false, '2025-05-31 08:43:15.297049', 118, 10);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (154, 'تمت الإشارة إليك في المهمة ''استكمال التدريبات للقسم المالي واللوجستي '' بواسطة Alan Khalil', false, '2025-05-31 08:43:15.297053', 118, 11);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (155, 'تمت الإشارة إليك في المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' بواسطة Samar Kattan', false, '2025-05-31 10:27:06.734717', 130, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (156, 'تمت الإشارة إليك في المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' بواسطة Samar Kattan', false, '2025-05-31 10:27:29.363385', 131, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (157, 'تمت الإشارة إليك في المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' بواسطة Samar Kattan', false, '2025-05-31 10:27:30.284476', 132, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (158, 'تمت الإشارة إليك في المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' بواسطة Samar Kattan', false, '2025-05-31 10:27:31.204423', 133, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (159, 'تمت الإشارة إليك في المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' بواسطة Samar Kattan', false, '2025-05-31 10:27:32.120807', 134, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (160, 'تمت الإشارة إليك في المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' بواسطة Samar Kattan', false, '2025-05-31 10:27:33.035402', 135, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (161, 'تمت الإشارة إليك في المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' بواسطة Samar Kattan', false, '2025-05-31 10:28:08.805892', 136, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (162, 'تمت الإشارة إليك في المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' بواسطة Samar Kattan', false, '2025-05-31 10:28:09.725031', 137, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (163, 'تمت الإشارة إليك في المهمة ''مناقشة التقديم لمنحة IsDB الديد لاين ١٢ حزيران'' بواسطة Samar Kattan', false, '2025-05-31 10:40:29.79047', 143, 16);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (164, 'تمت الإشارة إليك في المهمة ''مناقشة التقديم لمنحة IsDB الديد لاين ١٢ حزيران'' بواسطة Samar Kattan', false, '2025-05-31 10:40:29.790472', 143, 17);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (165, 'تمت الإشارة إليك في المهمة ''مراجعة درايف مشروع نوى '' بواسطة Samar Kattan', false, '2025-05-31 10:42:57.806025', 144, 8);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (166, 'تمت الإشارة إليك في المهمة ''مراجعة درايف مشروع نوى '' بواسطة Samar Kattan', false, '2025-05-31 10:42:57.806029', 144, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (167, 'تمت الإشارة إليك في المهمة ''مراجعة درايف مشروع نوى '' بواسطة Samar Kattan', false, '2025-05-31 10:42:57.80603', 144, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (168, 'تمت الإشارة إليك في المهمة ''مراجعة درايف مشروع نوى '' بواسطة Samar Kattan', false, '2025-05-31 10:42:57.806031', 144, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (169, 'تمت الإشارة إليك في المهمة ''مراجعة درايف مشروع نوى '' بواسطة Samar Kattan', false, '2025-05-31 10:42:57.806031', 144, 3);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (170, 'المهمة ''BSF meeting'' متأخرة', false, '2025-06-10 13:07:26.604087', 56, 6);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (171, 'المهمة ''معرض لافتات كفرنبل'' متأخرة', false, '2025-06-10 13:07:26.921107', 58, 6);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (172, 'المهمة ''متابعة قرار الترخيص في المديرية والوزارة'' متأخرة', false, '2025-06-10 13:07:27.229193', 57, 6);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (173, 'المهمة ''مشروع المبادرات'' متأخرة', false, '2025-06-10 13:07:27.539634', 59, 6);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (174, 'المهمة ''مشروع نساء المتوسط'' متأخرة', false, '2025-06-10 13:07:27.846943', 60, 6);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (175, 'المهمة ''زيارة ميدانية الى دير العصافير'' متأخرة', false, '2025-06-10 13:07:28.155388', 61, 6);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (176, 'المهمة ''موشن غرافيك مشروع نوى'' متأخرة', false, '2025-06-10 13:07:30.616156', 91, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (177, 'المهمة ''تغطية برومو مشروع نوى'' متأخرة', false, '2025-06-10 13:07:31.077826', 92, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (178, 'المهمة ''التعديل على بروفايل المنظمة'' متأخرة', false, '2025-06-10 13:07:31.38552', 93, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (179, 'المهمة ''تكملة تصاميم مركز حلب'' متأخرة', false, '2025-06-10 13:07:31.69285', 90, 15);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (180, 'المهمة ''تحديث السياسات'' متأخرة', false, '2025-06-10 13:07:32.000044', 94, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (182, 'المهمة ''عقد اجتماع بين الاستشارية والمستفيدات للتحضير لاستبيان الوصمة'' متأخرة', false, '2025-06-10 13:07:32.614958', 98, 3);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (183, 'المهمة ''اجتماع متابعة انطلاق فريق مشروع تكامل'' متأخرة', false, '2025-06-10 13:07:33.230953', 99, 3);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (184, 'المهمة ''متابعة استكمال درايف نوى '' متأخرة', false, '2025-06-10 13:07:33.538539', 100, 3);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (185, 'المهمة ''متابعة اوراق اثر الاساسية (برزنتيشن اطلاق\خطة زمنية\تفكيك الانشطة)'' متأخرة', false, '2025-06-10 13:07:33.845977', 101, 3);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (186, 'المهمة ''إنشاء ملف يتضمن الداعمين المحتملين و الحاليين و إعلانات المنح مترافقة مع الديد لاين و ملخص عن الأفكار '' متأخرة', false, '2025-06-10 13:07:34.152952', 102, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (187, 'المهمة ''إنشاء ملف يتضمن الداعمين المحتملين و الحاليين و إعلانات المنح مترافقة مع الديد لاين و ملخص عن الأفكار '' متأخرة', false, '2025-06-10 13:07:34.459798', 103, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (188, 'المهمة ''إنشاء ملف يتضمن الداعمين المحتملين و الحاليين و إعلانات المنح مترافقة مع الديد لاين و ملخص عن الأفكار '' متأخرة', false, '2025-06-10 13:07:34.767307', 104, 18);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (189, 'المهمة ''متابعة التدريبات المعرفية لمشروع وتد'' متأخرة', false, '2025-06-10 13:07:35.075455', 105, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (190, 'المهمة ''متابعة درايف توثيقات وتد'' متأخرة', false, '2025-06-10 13:07:35.382612', 106, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (191, 'المهمة ''متابعة توثيقات درايف نوى'' متأخرة', false, '2025-06-10 13:07:35.689804', 107, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (192, 'المهمة ''استكمال بعض الملفات المطلوبة لتقرير GIZ'' متأخرة', false, '2025-06-10 13:07:35.996972', 108, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (193, 'المهمة ''التواصل مع الجهات الفاعلة لمعرفة الخدمات المقدمة في حلب'' متأخرة', false, '2025-06-10 13:07:36.304238', 109, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (194, 'المهمة ''وضع خطة لاستقطاب المستفيدات لمشروع تكامل'' متأخرة', false, '2025-06-10 13:07:36.611673', 110, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (195, 'المهمة ''اجتماعات فردية مع فريق الدعم النفسي لمشروع تكامل '' متأخرة', false, '2025-06-10 13:07:36.918916', 111, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (196, 'المهمة ''التخطيط لورقة إحالة خاصة بمشروع تكامل و بروشور تعريفي عن المشروع'' متأخرة', false, '2025-06-10 13:07:37.225951', 112, 4);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (197, 'المهمة ''استكمال إعادة تأهيل مركز حلب '' متأخرة', false, '2025-06-10 13:07:37.533073', 113, 8);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (198, 'المهمة ''استكمال إعادة تأهيل مركز حلب '' متأخرة', false, '2025-06-10 13:07:37.840088', 114, 8);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (199, 'المهمة ''استكمال تقرير وتد الأولي '' متأخرة', false, '2025-06-10 13:07:38.14748', 115, 8);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (200, 'المهمة ''إنهاء استكملات تقرير نوى الأول للمشروع الزراعي '' متأخرة', false, '2025-06-10 13:07:38.454524', 116, 8);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (201, 'المهمة ''ميزانية منحة نساء المتوسط '' متأخرة', false, '2025-06-10 13:07:38.76172', 117, 8);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (202, 'المهمة ''استكمال التدريبات للقسم المالي واللوجستي '' متأخرة', false, '2025-06-10 13:07:39.069395', 118, 8);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (203, 'المهمة ''مناقشة والعمل على منح جديدة بالتنسيق مع قسم الشراكات '' متأخرة', false, '2025-06-10 13:07:39.376866', 119, 8);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (204, 'المهمة ''متابعة الفريق المالي في الرقة و القامشلي وعفرين '' متأخرة', false, '2025-06-10 13:07:39.684656', 120, 10);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (205, 'المهمة ''بدء تدريب المتطوعة بقسم المراقبة'' متأخرة', false, '2025-06-10 13:07:39.991996', 121, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (206, 'المهمة ''المتابعة الروتينية للمشاريع'' متأخرة', false, '2025-06-10 13:07:40.299924', 122, 1);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (207, 'المهمة ''الانتهاء من التوثيقات المالية في مكتب القامشلي'' متأخرة', false, '2025-06-10 13:07:40.607381', 123, 12);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (208, 'المهمة ''البدء بتطبيق النظام المالي الجديد'' متأخرة', false, '2025-06-10 13:07:40.914504', 124, 12);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (209, 'المهمة ''تسليم اجندة تدريب الموارد لسمر'' متأخرة', false, '2025-06-10 13:07:41.22196', 127, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (210, 'المهمة ''تسليم اجندة تدريب الموارد لسمر'' متأخرة', false, '2025-06-10 13:07:41.529558', 128, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (211, 'المهمة ''تسليم تقرير وتد ونوى بما يخص الموارد'' متأخرة', false, '2025-06-10 13:07:41.836974', 129, 9);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (212, 'المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' متأخرة', false, '2025-06-10 13:07:42.144389', 130, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (213, 'المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' متأخرة', false, '2025-06-10 13:07:42.452292', 131, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (214, 'المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' متأخرة', false, '2025-06-10 13:07:42.759684', 132, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (215, 'المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' متأخرة', false, '2025-06-10 13:07:43.067039', 133, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (216, 'المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' متأخرة', false, '2025-06-10 13:07:43.374212', 134, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (217, 'المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' متأخرة', false, '2025-06-10 13:07:43.68138', 135, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (218, 'المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' متأخرة', false, '2025-06-10 13:07:43.988652', 136, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (219, 'المهمة ''تحضير محتوى عرض دار بمؤتمر قمة المناخ'' متأخرة', false, '2025-06-10 13:07:44.295724', 137, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (220, 'المهمة ''حضور مؤتمر قمة المناخ في دبي ٣-٤ حزيران '' متأخرة', false, '2025-06-10 13:07:44.60305', 138, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (221, 'المهمة ''حضور مؤتمر قمة المناخ في دبي ٣-٤ حزيران '' متأخرة', false, '2025-06-10 13:07:44.910598', 139, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (222, 'المهمة ''حضور اجتماع مناقشة مقترح المنحة البريطانية UKHIH'' متأخرة', false, '2025-06-10 13:07:45.217864', 140, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (223, 'المهمة ''حضور اجتماع مناقشة مقترح المنحة البريطانية UKHIH'' متأخرة', false, '2025-06-10 13:07:45.525693', 141, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (224, 'المهمة ''حضور اجتماع مناقشة مقترح المنحة البريطانية UKHIH'' متأخرة', false, '2025-06-10 13:07:45.832798', 142, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (225, 'المهمة ''مناقشة التقديم لمنحة IsDB الديد لاين ١٢ حزيران'' متأخرة', false, '2025-06-10 13:07:46.140596', 143, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (226, 'المهمة ''مراجعة درايف مشروع نوى '' متأخرة', false, '2025-06-10 13:07:46.448713', 144, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (227, 'المهمة ''تجهيز خطة شهر حزيران للمنظمة'' متأخرة', false, '2025-06-10 13:07:46.756109', 145, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (228, 'المهمة ''تجهيز خطة شهر حزيران للمنظمة'' متأخرة', false, '2025-06-10 13:07:47.070387', 146, 2);
INSERT INTO public.notification (id, message, is_read, "timestamp", task_id, employee_id) VALUES (229, 'المهمة ''تجهيز خطة شهر حزيران للمنظمة'' متأخرة', false, '2025-06-10 13:07:47.383729', 147, 2);


--
-- TOC entry 3418 (class 0 OID 24594)
-- Dependencies: 222
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (12, 'اجتماع ممثل قطاع الحماية HAC - الاحد', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (13, 'اجتماع شراكات وتحديد خطة آيار وتوزع الادوار', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (14, 'تقرير نساء المتوسط - تقييم مبادرات محلية', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (15, 'اجتماع تنسيقي مع محافظ حلب - الاثنين', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (16, 'المشاركة بمناقشة واعداد كونسبت الكندي CFLI', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (17, 'تقرير زيارة حلب والاجتماعات', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (18, 'متابعة المحاسب القانوني - مراجعة البنك ، حل مشكلة الحوالات', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (19, 'اجتماع برامج - مقابلات تكامل اختيار الفريق', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (20, 'اجتماع مع مستشارة fdf آنييس لمشروع تكامل', 6, 'قيد التنفيذ', '2025-05-19', 2, NULL);
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (32, 'إستكمال إرفاق و إضافة الملفات الخاصة ب قسم الشراكات', 4, 'جاري العمل', '2025-05-26', 18, 'إنشاء حساب خاص بالشراكات على Google Drive 
يتضمن (Links for registration and follow-up,  Licenses, Profile, Presentation, Meetings with team, Meetings with Donors, ongoing proposals...etc) ,');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (33, 'Activities Bank إنشاء ملف', 4, 'جاري العمل', '2025-05-26', 18, 'إنشاء ملف يتضمن جميع الأفكار المطروحة ضمن فريق الشراكات خلال العصف الذهني لأي مقترح بما يضمن الاستناد على بياناته خلال ال urgent proposals
و الإستفادة من جميع الأفكار خلال العمل على أي مقترح.');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (30, 'تقرير تقييم الاحتياج الزراعي', 5, 'مكتمل', '2025-05-26', 1, 'إعداد وإرسال تقرير يقيّم الاحتياجات الزراعية بناءً على البيانات المتاحة.');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (27, 'النسخة النهائية من PDM لمشروع نوى', 5, 'مكتمل', '2025-05-26', 1, 'مراجعة والموافقة على النسخة النهائية من PDM وإعداد الاستبيان الخاص بمشروع نوى.');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (28, 'إطلاق Dashboard للمشاريع', 5, 'معلق', '2025-05-26', 1, 'إنشاء لوحة تحكم تشمل المشاريع الحالية ومشروع آغورا السابق لمتابعة الأداء.');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (34, 'المشاركة مع ريعان في صياغة CFLI Proposed Concept', 4, 'مكتمل', '2025-05-26', 18, 'المشاركة مع ريعان في كتابة proposed concept 
بناءً على طلب من أ. سمر 
( المسار التدريبي)');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (43, 'متابعة التدريبات التقنية لمشروع وتد', 1, 'مكتمل', '2025-05-19', 4, 'استكمال تدريب فن المناظرة');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (44, 'متابعة التدريبات التقنية لمشروع وتد', 1, 'مكتمل', '2025-05-19', 4, 'تدريب تحليل السياق مع عبد الفتاح شيخ عمر');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (46, 'تثبيت اسماء متدربات مشروع وتد', 1, 'مكتمل', '2025-05-19', 4, 'المتابعة مع محمد وخناف بشأن ترميم الفرق في عفرين والقامشلي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (47, 'اجتماع مع قطاع الحماية', 1, 'مكتمل', '2025-05-19', 4, 'دعوة من قطاع الحماية لحضور اجتماع لمناقشة العدالة الانتقالية مع بقية الشركاء');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (48, 'مقابلات عمل لمشروع تكامل', 1, 'مكتمل', '2025-05-19', 4, 'تشكيل فريق الدعم النفسي لمشروع تكامل');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (49, 'نشر بوست بخصوص تدريبات وتد', 1, 'جاري العمل', '2025-05-19', 4, 'التنسيق مع حازم لنشر بوست يخص التدريبات القائمة');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (50, 'متابعة نشر اعلانات مشروع تكامل', 1, 'مكتمل', '2025-05-12', 4, 'متابعة مع قسم الموارد');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (51, 'التخطيط للبدء بمقابلات تكامل', 1, 'مكتمل', '2025-05-12', 4, 'فلترة الاسماء والوصول الى short list');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (52, 'الاجتماع مع فريق دار في حلب', 1, 'مكتمل', '2025-05-12', 4, 'بدأ الدوام بشكل فيزيائي في حلب');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (53, 'متابعة التدريبات التقنية لمشروع وتد', 1, 'مكتمل', '2025-05-12', 4, 'تدريب فن المناظرة');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (54, 'متابعة التدريبات المعرفية لمشروع وتد', 1, 'مكتمل', '2025-05-12', 4, 'تدريب العدالة الانتقالية مع سويس بيس');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (40, 'اجتماع كلاستر الحماية (حلب)', 1, 'مكتمل', '2025-05-26', 4, 'تم ارسال الدعوة لتاريخ 20\5\2025 لمدة اربع ساعات بخصوص تحليل الحماية');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (39, 'العمل على ملف شهادات حضور التدريبات', 1, 'مكتمل', '2025-05-26', 4, 'تنسيق الاسماء والتدريبات ومشاركتها مع قسم الميل');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (45, 'متابعة توثيقات الدرايف', 1, 'مكتمل', '2025-05-19', 4, 'توثيقات الدرايف مع محمد وخناف');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (36, 'متابعة التدريبات المعرفية لمشروع وتد', 1, 'مكتمل', '2025-05-26', 4, 'تدريب تحليل النزاع مع سويس بيس');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (37, 'متابعة توثيقات الدرايف', 1, 'مكتمل', '2025-05-26', 4, 'درايف وتد (المتابعة مع خناف ومحمد لتوثيقات التدريبات)');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (41, 'المتابعة مع مدير قطاع الحماية', 1, 'مكتمل', '2025-05-26', 4, 'متابعة الملفات المطلوبة للحصول على لا مانع');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (26, 'توثيق مشروع وتد للتقرير الربعي', 5, 'جاري العمل', '2025-07-04', 1, 'مراجعة وتوثيق مستندات مشروع وتد استعداداً للتقرير الربعي بالتنسسيق مع قسم البرامج');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (35, 'متابعة التدريبات التقنية لمشروع وتد', 1, 'مكتمل', '2025-05-26', 4, 'تدريب المناصرة مع المدرب نذير العبدو');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (56, 'BSF meeting', 1, 'جاري العمل', '2025-06-02', 6, 'أجتماع مع ممثلة من منظمة مكتبات بلا حدود خلال زيارتها في دمشق لمناقشة امكانية التعاون والتنسيق');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (58, 'معرض لافتات كفرنبل', 1, 'جاري العمل', '2025-06-02', 6, 'العمل على تحضيرات المعرض والافتتاح في 25/5/2025 يستمر المعرض حتى 3/6/2025');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (57, 'متابعة قرار الترخيص في المديرية والوزارة', 1, 'جاري العمل', '2025-06-02', 6, 'مراجعة مكتب المنظمات في مديرية الشؤون الاجتماعية والعمل في دمشق لمتابعة كتاب طلب تعديل اسم المنظمة في قرار الاشهار');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (59, 'مشروع المبادرات', 1, 'جاري العمل', '2025-06-02', 6, 'العمل على وضع الخطة الزمنية مع المبادرات المؤهلة واستكمال الورقيات الخاصة بالمشروع
العمل على العرض التقديمي للمشروع
العمل على تفكيك الأنشطة ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (60, 'مشروع نساء المتوسط', 1, 'جاري العمل', '2025-06-02', 6, 'متابعة التعديلات على المقترح
العمل على الخطة الزمنية مع الفريق المنفذ
العمل على العرض التقديمي للمشروع');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (61, 'زيارة ميدانية الى دير العصافير', 1, 'جاري العمل', '2025-06-02', 6, 'زيارة تعارف الى مشروع زراعي في دير العصافير لمناقشة امكانية التعاون والتشبيك');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (71, 'التنسيق مع حسن من اجل النظام المالي الجديد', 2, 'جاري العمل', '2025-05-25', 12, 'البدء بالعمل على البرامج المالي الجديد و كيفية تطبيقها');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (72, 'التنسيق مع خناف في مشروع وتد', 2, 'جاري العمل', '2025-05-25', 12, 'التنسيق مع خناف في تدريبات وتد و تجهيز مستلزمات التدريبات');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (73, 'التنسيق مع خناف فيما يخص مشروع نوى ', 2, 'جاري العمل', '2025-05-25', 12, 'التنسيق مع خناف في مشروع نوى و اجراء زيارة ميدانية الى مزرعة عامودا');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (74, 'انهاء عقود شهر 5 لكل المشاريع', 2, 'قيد التنفيذ', '2025-05-28', 9, 'انهاء تقسيمات البوزيشنات والعقود كل مايخص مشروع نوى ووتد وتكامل لكل تعاقدات شهر 5 قبل 28 الشهر ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (75, 'مقابلات عمل لمشروع تكامل', 2, 'قيد التنفيذ', '2025-05-30', 9, 'مقابلات عمل لمتعاقدين شهر 6 للمشروع');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (76, 'مقابلات عمل لمشروع وتد', 2, 'قيد التنفيذ', '2025-05-30', 9, 'مقابلات عمل لمتعاقدين شهر 6 للمشروع');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (77, 'العمل على تعديلات تقرير مشروع الجيز الاخير', 2, 'قيد التنفيذ', '2025-05-26', 9, 'تعديلات التقرير المرسلة من بدائل');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (78, 'العمل على تقرير وتد', 2, 'قيد التنفيذ', '2025-05-28', 9, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (80, 'العمل على تقرير نوى', 2, 'قيد التنفيذ', '2025-05-28', 9, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (81, 'تحديث ملف List of Experiences ', 4, 'قيد التنفيذ', '2025-05-25', 18, 'تحديث الملف الذي أنشئه وعمل عليه فيلكس وإضافة المبادرات ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (89, 'التنسيق مع مالك ومسعود ومحمد الهادي من اجل جرد الصناديق والتاكد من اعتماد النماذج الجديدة ', 2, 'قيد التنفيذ', '2025-05-29', 10, 'التنسيق مع مالك ومسعود ومحمد الهادي من اجل جرد الصناديق والتاكد من اعتماد النماذج الجديدة ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (88, 'التنسيق من أجل اجتماع الكلاسترات ', 4, 'جاري العمل', '2025-05-29', 18, 'الدعوة لاجتماع داخلي للتنسيق من خلاله و تحديد Focal point لكل كلاستر ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (86, 'تجهيز التقارير المالية ', 2, 'قيد التنفيذ', '2025-05-27', 10, 'تجهيز التقارير المالية لمشروع وتد ونوى بالتعاون مع قسم العمليات ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (82, 'تقديم concept ل ISDB ', 4, 'ملغى', '2025-05-27', 18, 'تقديم ملخص عن المحاور المتضمنة 
تم تقديمه من قبل ريعان ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (87, 'كتابة ال Concept ل Rich ', 4, 'مكتمل', '2025-05-27', 18, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (91, 'موشن غرافيك مشروع نوى', 3, 'قيد التنفيذ', '2025-06-02', 15, 'البحث عن اعلامي لتنفيذ فيديو موشن غرافيك لمشروع نوى');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (70, 'PDM مشروع نوى', 5, 'قيد التنفيذ', '2025-06-05', 1, 'بدء العمل على جمع البيانات لمشروع Nawa ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (92, 'تغطية برومو مشروع نوى', 3, 'قيد التنفيذ', '2025-06-01', 15, 'تصوير فيديو للمشورع بحزيمة وعامودا لتحديد مخرج نهائي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (93, 'التعديل على بروفايل المنظمة', 3, 'قيد التنفيذ', '2025-06-03', 15, 'تجميع المعلومات الكاملة للخروج ببروفايل مناسب لمنظمة دار');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (90, 'تكملة تصاميم مركز حلب', 3, 'قيد التنفيذ', '2025-06-05', 15, 'متابعة طباعة الملفات والبوسترات والفلكسات
');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (94, 'تحديث السياسات', 5, 'قيد التنفيذ', '2025-06-01', 1, 'تحديث على سياسات قسم المراقبة والتقييم بشكل كامل وإرفاق النماذج لكل سياسة');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (95, 'نظام الشكاوى', 5, 'قيد التنفيذ', '2025-06-01', 1, 'العمل على تفعيل قسم الشكاوى والتأكد من أن جميع المشاريع تلتزم بمعايير الشكاوى ضمن السياسة الحالية');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (98, 'عقد اجتماع بين الاستشارية والمستفيدات للتحضير لاستبيان الوصمة', 1, 'قيد التنفيذ', '2025-06-02', 3, 'سيتم اشراك المستفيدات في خطة تصميم الاستبيان وتنفيذه من خلال اجتماعات اونلاين مع الاستشارية ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (96, 'متابعة نشاط التدريبات في مشروع وتد \درايف مع التقييم -انهاء تدريبات مع المتدربات\توثيق مع المنسقين ورغد', 1, 'قيد التنفيذ', '2025-06-05', 3, 'سيتم انهاء التدريبات وتشيك التوثيقات وورفع التوثيقات لانجاز التقرير الاول لمشروع وتد');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (97, 'اجتماع مع ربا غانم استشاري تصميم الاستبيان لمباشرة العمل على خطة النشاط الثاني في مشروع وتد', 1, 'قيد التنفيذ', '2025-06-03', 3, 'سيتم مناقشة الخطة العمل وتصميم استبيان الوصمة لمشروع وتد مع الاستشارية من حيث اجتماعات المتابعة والموضوعات والهدف من تطبيق استبيان خط الاساس ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (99, 'اجتماع متابعة انطلاق فريق مشروع تكامل', 1, 'قيد التنفيذ', '2025-06-01', 3, 'سيتم خلال الاجتماع تحديد خطوات التنفيذ وادوار الفريق الاداري والميداني مع المنسقة الادارية ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (100, 'متابعة استكمال درايف نوى ', 1, 'قيد التنفيذ', '2025-06-05', 3, 'تم تزويد منسقة مشروع نوى بالفورمات المطلوبة والتوثيقات الناقصة في الدرايف وسيكون توقيت تسليم المهمة قبل العيد');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (101, 'متابعة اوراق اثر الاساسية (برزنتيشن اطلاق\خطة زمنية\تفكيك الانشطة)', 1, 'قيد التنفيذ', '2025-06-03', 3, 'سيتم متابعة منسقة مشاريع اثر وفق الموعد المحدد في اجتماع متابعة انجاز المشروعين في الاسبوع السابق');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (102, 'إنشاء ملف يتضمن الداعمين المحتملين و الحاليين و إعلانات المنح مترافقة مع الديد لاين و ملخص عن الأفكار ', 4, 'جاري العمل', '2025-06-05', 18, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (103, 'إنشاء ملف يتضمن الداعمين المحتملين و الحاليين و إعلانات المنح مترافقة مع الديد لاين و ملخص عن الأفكار ', 4, 'جاري العمل', '2025-06-05', 18, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (104, 'إنشاء ملف يتضمن الداعمين المحتملين و الحاليين و إعلانات المنح مترافقة مع الديد لاين و ملخص عن الأفكار ', 4, 'جاري العمل', '2025-06-05', 18, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (105, 'متابعة التدريبات المعرفية لمشروع وتد', 1, 'قيد التنفيذ', '2025-06-02', 4, 'التدريب المعرفي الاخير ع سويس بيس');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (106, 'متابعة درايف توثيقات وتد', 1, 'قيد التنفيذ', '2025-06-01', 4, 'توثيق ملفات التدريبات');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (107, 'متابعة توثيقات درايف نوى', 1, 'قيد التنفيذ', '2025-06-04', 4, 'المتابعةة مع خناف لاستكمال الملفات المطلوبة');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (108, 'استكمال بعض الملفات المطلوبة لتقرير GIZ', 1, 'قيد التنفيذ', '2025-06-01', 4, 'التنسيق مع العمليات لاستكمال بعض الملفات');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (109, 'التواصل مع الجهات الفاعلة لمعرفة الخدمات المقدمة في حلب', 1, 'قيد التنفيذ', '2025-06-02', 4, 'التنسيق لوضع خارطة الخدمات لمشروع تكامل');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (110, 'وضع خطة لاستقطاب المستفيدات لمشروع تكامل', 1, 'قيد التنفيذ', '2025-06-01', 4, 'التعاون مع فريق الدعم النفسي في مشروع تكامل');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (111, 'اجتماعات فردية مع فريق الدعم النفسي لمشروع تكامل ', 1, 'قيد التنفيذ', '2025-06-01', 4, 'وضع الخطة التنفيذية للمباشرة بالعمل');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (112, 'التخطيط لورقة إحالة خاصة بمشروع تكامل و بروشور تعريفي عن المشروع', 1, 'قيد التنفيذ', '2025-06-01', 4, 'التعاوف مع الفريق لانجاز الاوراق الضرورية للمشروع');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (113, 'استكمال إعادة تأهيل مركز حلب ', 2, 'قيد التنفيذ', '2025-06-01', 8, 'الامور العالقة الخاصة بالمكاتب والكراسي والكاميرات والهوية البصرية ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (114, 'استكمال إعادة تأهيل مركز حلب ', 2, 'قيد التنفيذ', '2025-06-01', 8, 'الامور العالقة الخاصة بالمكاتب والكراسي والكاميرات والهوية البصرية ');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (115, 'استكمال تقرير وتد الأولي ', 2, 'جاري العمل', '2025-06-01', 8, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (116, 'إنهاء استكملات تقرير نوى الأول للمشروع الزراعي ', 2, 'جاري العمل', '2025-06-01', 8, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (117, 'ميزانية منحة نساء المتوسط ', 2, 'جاري العمل', '2025-06-01', 8, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (118, 'استكمال التدريبات للقسم المالي واللوجستي ', 2, 'قيد التنفيذ', '2025-06-01', 8, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (119, 'مناقشة والعمل على منح جديدة بالتنسيق مع قسم الشراكات ', 2, 'قيد التنفيذ', '2025-06-01', 8, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (120, 'متابعة الفريق المالي في الرقة و القامشلي وعفرين ', 2, 'قيد التنفيذ', '2025-05-31', 10, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (121, 'بدء تدريب المتطوعة بقسم المراقبة', 5, 'قيد التنفيذ', '2025-06-01', 1, 'البدء بتدريب المتطوعة الجديدة اقسم المراقبة والتقييم واعطاءها بعض المهام وشرح آلية قسم المراقبة والتقييم');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (122, 'المتابعة الروتينية للمشاريع', 5, 'قيد التنفيذ', '2025-06-05', 1, 'المتابعة الروتينية بجميع المشاريع والرد على التعليقات بما يخص المنح التي تم التقديمي عليها بما يخص قسم المراقبة والتقييم');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (123, 'الانتهاء من التوثيقات المالية في مكتب القامشلي', 2, 'قيد التنفيذ', '2025-05-31', 12, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (124, 'البدء بتطبيق النظام المالي الجديد', 2, 'قيد التنفيذ', '2025-05-31', 12, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (125, 'التجهيز لنشاط وتد و حجز القاعة', 2, 'قيد التنفيذ', '2025-06-11', 12, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (126, 'ترميم مقابلات عمل لمشروع تكامل', 2, 'قيد التنفيذ', '2025-07-06', 9, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (127, 'تسليم اجندة تدريب الموارد لسمر', 2, 'قيد التنفيذ', '2025-06-01', 9, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (128, 'تسليم اجندة تدريب الموارد لسمر', 2, 'قيد التنفيذ', '2025-06-01', 9, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (129, 'تسليم تقرير وتد ونوى بما يخص الموارد', 2, 'قيد التنفيذ', '2025-06-04', 9, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (130, 'تحضير محتوى عرض دار بمؤتمر قمة المناخ', 6, 'قيد التنفيذ', '2025-06-01', 2, 'تحضير ٥-٦ سلايد عن تأثير تغير المناخ على التماسك المجتمعي وتجربة دار بالمشروع الزراعي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (131, 'تحضير محتوى عرض دار بمؤتمر قمة المناخ', 6, 'قيد التنفيذ', '2025-06-01', 2, 'تحضير ٥-٦ سلايد عن تأثير تغير المناخ على التماسك المجتمعي وتجربة دار بالمشروع الزراعي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (132, 'تحضير محتوى عرض دار بمؤتمر قمة المناخ', 6, 'قيد التنفيذ', '2025-06-01', 2, 'تحضير ٥-٦ سلايد عن تأثير تغير المناخ على التماسك المجتمعي وتجربة دار بالمشروع الزراعي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (133, 'تحضير محتوى عرض دار بمؤتمر قمة المناخ', 6, 'قيد التنفيذ', '2025-06-01', 2, 'تحضير ٥-٦ سلايد عن تأثير تغير المناخ على التماسك المجتمعي وتجربة دار بالمشروع الزراعي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (134, 'تحضير محتوى عرض دار بمؤتمر قمة المناخ', 6, 'قيد التنفيذ', '2025-06-01', 2, 'تحضير ٥-٦ سلايد عن تأثير تغير المناخ على التماسك المجتمعي وتجربة دار بالمشروع الزراعي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (135, 'تحضير محتوى عرض دار بمؤتمر قمة المناخ', 6, 'قيد التنفيذ', '2025-06-01', 2, 'تحضير ٥-٦ سلايد عن تأثير تغير المناخ على التماسك المجتمعي وتجربة دار بالمشروع الزراعي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (136, 'تحضير محتوى عرض دار بمؤتمر قمة المناخ', 6, 'قيد التنفيذ', '2025-06-01', 2, 'تحضير ٥-٦ سلايد عن تأثير تغير المناخ على التماسك المجتمعي وتجربة دار بالمشروع الزراعي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (137, 'تحضير محتوى عرض دار بمؤتمر قمة المناخ', 6, 'قيد التنفيذ', '2025-06-01', 2, 'تحضير ٥-٦ سلايد عن تأثير تغير المناخ على التماسك المجتمعي وتجربة دار بالمشروع الزراعي');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (138, 'حضور مؤتمر قمة المناخ في دبي ٣-٤ حزيران ', 6, 'قيد التنفيذ', '2025-06-03', 2, 'Climate Summit 2025
3rd & 4th June, 2025 Dubai
12th to 20th of June, Nice
https://gpiuk.com/climatesummit');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (139, 'حضور مؤتمر قمة المناخ في دبي ٣-٤ حزيران ', 6, 'قيد التنفيذ', '2025-06-03', 2, 'Climate Summit 2025
3rd & 4th June, 2025 Dubai
12th to 20th of June, Nice
https://gpiuk.com/climatesummit');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (140, 'حضور اجتماع مناقشة مقترح المنحة البريطانية UKHIH', 6, 'قيد التنفيذ', '2025-06-01', 2, 'https://www.ukhih.org/news/call-for-proposals-now-open-responsive-fund-syria/?fbclid=IwY2xjawKnDldleHRuA2FlbQIxMQABHjKtNfHnuDt2SziYTa5Kybg7c8yoUnGLNL1B1tVHwonCxYtuhxh-IpGrH8Rv_aem_m0ivZG40Dfp6afFaqyLjFw');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (141, 'حضور اجتماع مناقشة مقترح المنحة البريطانية UKHIH', 6, 'قيد التنفيذ', '2025-06-01', 2, 'https://www.ukhih.org/news/call-for-proposals-now-open-responsive-fund-syria/?fbclid=IwY2xjawKnDldleHRuA2FlbQIxMQABHjKtNfHnuDt2SziYTa5Kybg7c8yoUnGLNL1B1tVHwonCxYtuhxh-IpGrH8Rv_aem_m0ivZG40Dfp6afFaqyLjFw');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (142, 'حضور اجتماع مناقشة مقترح المنحة البريطانية UKHIH', 6, 'قيد التنفيذ', '2025-06-01', 2, 'https://www.ukhih.org/news/call-for-proposals-now-open-responsive-fund-syria/?fbclid=IwY2xjawKnDldleHRuA2FlbQIxMQABHjKtNfHnuDt2SziYTa5Kybg7c8yoUnGLNL1B1tVHwonCxYtuhxh-IpGrH8Rv_aem_m0ivZG40Dfp6afFaqyLjFw');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (143, 'مناقشة التقديم لمنحة IsDB الديد لاين ١٢ حزيران', 6, 'قيد التنفيذ', '2025-06-01', 2, 'https://www.isdb.org/events/joint-call-for-proposals-skills-training-and-education-program-step');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (144, 'مراجعة درايف مشروع نوى ', 6, 'قيد التنفيذ', '2025-06-05', 2, '');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (145, 'تجهيز خطة شهر حزيران للمنظمة', 6, 'قيد التنفيذ', '2025-06-06', 2, 'تجهيز خطة عامة لاقسام دار خلال شهر حزيران موارد، عمليات، برامج، شراكات، ميديا، مراقبة');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (146, 'تجهيز خطة شهر حزيران للمنظمة', 6, 'قيد التنفيذ', '2025-06-06', 2, 'تجهيز خطة عامة لاقسام دار خلال شهر حزيران موارد، عمليات، برامج، شراكات، ميديا، مراقبة');
INSERT INTO public.task (id, task_name, department_id, status, date, employee_id, description) VALUES (147, 'تجهيز خطة شهر حزيران للمنظمة', 6, 'قيد التنفيذ', '2025-06-06', 2, 'تجهيز خطة عامة لاقسام دار خلال شهر حزيران موارد، عمليات، برامج، شراكات، ميديا، مراقبة');


--
-- TOC entry 3423 (class 0 OID 41001)
-- Dependencies: 227
-- Data for Name: task_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (3, 74, 9, '2025-05-24 09:37:46.715944');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (4, 77, 9, '2025-05-24 09:41:48.609312');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (8, 91, 15, '2025-05-29 12:20:55.57797');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (9, 92, 15, '2025-05-29 12:27:39.298808');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (14, 98, 4, '2025-05-30 21:13:47.077536');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (15, 98, 5, '2025-05-30 21:13:47.077538');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (16, 98, 7, '2025-05-30 21:13:47.077539');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (17, 99, 4, '2025-05-30 21:22:26.869963');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (18, 100, 4, '2025-05-30 21:26:07.558653');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (19, 100, 5, '2025-05-30 21:26:07.558657');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (20, 101, 4, '2025-05-30 21:32:47.035996');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (21, 101, 6, '2025-05-30 21:32:47.036');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (22, 113, 11, '2025-05-31 08:36:53.349696');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (23, 114, 11, '2025-05-31 08:37:05.992064');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (24, 115, 10, '2025-05-31 08:39:25.087418');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (25, 115, 11, '2025-05-31 08:39:25.087421');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (26, 115, 9, '2025-05-31 08:39:25.087421');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (27, 116, 10, '2025-05-31 08:40:58.061887');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (28, 116, 11, '2025-05-31 08:40:58.06189');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (29, 116, 9, '2025-05-31 08:40:58.061891');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (30, 118, 10, '2025-05-31 08:43:15.453923');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (31, 118, 11, '2025-05-31 08:43:15.453926');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (32, 130, 15, '2025-05-31 10:27:06.887867');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (33, 131, 15, '2025-05-31 10:27:29.516634');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (34, 132, 15, '2025-05-31 10:27:30.436381');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (35, 133, 15, '2025-05-31 10:27:31.357559');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (36, 134, 15, '2025-05-31 10:27:32.272232');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (37, 135, 15, '2025-05-31 10:27:33.186988');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (38, 136, 15, '2025-05-31 10:28:08.957878');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (39, 137, 15, '2025-05-31 10:28:09.876948');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (40, 143, 16, '2025-05-31 10:40:29.945609');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (41, 143, 17, '2025-05-31 10:40:29.945613');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (42, 144, 8, '2025-05-31 10:42:57.973857');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (43, 144, 15, '2025-05-31 10:42:57.973861');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (44, 144, 9, '2025-05-31 10:42:57.973862');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (45, 144, 1, '2025-05-31 10:42:57.973863');
INSERT INTO public.task_tag (id, task_id, employee_id, created_at) VALUES (46, 144, 3, '2025-05-31 10:42:57.973863');


--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 217
-- Name: archived_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.archived_task_id_seq', 18, true);


--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 219
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 1, false);


--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 221
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_id_seq', 1, false);


--
-- TOC entry 3439 (class 0 OID 0)
-- Dependencies: 224
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_id_seq', 229, true);


--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 223
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_id_seq', 147, true);


--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 226
-- Name: task_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_tag_id_seq', 46, true);


--
-- TOC entry 3241 (class 2606 OID 24605)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 3243 (class 2606 OID 24607)
-- Name: archived_task archived_task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archived_task
    ADD CONSTRAINT archived_task_pkey PRIMARY KEY (id);


--
-- TOC entry 3245 (class 2606 OID 24609)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- TOC entry 3247 (class 2606 OID 32775)
-- Name: employee employee_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_email_key UNIQUE (email);


--
-- TOC entry 3249 (class 2606 OID 24611)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- TOC entry 3251 (class 2606 OID 24613)
-- Name: employee employee_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_username_key UNIQUE (username);


--
-- TOC entry 3255 (class 2606 OID 40978)
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- TOC entry 3253 (class 2606 OID 24615)
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- TOC entry 3257 (class 2606 OID 41006)
-- Name: task_tag task_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tag
    ADD CONSTRAINT task_tag_pkey PRIMARY KEY (id);


--
-- TOC entry 3258 (class 2606 OID 24616)
-- Name: archived_task archived_task_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archived_task
    ADD CONSTRAINT archived_task_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- TOC entry 3259 (class 2606 OID 24621)
-- Name: archived_task archived_task_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archived_task
    ADD CONSTRAINT archived_task_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- TOC entry 3260 (class 2606 OID 24626)
-- Name: employee employee_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- TOC entry 3261 (class 2606 OID 32769)
-- Name: employee employee_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employee(id);


--
-- TOC entry 3264 (class 2606 OID 40995)
-- Name: notification notification_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- TOC entry 3265 (class 2606 OID 40985)
-- Name: notification notification_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.task(id);


--
-- TOC entry 3262 (class 2606 OID 24631)
-- Name: task task_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- TOC entry 3263 (class 2606 OID 24636)
-- Name: task task_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- TOC entry 3266 (class 2606 OID 41012)
-- Name: task_tag task_tag_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tag
    ADD CONSTRAINT task_tag_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- TOC entry 3267 (class 2606 OID 41007)
-- Name: task_tag task_tag_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tag
    ADD CONSTRAINT task_tag_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.task(id);


-- Completed on 2025-06-10 22:53:27

--
-- PostgreSQL database dump complete
--

-- Completed on 2025-06-10 22:53:27

--
-- PostgreSQL database cluster dump complete
--

