--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE blogs;




--
-- Drop roles
--

DROP ROLE root;


--
-- Roles
--

CREATE ROLE root;
ALTER ROLE root WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md5e94551060e485c3bfb473164f5f089a3';






--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1 (Debian 12.1-1.pgdg100+1)
-- Dumped by pg_dump version 12.1 (Debian 12.1-1.pgdg100+1)

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

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: root
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO root;

\connect template1

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
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: root
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: root
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

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
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: root
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "blogs" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1 (Debian 12.1-1.pgdg100+1)
-- Dumped by pg_dump version 12.1 (Debian 12.1-1.pgdg100+1)

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
-- Name: blogs; Type: DATABASE; Schema: -; Owner: root
--

CREATE DATABASE blogs WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE blogs OWNER TO root;

\connect blogs

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admins OWNER TO root;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admins_id_seq OWNER TO root;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    title character varying NOT NULL,
    description text,
    status boolean NOT NULL,
    banner_image character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    slug character varying(30)
);


ALTER TABLE public.posts OWNER TO root;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO root;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    phone bigint NOT NULL,
    message text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO root;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO root;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.admins (id, name, email, password, created_at) FROM stdin;
1	Admin	admin@indiaint.com	6b4d2ac580a798844f34de357df5ceacda65776be17f9401e36a1ce1507f0d5f4ce1ee2a86b3f7831c7b318beb3b54e7e6886f162c13848238a2fe4049072c64b6c76f963b62bd040a57dc7137e66a8561dc02d76f9130803302691b96f1439a	2019-12-20 06:33:30.126412
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.posts (id, title, description, status, banner_image, created_at, slug) FROM stdin;
2	I believe every human has a finite number of heartbeats. I do not intend to waste any of mine.	We predict too much for the next year and yet far too little for the next ten.	t		2019-12-18 12:29:39.787082	i-believe-every-human
3	Failure is not an option	Many say exploration is part of our destiny, but it’s actually our duty to future generations.	t		2019-12-18 12:30:13.562564	failure-is-not-an-option
4	The Final Frontier	There can be no thought of finishing for ‘aiming for the stars.’ Both figuratively and literally, it is a task to occupy the generations. And no matter how much progress one makes, there is always the thrill of just beginning.	t		2019-12-18 12:30:53.342458	the-final-frontier
5	From its medieval origins to the digital era, learn everything there is to know about the ubiquitous lorem ipsum passage.	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n<img style="-webkit-user-select: none;margin: auto;" src="https://i.picsum.photos/id/547/200/300.jpg">	t	Webp.net-compress-image-1568x882.jpg	2019-12-25 05:19:03.384113	from-its-medieval-origins-to-t
6	Lorem ipsum began as scrambled, nonsensical Latin derived from Cicero's 1st-century BC text De Finibus Bonorum et Malorum.	At consectetur lorem donec massa. Suspendisse ultrices gravida dictum fusce. Laoreet id donec ultrices tincidunt arcu non sodales. Fringilla est ullamcorper eget nulla facilisi. Nibh mauris cursus mattis molestie a iaculis. Ultrices gravida dictum fusce ut placerat orci. Adipiscing enim eu turpis egestas pretium aenean. Tincidunt ornare massa eget egestas purus viverra accumsan in. Ultrices tincidunt arcu non sodales neque sodales. Pretium lectus quam id leo in vitae. Sit amet consectetur adipiscing elit. Eu augue ut lectus arcu bibendum. Semper feugiat nibh sed pulvinar proin gravida. Cras sed felis eget velit aliquet sagittis id consectetur. Tristique senectus et netus et malesuada.\r\n<img style="-webkit-user-select: none;margin: auto;" src="https://i.picsum.photos/id/786/200/300.jpg">	t	why-768x532.png	2019-12-25 05:19:03.384113	lorem-ipsum-began-as-scrambled
7	Id diam vel quam elementum pulvinar etiam non. 	Id diam vel quam elementum pulvinar etiam non. Mus mauris vitae ultricies leo integer malesuada nunc vel. Condimentum vitae sapien pellentesque habitant. Mattis vulputate enim nulla aliquet porttitor. Laoreet sit amet cursus sit amet dictum sit. Quam quisque id diam vel quam elementum pulvinar etiam. Pretium viverra suspendisse potenti nullam ac. Elementum sagittis vitae et leo duis ut diam. Aliquam malesuada bibendum arcu vitae elementum curabitur vitae nunc. Consectetur adipiscing elit ut aliquam. Egestas pretium aenean pharetra magna ac placerat vestibulum.\r\n<img style="-webkit-user-select: none;margin: auto;" src="https://i.picsum.photos/id/215/200/300.jpg">	t	norshippingtwitterECMWF-845x1024.png	2019-12-25 05:19:03.384113	id-diam-vel-quam-elementum-pul
8	Lobortis elementum nibh tellus molestie nunc.	Lobortis elementum nibh tellus molestie nunc. Ultricies lacus sed turpis tincidunt id. Ultricies tristique nulla aliquet enim tortor at auctor urna. Senectus et netus et malesuada fames ac. Consectetur adipiscing elit ut aliquam. Id aliquet risus feugiat in. Lorem donec massa sapien faucibus et molestie ac feugiat sed. Mi ipsum faucibus vitae aliquet nec ullamcorper sit amet risus. Morbi blandit cursus risus at ultrices. In nulla posuere sollicitudin aliquam ultrices sagittis orci a scelerisque.\r\n<img style="-webkit-user-select: none;margin: auto;" src="https://i.picsum.photos/id/383/200/300.jpg">	t	cyprus-2609495_1920-1024x682.jpg	2019-12-25 05:19:03.384113	lobortis-elementum-nibh-tellus
9	Commodo elit at imperdiet dui accumsan sit. Nulla aliquet enim tortor at.	Commodo elit at imperdiet dui accumsan sit. Nulla aliquet enim tortor at. Tincidunt id aliquet risus feugiat in. Aliquam id diam maecenas ultricies mi eget mauris pharetra. Ultricies tristique nulla aliquet enim tortor at auctor urna nunc. Sed vulputate mi sit amet mauris commodo quis imperdiet massa. Nulla pellentesque dignissim enim sit amet venenatis urna cursus. Semper auctor neque vitae tempus quam pellentesque nec nam aliquam. Ac auctor augue mauris augue neque gravida in fermentum et. Sapien nec sagittis aliquam malesuada bibendum arcu vitae. Placerat duis ultricies lacus sed turpis tincidunt id aliquet. Vel quam elementum pulvinar etiam non quam lacus suspendisse. Etiam sit amet nisl purus in mollis nunc. Morbi tristique senectus et netus et malesuada fames ac. Lectus vestibulum mattis ullamcorper velit sed. Volutpat diam ut venenatis tellus in metus vulputate eu scelerisque. Fermentum odio eu feugiat pretium. Sollicitudin nibh sit amet commodo nulla facilisi nullam vehicula ipsum.\r\n<img style="-webkit-user-select: none;margin: auto;" src="https://i.picsum.photos/id/80/200/300.jpg">	t	new-years-day-2019-5179180558843904.4-law.gif	2019-12-25 05:19:03.384113	commodo-elit-at-imperdiet-dui
10	Leo vel fringilla est ullamcorper eget nulla facilisi etiam.	Leo vel fringilla est ullamcorper eget nulla facilisi etiam. Cras pulvinar mattis nunc sed blandit. Aenean sed adipiscing diam donec. Ut placerat orci nulla pellentesque dignissim enim sit. Duis at consectetur lorem donec massa. Mauris vitae ultricies leo integer malesuada nunc vel risus commodo. Turpis egestas sed tempus urna et pharetra pharetra massa massa. Tortor dignissim convallis aenean et tortor at. Turpis massa sed elementum tempus egestas sed sed. Porttitor massa id neque aliquam vestibulum morbi blandit cursus risus. Volutpat est velit egestas dui id ornare arcu odio ut. Nulla facilisi nullam vehicula ipsum a arcu. Sit amet mattis vulputate enim nulla aliquet. In fermentum et sollicitudin ac orci. Senectus et netus et malesuada fames ac.\r\n<img style="-webkit-user-select: none;margin: auto;" src="https://i.picsum.photos/id/880/200/300.jpg">	t	0G7A8196.jpg	2019-12-25 05:19:03.384113	leo-vel-fringilla-est-ullamcor
1	Man must explore, and this is exploration at its greatest	Never in all their history have men been able truly to conceive of the world as one: a single sphere, a globe, having the qualities of a globe, a round earth in which all the directions eventually meet, in which there is no center because every point, or none, is center — an equal earth which all men occupy as equals. The airman's earth, if free men make it, will be truly round: a globe in practice, not in theory.	t	post-bg.jpg	2019-12-18 12:28:16.458898	man-must-explore
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.users (id, name, email, phone, message, created_at) FROM stdin;
1	Ashish	ashish@gmail.com	9898985698	this is test created by ashish	2019-12-18 12:36:34.477415
2	Vikash	durga@gmail.com	9569895698	this is test created by durga	2019-12-18 12:37:02.741339
3	Anand	aman@gmail.com	9569895652	this is test created by aman	2019-12-18 12:37:20.494495
\.


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.posts_id_seq', 10, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1 (Debian 12.1-1.pgdg100+1)
-- Dumped by pg_dump version 12.1 (Debian 12.1-1.pgdg100+1)

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

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: root
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO root;

\connect postgres

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: root
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

