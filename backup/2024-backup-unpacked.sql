--
-- PostgreSQL database dump
--

-- Dumped from database version 14.11 (Ubuntu 14.11-1.pgdg20.04+1)
-- Dumped by pg_dump version 14.2

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
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "heroku_ext";


--
-- Name: EXTENSION "pg_stat_statements"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "pg_stat_statements" IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."ar_internal_metadata" (
    "key" character varying NOT NULL,
    "value" character varying,
    "created_at" timestamp without time zone NOT NULL,
    "updated_at" timestamp without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO oefunbdfyixopx;

--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."delayed_jobs" (
    "id" integer NOT NULL,
    "priority" integer DEFAULT 0 NOT NULL,
    "attempts" integer DEFAULT 0 NOT NULL,
    "handler" "text" NOT NULL,
    "last_error" "text",
    "run_at" timestamp without time zone,
    "locked_at" timestamp without time zone,
    "failed_at" timestamp without time zone,
    "locked_by" character varying,
    "queue" character varying,
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone
);


ALTER TABLE public.delayed_jobs OWNER TO oefunbdfyixopx;

--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."delayed_jobs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delayed_jobs_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."delayed_jobs_id_seq" OWNED BY "public"."delayed_jobs"."id";


--
-- Name: markers; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."markers" (
    "id" integer NOT NULL,
    "image" character varying,
    "tooltip_content" character varying,
    "tooltip_position" character varying DEFAULT 'right bottom'::character varying,
    "content" "text",
    "x" integer,
    "y" integer,
    "width" integer,
    "height" integer,
    "sphere_id" integer,
    "created_at" timestamp without time zone NOT NULL,
    "updated_at" timestamp without time zone NOT NULL,
    "guid" character varying,
    "embedded_photo" character varying,
    "embedded_photo_processing" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.markers OWNER TO oefunbdfyixopx;

--
-- Name: markers_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."markers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.markers_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: markers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."markers_id_seq" OWNED BY "public"."markers"."id";


--
-- Name: memories; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."memories" (
    "id" integer NOT NULL,
    "name" character varying,
    "user_id" integer,
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone,
    "description" "text",
    "private" boolean DEFAULT false
);


ALTER TABLE public.memories OWNER TO oefunbdfyixopx;

--
-- Name: memories_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."memories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.memories_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: memories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."memories_id_seq" OWNED BY "public"."memories"."id";


--
-- Name: microposts; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."microposts" (
    "id" integer NOT NULL,
    "content" "text",
    "user_id" integer,
    "created_at" timestamp without time zone NOT NULL,
    "updated_at" timestamp without time zone NOT NULL,
    "picture" character varying
);


ALTER TABLE public.microposts OWNER TO oefunbdfyixopx;

--
-- Name: microposts_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."microposts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.microposts_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: microposts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."microposts_id_seq" OWNED BY "public"."microposts"."id";


--
-- Name: portals; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."portals" (
    "id" integer NOT NULL,
    "polygon_px" "text",
    "fill" character varying DEFAULT 'points'::character varying,
    "stroke" character varying DEFAULT '#ff0032'::character varying,
    "stroke_transparency" integer DEFAULT 80,
    "stroke_width" integer DEFAULT 2,
    "tooltip_content" character varying,
    "tooltip_position" character varying DEFAULT 'right bottom'::character varying,
    "from_sphere_id" integer,
    "to_sphere_id" integer,
    "created_at" timestamp without time zone NOT NULL,
    "updated_at" timestamp without time zone NOT NULL,
    "fov_lat" numeric(18,17) DEFAULT 0,
    "fov_lng" numeric(18,17) DEFAULT 0
);


ALTER TABLE public.portals OWNER TO oefunbdfyixopx;

--
-- Name: portals_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."portals_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.portals_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: portals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."portals_id_seq" OWNED BY "public"."portals"."id";


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."schema_migrations" (
    "version" character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO oefunbdfyixopx;

--
-- Name: sound_contexts; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."sound_contexts" (
    "id" integer NOT NULL,
    "context_type" character varying,
    "context_id" integer,
    "sound_id" integer
);


ALTER TABLE public.sound_contexts OWNER TO oefunbdfyixopx;

--
-- Name: sound_contexts_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."sound_contexts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sound_contexts_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: sound_contexts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."sound_contexts_id_seq" OWNED BY "public"."sound_contexts"."id";


--
-- Name: sounds; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."sounds" (
    "id" integer NOT NULL,
    "volume" integer,
    "name" character varying,
    "file" character varying,
    "loops" integer,
    "created_at" timestamp without time zone NOT NULL,
    "updated_at" timestamp without time zone NOT NULL
);


ALTER TABLE public.sounds OWNER TO oefunbdfyixopx;

--
-- Name: sounds_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."sounds_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sounds_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: sounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."sounds_id_seq" OWNED BY "public"."sounds"."id";


--
-- Name: spheres; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."spheres" (
    "id" integer NOT NULL,
    "panorama" character varying,
    "caption" character varying,
    "memory_id" integer,
    "created_at" timestamp without time zone NOT NULL,
    "updated_at" timestamp without time zone NOT NULL,
    "default_zoom" integer DEFAULT 50,
    "guid" character varying,
    "panorama_processing" boolean DEFAULT false NOT NULL,
    "panorama_tmp" character varying
);


ALTER TABLE public.spheres OWNER TO oefunbdfyixopx;

--
-- Name: spheres_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."spheres_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.spheres_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: spheres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."spheres_id_seq" OWNED BY "public"."spheres"."id";


--
-- Name: users; Type: TABLE; Schema: public; Owner: oefunbdfyixopx
--

CREATE TABLE "public"."users" (
    "id" integer NOT NULL,
    "name" character varying,
    "email" character varying,
    "created_at" timestamp without time zone NOT NULL,
    "updated_at" timestamp without time zone NOT NULL,
    "admin" boolean DEFAULT false,
    "encrypted_password" character varying DEFAULT ''::character varying NOT NULL,
    "reset_password_token" character varying,
    "reset_password_sent_at" timestamp without time zone,
    "remember_created_at" timestamp without time zone,
    "sign_in_count" integer DEFAULT 0 NOT NULL,
    "current_sign_in_at" timestamp without time zone,
    "last_sign_in_at" timestamp without time zone,
    "current_sign_in_ip" character varying,
    "last_sign_in_ip" character varying,
    "confirmation_token" character varying,
    "confirmed_at" timestamp without time zone,
    "confirmation_sent_at" timestamp without time zone,
    "unconfirmed_email" character varying,
    "failed_attempts" integer DEFAULT 0 NOT NULL,
    "unlock_token" character varying,
    "locked_at" timestamp without time zone
);


ALTER TABLE public.users OWNER TO oefunbdfyixopx;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: oefunbdfyixopx
--

CREATE SEQUENCE "public"."users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO oefunbdfyixopx;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oefunbdfyixopx
--

ALTER SEQUENCE "public"."users_id_seq" OWNED BY "public"."users"."id";


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."delayed_jobs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."delayed_jobs_id_seq"'::"regclass");


--
-- Name: markers id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."markers" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."markers_id_seq"'::"regclass");


--
-- Name: memories id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."memories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."memories_id_seq"'::"regclass");


--
-- Name: microposts id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."microposts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."microposts_id_seq"'::"regclass");


--
-- Name: portals id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."portals" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."portals_id_seq"'::"regclass");


--
-- Name: sound_contexts id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."sound_contexts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sound_contexts_id_seq"'::"regclass");


--
-- Name: sounds id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."sounds" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sounds_id_seq"'::"regclass");


--
-- Name: spheres id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."spheres" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."spheres_id_seq"'::"regclass");


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."users" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."users_id_seq"'::"regclass");


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."ar_internal_metadata" ("key", "value", "created_at", "updated_at") FROM stdin;
environment	production	2017-06-05 07:15:22.647883	2017-06-05 07:15:22.647883
\.


--
-- Data for Name: delayed_jobs; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."delayed_jobs" ("id", "priority", "attempts", "handler", "last_error", "run_at", "locked_at", "failed_at", "locked_by", "queue", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: markers; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."markers" ("id", "image", "tooltip_content", "tooltip_position", "content", "x", "y", "width", "height", "sphere_id", "created_at", "updated_at", "guid", "embedded_photo", "embedded_photo_processing") FROM stdin;
1	pin2.png	Look at joes face	right bottom	<img style="max-width: 100%; max-height: 100%;" src="/assets/joesface-e332204a111eb741398040b676af9fbfd6535b770ab6513ccd20ddec8521d087.jpg" alt="Joesface" />	2068	1225	32	32	2	2017-06-05 07:15:47.785756	2017-06-05 07:15:47.785756	\N	\N	f
2	pin2.png	cool fridge photo	right bottom	<img style="max-width: 100%; max-height: 100%;" src="/assets/fridge-a6f169824a203c80f2ab2ab28fdb0f62e67c6aace2b661e61bd54c1bb0ada4d7.jpg" alt="Fridge" />	8546	745	32	32	2	2017-06-05 07:15:47.793328	2017-06-05 07:15:47.793328	\N	\N	f
43	pin2.png		right bottom	<!--IMGHERE-->	6447	2149	32	32	48	2018-01-23 18:53:12.368607	2018-01-23 18:53:18.153544	\N	IMG_20171228_112709.jpg	f
44	pin2.png		right bottom	<!--IMGHERE-->	7775	2396	32	32	67	2018-01-23 18:54:09.948034	2018-01-23 18:54:14.736847	\N	IMG_20171228_103437.jpg	f
46	pin2.png		right bottom	<!--IMGHERE-->	6462	2409	32	32	67	2018-01-23 19:00:16.014289	2018-01-23 19:00:18.200908	\N	IMG_20171228_103447.jpg	f
47	pin2.png		right bottom	<!--IMGHERE-->	3211	2359	32	32	68	2018-01-23 19:03:49.42342	2018-01-23 19:03:55.091671	\N	IMG_20171228_112950.jpg	f
48	pin2.png		right bottom	<!--IMGHERE-->	6083	2263	32	32	65	2018-01-23 19:48:35.253096	2018-01-23 19:48:38.66781	\N	IMG_20171228_112309.jpg	f
49	pin2.png		right bottom	<!--IMGHERE-->	1151	2290	32	32	52	2018-01-23 19:50:30.246579	2018-01-23 19:50:35.103589	\N	IMG_20171227_134436.jpg	f
50	pin2.png		right bottom	<!--IMGHERE-->	2358	2857	32	32	52	2018-01-23 19:50:57.435969	2018-01-23 19:51:01.422915	\N	IMG_20171228_114144.jpg	f
51	pin2.png		right bottom	<!--IMGHERE-->	4310	3315	32	32	58	2018-01-23 19:52:32.874776	2018-01-23 19:52:37.750745	\N	IMG_20171228_112131.jpg	f
52	pin2.png		right bottom	<!--IMGHERE-->	4297	3201	32	32	58	2018-01-23 19:53:18.341442	2018-01-23 19:53:24.114045	\N	IMG_20171228_111931.jpg	f
53	pin2.png		right bottom	<!--IMGHERE-->	4303	3082	32	32	58	2018-01-23 19:53:38.732775	2018-01-23 19:53:40.197137	\N	IMG_20171228_111945.jpg	f
54	pin2.png		right bottom	<!--IMGHERE-->	4308	2825	32	32	58	2018-01-23 19:54:26.943423	2018-01-23 19:54:31.332334	\N	IMG_20171228_112003.jpg	f
72	pin2.png		right bottom	<!--IMGHERE-->	6881	2191	32	32	52	2018-01-23 20:08:14.571674	2018-01-23 20:08:19.073357	\N	IMG_20171228_113208.jpg	f
56	pin2.png		right bottom	<!--IMGHERE-->	6682	2336	32	32	58	2018-01-23 19:55:53.406645	2018-01-23 19:55:58.901006	\N	IMG_20171228_112157.jpg	f
57	pin2.png	Grandkids	right bottom	<!--IMGHERE-->	3088	2264	32	32	48	2018-01-23 19:57:08.302503	2018-01-23 19:57:10.141182	\N	IMG_20171227_133704.jpg	f
58	pin2.png	Kids	right bottom	<!--IMGHERE-->	3461	2290	32	32	48	2018-01-23 19:57:30.168205	2018-01-23 19:57:36.197181	\N	IMG_20171227_133714.jpg	f
59	pin2.png		right bottom	<!--IMGHERE-->	7608	2463	32	32	51	2018-01-23 19:58:23.066595	2018-01-23 19:58:27.189354	\N	IMG_20171227_133959.jpg	f
60	pin2.png		right bottom	<!--IMGHERE-->	3106	2197	32	32	52	2018-01-23 19:58:59.815198	2018-01-23 19:59:03.285974	\N	IMG_20171227_134330.jpg	f
61	pin2.png		right bottom	<!--IMGHERE-->	6051	2107	32	32	52	2018-01-23 20:00:17.039069	2018-01-23 20:00:19.518799	\N	IMG_20171227_134346.jpg	f
62	pin2.png		right bottom	<!--IMGHERE-->	8149	2123	32	32	52	2018-01-23 20:00:34.493351	2018-01-23 20:00:40.842472	\N	IMG_20171227_134409.jpg	f
63	pin2.png		right bottom	<!--IMGHERE-->	4803	2029	32	32	55	2018-01-23 20:01:51.616674	2018-01-23 20:01:57.137666	\N	IMG_20171227_135723.jpg	f
64	pin2.png		right bottom	<!--IMGHERE-->	6337	1997	32	32	73	2018-01-23 20:03:12.247195	2018-01-23 20:03:18.982922	\N	IMG_20171228_104523.jpg	f
65	pin2.png		right bottom	<!--IMGHERE-->	7810	2317	32	32	73	2018-01-23 20:03:35.18219	2018-01-23 20:03:39.992941	\N	IMG_20171228_104530.jpg	f
66	pin2.png		right bottom	<!--IMGHERE-->	3130	2174	32	32	73	2018-01-23 20:04:31.04118	2018-01-23 20:04:36.419686	\N	IMG_20171228_104542.jpg	f
67	pin2.png		right bottom	<!--IMGHERE-->	7859	2533	32	32	58	2018-01-23 20:05:40.343376	2018-01-23 20:05:42.626077	\N	IMG_20171228_112226.jpg	f
68	pin2.png		right bottom	<!--IMGHERE-->	8474	2578	32	32	58	2018-01-23 20:06:00.894199	2018-01-23 20:06:03.842359	\N	IMG_20171228_112214.jpg	f
69	pin2.png		right bottom	<!--IMGHERE-->	5608	2300	32	32	71	2018-01-23 20:06:29.495444	2018-01-23 20:06:34.80676	\N	IMG_20171228_112548.jpg	f
70	pin2.png		right bottom	<!--IMGHERE-->	8291	2434	32	32	71	2018-01-23 20:06:47.112398	2018-01-23 20:06:51.23589	\N	IMG_20171228_112554.jpg	f
96	pin2.png	This is very cold.	right bottom		5944	2396	32	32	176	2018-03-18 06:53:12.453165	2018-03-18 06:53:12.453165	\N	\N	t
73	pin2.png		right bottom	<!--IMGHERE-->	122	2145	32	32	52	2018-01-23 20:08:52.456138	2018-01-23 20:08:55.633966	\N	IMG_20171228_113230.jpg	f
74	pin2.png		right bottom	<!--IMGHERE-->	2690	2310	32	32	70	2018-01-23 20:09:48.698498	2018-01-23 20:09:52.444407	\N	IMG_20171228_113632.jpg	f
78	pin2.png		right bottom	<!--IMGHERE-->	8041	4716	32	32	4	2018-01-23 20:57:14.268333	2018-01-23 20:57:14.998634	\N	drawer.jpg	f
79	pin2.png		right bottom	<!--IMGHERE-->	2944	377	32	32	6	2018-01-23 20:57:43.33282	2018-01-23 20:57:46.355099	\N	left.jpg	f
80	pin2.png		right bottom	<!--IMGHERE-->	5326	1199	32	32	6	2018-01-23 20:57:58.062576	2018-01-23 20:58:01.677026	\N	middle.jpg	f
81	pin2.png		right bottom	<!--IMGHERE-->	6440	615	32	32	6	2018-01-23 20:58:16.818156	2018-01-23 20:58:22.172385	\N	second_right.jpg	f
82	pin2.png		right bottom	<!--IMGHERE-->	6865	545	32	32	6	2018-01-23 20:58:32.006961	2018-01-23 20:58:37.74674	\N	far_right.jpg	f
83	pin2.png		right bottom	<h4>Ocean beach was great for finding sand dollars</h4><!--IMGHERE-->	1926	2518	32	32	5	2018-01-23 21:00:38.539607	2018-01-23 21:00:43.319414	\N	surf.jpg	f
85	pin2.png		right bottom	<!--IMGHERE-->	6687	2877	32	32	5	2018-01-23 21:01:16.922163	2018-01-23 21:01:19.154416	\N	books-bdbe2f566aa81dfe68f5255a16258baa6f12dd7564eb838bcf02f688ad5c7bd7.jpg	f
87	pin2.png	This heater was all I needed to keep warm	right bottom		4093	2119	32	32	5	2018-01-23 21:02:17.921425	2018-01-23 21:02:23.299609	\N	top_hatch.jpg	f
88	pin2.png		right bottom	<h5>The best part was at night. I'd open this hatch and watch the planes fly by overhead.<br><br>The breeze, the sound of the waves, and the gentle rocking put you right to sleep.</h5>﻿<br><!--IMGHERE-->	3371	-484	32	32	5	2018-01-23 21:06:34.662138	2018-01-23 21:06:40.88712	\N	top_hatch.jpg	f
90	pin2.png	Surfboard	right bottom	I talked about getting a surfboard for a long time. <br><br>The next day, A surfboard washed into shore while I was waiting for the bus.<br><br>As you can see, I'm in a state of disbelief.<br><!--IMGHERE-->	5186	2190	32	32	25	2018-01-23 21:34:09.302589	2018-01-23 21:34:11.699672	\N	surfboard.jpg	f
92	pin2.png	Welcome!	right bottom	<h3>Welcome to my boat!</h3><h5>I used to live here.</h5><h5>﻿<span style="color: inherit; font-family: &quot;Istok Web&quot;, sans-serif;">Click the places indicated in red&nbsp;</span>to explore.</h5><div>﻿<br></div><!--IMGHERE-->	8874	713	32	32	3	2018-01-23 21:45:41.456486	2018-01-23 21:45:42.573142	\N	joe_sail.jpg	f
97	pin2.png	The Steepest Railway	right bottom	The steepest section of track is on an incline of 52 degrees contained within a total distance of 310 metres (1,020 ft).<br><br>It was originally constructed for a coal and oil shale mining operation in the Jamison Valley in the 1880s, in order to haul the coal and shale from the valley floor up to the escarpment above.<br><br>From 1928 to 1945 it carried coal during the week and passengers at weekends. The coal mine was closed in 1945 after which it remained as a tourist attraction.﻿	3363	1559	32	32	175	2018-03-18 06:59:06.603536	2018-03-18 06:59:06.603536	\N	\N	t
94	pin2.png	Look at that guy	right bottom	<h4>Isn't this cool.</h4><h4>﻿<!--IMGHERE--></h4>	2345	957	32	32	121	2018-01-24 20:40:53.799963	2018-01-24 20:40:55.359691	\N	joe_sail.jpg	f
98	pin2.png	See? They're kissing.	right bottom		4109	1127	32	32	180	2018-03-18 07:02:04.21414	2018-03-18 07:02:04.21414	\N	\N	t
99	pin2.png	I think that's naughty.	right bottom		1189	2404	32	32	180	2018-03-18 07:02:25.202257	2018-03-18 07:02:25.202257	\N	\N	t
100	pin2.png		right bottom	A two hour train takes you all the way from Sydney central station to the Blue Mountains. Just a hop, skip and a jump from beautiful sights.	3538	1696	32	32	163	2018-03-18 07:05:12.8754	2018-03-18 07:05:12.8754	\N	\N	t
101	pin2.png		right bottom	<!--IMGHERE-->	6627	1587	32	32	163	2018-03-18 07:06:00.879555	2018-03-18 07:06:02.106475	\N	prof_400x400.jpg	f
102	pin2.png	The Three Sisters	right bottom	The Three Sisters are an unusual rock formation in the Blue Mountains of New South Wales, Australia, on the north escarpment of the Jamison Valley. They are close to the town of Katoomba and are one of the Blue Mountains' best known sites, towering above the Jamison Valley.<br><br>Their names are Meehni (922 m), Wimlah (918 m), and Gunnedoo (906 m).﻿	6691	1819	32	32	165	2018-03-18 07:12:06.982539	2018-03-18 07:12:06.982539	\N	\N	t
103	pin2.png	There's a bird here	right bottom	but you can't see it.	3860	1554	32	32	172	2018-03-18 07:14:15.865292	2018-03-18 07:14:15.865292	\N	\N	t
105	pin2.png		right bottom	<!--IMGHERE-->	4595	1474	32	32	191	2018-04-03 12:15:50.957909	2018-04-03 12:15:58.938081	\N	IMG_20180401_215653.jpg	f
106	pin2.png		right bottom	<!--IMGHERE-->	354	2332	32	32	193	2018-04-03 12:34:02.09823	2018-04-03 12:34:11.547564	\N	IMG_20180401_124837.jpg	f
107	pin2.png		right bottom	<!--IMGHERE-->	6493	1787	32	32	195	2018-04-03 12:43:47.762548	2018-04-03 12:43:54.34039	\N	IMG_20180401_103830.jpg	f
108	pin2.png		right bottom	<!--IMGHERE-->	5021	1654	32	32	189	2018-04-03 12:46:33.148458	2018-04-03 12:46:38.117133	\N	IMG_20180402_090057.jpg	f
109	pin2.png		right bottom	<!--IMGHERE-->	5027	1946	32	32	191	2018-04-03 12:47:56.540023	2018-04-03 12:48:01.943992	\N	IMG_20180401_190144.jpg	f
110	pin2.png		right bottom	<!--IMGHERE-->	416	1644	32	32	193	2018-04-03 12:56:41.183453	2018-04-03 12:56:48.370432	\N	IMG_20180401_124516.jpg	f
111	pin2.png		right bottom	<!--IMGHERE-->	6379	1431	32	32	196	2018-04-03 13:00:08.906724	2018-04-03 13:00:17.718859	\N	IMG_20180401_150143.jpg	f
\.


--
-- Data for Name: memories; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."memories" ("id", "name", "user_id", "created_at", "updated_at", "description", "private") FROM stdin;
11	Mountains	1	2017-07-27 23:05:20.312295	2017-07-27 23:05:20.312295		f
41	Joe's Childhood Home 2	1	2018-02-06 21:28:28.048057	2021-03-07 06:59:44.495561	I took these with a hopefully better 360 Camera	f
1	Joe's Childhood Home	1	2017-06-05 07:15:45.20776	2017-06-05 08:04:10.701324	I lived in this same house for 18 years until I moved out. My parents still live here.	f
42	The Opera House	1	2018-02-09 08:41:00.429721	2018-02-09 08:41:05.770843	\N	f
30	New Memory	11	2018-01-22 03:08:13.686425	2018-01-22 03:08:13.686425	\N	f
14	Grandma's	1	2017-12-29 18:07:25.297454	2018-03-05 09:49:45.558186	My grandfather built this house	f
2	Joe's Boat	1	2017-06-05 07:15:47.852948	2018-01-23 21:02:24.738909	This was my home for 12 months, and I'll never forget it.	f
44	Blue Mountain	1	2018-03-18 06:12:58.902986	2018-03-18 07:27:16.787842	is a national park just outside of the Sydney Metropolitan area	f
46	New Memory	1	2018-06-20 03:46:32.437183	2018-06-20 03:46:32.437183	\N	f
47	Sick	1	2018-10-03 07:25:55.611624	2018-10-03 07:26:03.405576	\N	f
45	Newnes Campground!	1	2018-04-03 03:11:49.143918	2019-01-10 05:47:19.5414	After some last minute planning, we pulled it together!	f
35	Boat 2	12	2018-01-24 20:38:52.678126	2018-01-24 20:39:34.619891	This is an example	f
24	dylans-face	10	2018-01-21 01:17:05.823044	2018-01-21 01:18:00.443763	\N	t
36	New Memory	14	2018-01-25 02:33:31.059086	2018-01-25 02:33:31.059086	\N	f
38	mem2	14	2018-01-25 02:48:47.592419	2018-01-25 02:49:02.093715	Click to add a description	f
39	dylan	14	2018-01-25 02:49:54.071913	2018-01-25 02:49:56.960771	\N	f
40	Joe's Childhood Home	1	2018-01-25 20:06:17.582801	2018-01-25 20:56:36.610042	I took this with a 360 Camera	f
50	51 West Edge Road	12214	2021-11-27 22:45:47.08159	2021-11-27 22:45:57.801493	\N	f
\.


--
-- Data for Name: microposts; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."microposts" ("id", "content", "user_id", "created_at", "updated_at", "picture") FROM stdin;
\.


--
-- Data for Name: portals; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."portals" ("id", "polygon_px", "fill", "stroke", "stroke_transparency", "stroke_width", "tooltip_content", "tooltip_position", "from_sphere_id", "to_sphere_id", "created_at", "updated_at", "fov_lat", "fov_lng") FROM stdin;
1	---\n- 4042\n- 289\n- 4402\n- 236\n- 4507\n- 1338\n- 4069\n- 1343\n	points	#ff0032	80	2	Go to the kitchen!	right bottom	1	2	2017-06-05 07:15:47.827688	2017-06-05 07:15:47.827688	-0.04186083996971335	3.33634602184647700
2	---\n- 8950\n- 302\n- 555\n- 280\n- 658\n- 848\n- 255\n- 996\n- 313\n- 1596\n- 9014\n- 1666\n- 8958\n- 302\n	points	#ff0032	80	2	Go to the livingroom!	right bottom	2	1	2017-06-05 07:15:47.840821	2017-06-05 07:15:47.840821	0.00000000000000000	0.00000000000000000
34	---\n- - 9094\n  - 964\n- - 9209\n  - 998\n- - 9303\n  - 1023\n- - 9304\n  - 1074\n- - 9303\n  - 1181\n- - 9310\n  - 1310\n- - 9297\n  - 1478\n- - 9268\n  - 1715\n- - 9253\n  - 1821\n- - 9253\n  - 1825\n- - 8555\n  - 1575\n- - 8424\n  - 1516\n- - 8347\n  - 1445\n- - 8315\n  - 1362\n- - 8275\n  - 1262\n- - 8283\n  - 1125\n- - 8288\n  - 1070\n- - 8306\n  - 1036\n- - 8429\n  - 1015\n- - 8451\n  - 977\n- - 8473\n  - 947\n- - 8559\n  - 926\n- - 8697\n  - 913\n- - 8783\n  - 896\n- - 8878\n  - 896\n	points	#ff0032	80	2	Go inside the boat!	right bottom	3	4	2017-06-19 04:36:24.658362	2017-06-19 04:36:24.658362	0.00000000000000000	0.00000000000000000
4	---\n- 4426\n- 1188\n- 4930\n- 1198\n- 4966\n- 1932\n- 4381\n- 1907\n	points	#ff0032	80	2	Check out that boat bed!	right bottom	4	5	2017-06-05 07:16:05.132094	2017-06-05 07:16:05.132094	-0.21499314649773970	0.04682678441209071
6	---\n- 2844\n- 1518\n- 3050\n- 1549\n- 3046\n- 1786\n- 2798\n- 1773\n	points	#ff0032	30	2	Turn the light on	right bottom	4	6	2017-06-05 07:16:05.166644	2017-06-05 07:16:05.166644	-0.30214935245693160	0.17226333918505280
7	---\n- 3825\n- 1037\n- 4102\n- 1061\n- 4069\n- 1369\n- 3753\n- 1337\n	points	#ff0032	30	2	Go back to day time	right bottom	6	4	2017-06-05 07:16:05.197977	2017-06-05 07:16:05.197977	-0.62673882208390050	0.16397512279941960
285	---\n- - 4609\n  - 1514\n- - 5293\n  - 1516\n- - 5285\n  - 2077\n- - 4536\n  - 2051\n	points	#ff0032	80	2	\N	right bottom	188	193	2020-11-20 04:53:53.355725	2020-11-20 04:53:53.355725	0.00000000000000000	0.00000000000000000
35	---\n- - 9371\n  - 1048\n- - 9391\n  - 1308\n- - 9328\n  - 1847\n- - 9447\n  - 1881\n- - 9568\n  - 1909\n- - 9688\n  - 1935\n- - 9787\n  - 1945\n- - 9796\n  - 1960\n- - 10156\n  - 1421\n- - 10139\n  - 1376\n	points	#ff0032	80	2	Go to the frontyard	right bottom	3	27	2017-06-19 04:37:04.417837	2017-06-19 04:37:04.417837	0.00000000000000000	0.00000000000000000
36	---\n- - 2186\n  - 687\n- - 2289\n  - 667\n- - 2336\n  - 668\n- - 2403\n  - 670\n- - 2458\n  - 674\n- - 2540\n  - 696\n- - 2562\n  - 708\n- - 2601\n  - 727\n- - 2609\n  - 747\n- - 2562\n  - 753\n- - 2470\n  - 749\n- - 2377\n  - 753\n- - 2306\n  - 747\n- - 2249\n  - 745\n- - 2209\n  - 743\n- - 2182\n  - 731\n	points	#ff0032	80	2	Go to Treasure Island Marina!	right bottom	27	23	2017-06-19 04:37:56.877715	2017-06-19 04:37:56.877715	0.00000000000000000	0.00000000000000000
37	---\n- - 6298\n  - 1560\n- - 6395\n  - 1519\n- - 6535\n  - 1516\n- - 6628\n  - 1514\n- - 6634\n  - 1546\n- - 6626\n  - 1557\n- - 6295\n  - 1572\n	points	#ff0032	80	2	Go to South Beach Marina!	right bottom	25	3	2017-06-19 04:41:22.41965	2017-06-19 04:41:22.41965	0.00000000000000000	0.00000000000000000
38	---\n- - 1393\n  - 1149\n- - 1421\n  - 1102\n- - 1415\n  - 1080\n- - 1283\n  - 1056\n- - 1273\n  - 1060\n- - 1253\n  - 1069\n- - 1242\n  - 1073\n- - 1236\n  - 1082\n- - 1238\n  - 1102\n- - 1238\n  - 1112\n- - 1238\n  - 1118\n- - 1238\n  - 1121\n	points	#ff0032	80	2	Go to the boat bed!	right bottom	27	5	2017-06-19 15:50:45.614595	2017-06-19 15:50:45.614595	0.00000000000000000	0.00000000000000000
39	---\n- - 1553\n  - 87\n- - 4942\n  - -98\n- - 4497\n  - 1089\n- - 2904\n  - 1047\n	points	#ff0032	80	2	Go to the boat frontyard	right bottom	5	27	2017-06-19 15:53:30.510587	2017-06-19 15:53:30.510587	0.00000000000000000	0.00000000000000000
40	---\n- - 5056\n  - 542\n- - 5224\n  - 677\n- - 5036\n  - 835\n- - 5406\n  - 684\n	points	#ff0032	80	2	Go to the boat backyard	right bottom	27	26	2017-06-19 15:53:59.459926	2017-06-19 15:53:59.459926	0.00000000000000000	0.00000000000000000
41	---\n- - 108\n  - 1248\n- - -114\n  - 1401\n- - 152\n  - 1522\n- - -360\n  - 1403\n	points	#ff0032	80	2	Go to the boat frontyard	right bottom	26	27	2017-06-19 15:54:30.080613	2017-06-19 15:54:30.080613	0.00000000000000000	0.00000000000000000
19	---\n- - 14009\n  - 956\n- - 14080\n  - 956\n- - 14082\n  - 1167\n- - 14008\n  - 1204\n	points	#ff0032	80	2	Go back to the boat	right bottom	23	4	2017-06-11 19:53:49.294025	2017-06-11 19:53:49.294025	0.00000000000000000	0.00000000000000000
43	---\n- - 7000\n  - 1504\n- - 7316\n  - 1506\n- - 7380\n  - 1724\n- - 6939\n  - 1690\n	points	#ff0032	80	2	Go to the other kitchen	right bottom	2	29	2017-07-04 04:15:54.720461	2017-07-04 04:15:54.720461	0.00000000000000000	0.00000000000000000
21	---\n- - 14504\n  - 828\n- - 14597\n  - 836\n- - 14607\n  - 990\n- - 14494\n  - 992\n	points	#ff0032	80	2	See the Island View	right bottom	23	25	2017-06-11 20:04:51.982741	2017-06-11 20:04:51.982741	0.00000000000000000	0.00000000000000000
22	---\n- - 1731\n  - 1461\n- - 1971\n  - 1461\n- - 1963\n  - 1680\n- - 1717\n  - 1650\n	points	#ff0032	80	2	Go back to treasure island marina	right bottom	25	23	2017-06-11 20:05:56.260301	2017-06-11 20:05:56.260301	0.00000000000000000	0.00000000000000000
23	---\n- - 12299\n  - 288\n- - -2920\n  - 343\n- - -1933\n  - 2875\n- - 11041\n  - 3259\n	points	#ff0032	80	2	Boat backyard	right bottom	4	26	2017-06-11 20:18:52.233101	2017-06-11 20:18:52.233101	0.00000000000000000	0.00000000000000000
44	---\n- - 697\n  - 1569\n- - 957\n  - 1465\n- - 917\n  - 2555\n- - 480\n  - 2451\n	points	#ff0032	80	2	Go to the basement!	right bottom	29	30	2017-07-04 04:17:45.816455	2017-07-04 04:17:45.816455	0.00000000000000000	0.00000000000000000
25	---\n- - 2828\n  - 2100\n- - 3120\n  - 2097\n- - 3116\n  - 2300\n- - 2777\n  - 2297\n	points	#ff0032	80	2	Back to boat	right bottom	26	4	2017-06-11 20:19:45.989288	2017-06-11 20:19:45.989288	0.00000000000000000	0.00000000000000000
26	---\n- - 4142\n  - 1215\n- - 4381\n  - 1426\n- - 4127\n  - 1698\n- - 4608\n  - 1436\n	points	#ff0032	80	2	Go to the frontyard	right bottom	26	27	2017-06-11 20:24:40.384812	2017-06-11 20:24:40.384812	0.00000000000000000	0.00000000000000000
27	---\n- - 157\n  - 448\n- - 5\n  - 597\n- - 176\n  - 675\n- - -211\n  - 599\n	points	#ff0032	80	2	Go to the backyard	right bottom	27	26	2017-06-11 20:25:50.843721	2017-06-11 20:25:50.843721	0.00000000000000000	0.00000000000000000
28	---\n- - 1624\n  - 966\n- - 1907\n  - 982\n- - 1911\n  - 1054\n- - 1621\n  - 1033\n	points	#ff0032	80	2	Go to the marina	right bottom	27	3	2017-06-11 20:26:17.971882	2017-06-11 20:26:17.971882	0.00000000000000000	0.00000000000000000
46	---\n- - 6407\n  - 1776\n- - 6289\n  - 1901\n- - 6560\n  - 1888\n	points	#ff0032	80	2		right bottom	32	31	2017-07-27 23:06:07.161796	2017-07-27 23:06:07.161796	0.00000000000000000	0.00000000000000000
47	---\n- - 265\n  - 1521\n- - 7161\n  - 1672\n- - 653\n  - 1627\n	points	#ff0032	80	2		right bottom	31	32	2017-07-27 23:06:20.093813	2017-07-27 23:06:20.093813	0.00000000000000000	0.00000000000000000
52	---\n- - 47\n  - 1357\n- - 584\n  - 1299\n- - 634\n  - 1473\n- - 542\n  - 2343\n- - 215\n  - 2314\n	points	#ff0032	80	2	Get out of the dungeon ACKHEM, I mean basement.	right bottom	30	29	2017-12-02 01:28:00.162732	2017-12-02 01:28:00.162732	0.00000000000000000	0.00000000000000000
54	---\n- - 8373\n  - 2150\n- - 55\n  - 2134\n- - 13\n  - 2495\n- - 8229\n  - 2423\n	points	#ff0032	80	2	Go to the barn!	right bottom	35	39	2017-12-29 18:26:23.885752	2017-12-29 18:26:23.885752	0.00000000000000000	0.00000000000000000
55	---\n- - 7052\n  - 2057\n- - 7261\n  - 2060\n- - 7282\n  - 2286\n- - 7048\n  - 2288\n	points	#ff0032	80	2	Go to the front yard	right bottom	39	35	2017-12-29 18:28:01.414771	2017-12-29 18:28:01.414771	0.00000000000000000	0.00000000000000000
56	---\n- - 8049\n  - 2190\n- - 8028\n  - 2341\n- - 8247\n  - 2338\n- - 8242\n  - 2196\n	points	#ff0032	80	2	Go around back	right bottom	39	40	2017-12-29 18:29:30.831791	2017-12-29 18:29:30.831791	0.00000000000000000	0.00000000000000000
58	---\n- - 3651\n  - 1812\n- - 3834\n  - 1804\n- - 3834\n  - 1949\n- - 3645\n  - 1963\n	points	#ff0032	80	2	Back to the barn	right bottom	40	39	2017-12-29 18:34:35.960614	2017-12-29 18:34:35.960614	0.00000000000000000	0.00000000000000000
60	---\n- - 4260\n  - 1744\n- - 4696\n  - 1725\n- - 4729\n  - 2259\n- - 4238\n  - 2270\n	points	#ff0032	80	2	Go inside!	right bottom	35	41	2017-12-30 20:30:40.265792	2017-12-30 20:30:40.265792	0.00000000000000000	0.00000000000000000
61	---\n- - 3792\n  - 1733\n- - 5164\n  - 1707\n- - 5313\n  - 3601\n- - 3928\n  - 3621\n	points	#ff0032	80	2		right bottom	41	44	2017-12-31 03:43:18.538868	2017-12-31 03:43:18.538868	0.00000000000000000	0.00000000000000000
62	---\n- - 6511\n  - 1989\n- - 7741\n  - 1946\n- - 7783\n  - 3607\n- - 6494\n  - 3550\n	points	#ff0032	80	2		right bottom	44	41	2017-12-31 03:43:44.354496	2017-12-31 03:43:44.354496	0.00000000000000000	0.00000000000000000
63	---\n- - 8066\n  - 1588\n- - 874\n  - 1565\n- - 995\n  - 3663\n- - 7895\n  - 3732\n	points	#ff0032	80	2		right bottom	41	35	2017-12-31 03:44:14.867769	2017-12-31 03:44:14.867769	0.00000000000000000	0.00000000000000000
64	---\n- - 3113\n  - 2060\n- - 3620\n  - 2034\n- - 3684\n  - 3179\n- - 3103\n  - 3170\n	points	#ff0032	80	2		right bottom	44	47	2017-12-31 04:12:09.503393	2017-12-31 04:12:09.503393	0.00000000000000000	0.00000000000000000
65	---\n- - 7765\n  - 2884\n- - 7924\n  - 2845\n- - 8110\n  - 2831\n- - 8255\n  - 2887\n- - 8312\n  - 2994\n- - 8224\n  - 3093\n- - 7980\n  - 3075\n- - 7797\n  - 3040\n- - 7738\n  - 2994\n- - 7708\n  - 2963\n	points	#ff0032	80	2		right bottom	47	48	2017-12-31 04:15:20.701232	2017-12-31 04:15:20.701232	0.00000000000000000	0.00000000000000000
66	---\n- - 1693\n  - 2612\n- - 2054\n  - 2616\n- - 2037\n  - 2773\n- - 1646\n  - 2755\n	points	#ff0032	80	2		right bottom	48	47	2017-12-31 04:15:46.113559	2017-12-31 04:15:46.113559	0.00000000000000000	0.00000000000000000
67	---\n- - 4757\n  - 2861\n- - 5008\n  - 2858\n- - 5041\n  - 3187\n- - 4798\n  - 3201\n	points	#ff0032	80	2		right bottom	47	49	2017-12-31 04:19:19.411821	2017-12-31 04:19:19.411821	0.00000000000000000	0.00000000000000000
68	---\n- - 6600\n  - 1536\n- - 6866\n  - 1548\n- - 6855\n  - 1742\n- - 6582\n  - 1730\n	points	#ff0032	80	2		right bottom	49	47	2017-12-31 04:20:35.645861	2017-12-31 04:20:35.645861	0.00000000000000000	0.00000000000000000
69	---\n- - 2603\n  - 1698\n- - 3427\n  - 1835\n- - 4237\n  - 3816\n- - 2550\n  - 4082\n	points	#ff0032	80	2		right bottom	49	50	2017-12-31 04:22:09.200678	2017-12-31 04:22:09.200678	0.00000000000000000	0.00000000000000000
70	---\n- - 8695\n  - 1992\n- - 412\n  - 2031\n- - 398\n  - 3338\n- - 8693\n  - 3616\n	points	#ff0032	80	2		right bottom	50	49	2017-12-31 04:22:33.650315	2017-12-31 04:22:33.650315	0.00000000000000000	0.00000000000000000
71	---\n- - 448\n  - 2611\n- - 471\n  - 2827\n- - 765\n  - 2730\n- - 696\n  - 2572\n	points	#ff0032	80	2		right bottom	49	51	2017-12-31 04:26:02.672479	2017-12-31 04:26:02.672479	0.00000000000000000	0.00000000000000000
74	---\n- - 333\n  - 2090\n- - 331\n  - 2396\n- - 419\n  - 2409\n- - 430\n  - 2741\n- - 587\n  - 2721\n- - 594\n  - 2108\n	points	#ff0032	80	2		right bottom	52	51	2017-12-31 04:38:35.35291	2017-12-31 04:38:35.35291	0.00000000000000000	0.00000000000000000
76	---\n- - 3436\n  - 2394\n- - 3408\n  - 2427\n- - 3382\n  - 2454\n- - 3368\n  - 2474\n- - 3378\n  - 2620\n- - 3372\n  - 2644\n- - 3423\n  - 2680\n- - 3438\n  - 2681\n- - 3461\n  - 2661\n- - 3501\n  - 2639\n- - 3493\n  - 2484\n- - 3495\n  - 2462\n	points	#ff0032	80	2		right bottom	52	54	2017-12-31 04:41:35.59736	2017-12-31 04:41:35.59736	0.00000000000000000	0.00000000000000000
77	---\n- - 6310\n  - 2273\n- - 6281\n  - 2316\n- - 6250\n  - 2347\n- - 6229\n  - 2369\n- - 6239\n  - 2410\n- - 6251\n  - 2544\n- - 6244\n  - 2576\n- - 6289\n  - 2596\n- - 6314\n  - 2615\n- - 6328\n  - 2610\n- - 6354\n  - 2593\n- - 6393\n  - 2568\n- - 6390\n  - 2540\n- - 6378\n  - 2382\n- - 6382\n  - 2353\n	points	#ff0032	80	2		right bottom	54	52	2017-12-31 04:42:41.690266	2017-12-31 04:42:41.690266	0.00000000000000000	0.00000000000000000
78	---\n- - 1006\n  - 3013\n- - 1519\n  - 3001\n- - 1434\n  - 2820\n- - 994\n  - 2834\n	points	#ff0032	80	2		right bottom	51	49	2017-12-31 04:43:27.182171	2017-12-31 04:43:27.182171	0.00000000000000000	0.00000000000000000
79	---\n- - 4372\n  - 1171\n- - 5518\n  - 1264\n- - 5398\n  - 3493\n- - 3939\n  - 3406\n	points	#ff0032	80	2		right bottom	49	55	2017-12-31 04:45:30.208595	2017-12-31 04:45:30.208595	0.00000000000000000	0.00000000000000000
80	---\n- - 6852\n  - 1663\n- - 7803\n  - 1820\n- - 7767\n  - 3540\n- - 6666\n  - 3836\n	points	#ff0032	80	2		right bottom	55	49	2017-12-31 04:46:00.312393	2017-12-31 04:46:00.312393	0.00000000000000000	0.00000000000000000
81	---\n- - 4366\n  - 2016\n- - 4604\n  - 2024\n- - 4692\n  - 2336\n- - 4657\n  - 2716\n- - 4369\n  - 2734\n	points	#ff0032	80	2		right bottom	55	56	2017-12-31 04:47:24.278548	2017-12-31 04:47:24.278548	0.00000000000000000	0.00000000000000000
82	---\n- - 1239\n  - 2009\n- - 1818\n  - 2016\n- - 1796\n  - 3131\n- - 1277\n  - 3135\n	points	#ff0032	80	2		right bottom	56	55	2017-12-31 04:47:48.378198	2017-12-31 04:47:48.378198	0.00000000000000000	0.00000000000000000
83	---\n- - 6434\n  - 1950\n- - 6812\n  - 1949\n- - 6746\n  - 3032\n- - 6456\n  - 2979\n	points	#ff0032	80	2		right bottom	47	44	2017-12-31 04:48:17.6064	2017-12-31 04:48:17.6064	0.00000000000000000	0.00000000000000000
84	---\n- - 5405\n  - 1838\n- - 5694\n  - 1867\n- - 5708\n  - 2404\n- - 5467\n  - 2415\n	points	#ff0032	80	2		right bottom	47	57	2017-12-31 04:50:21.895843	2017-12-31 04:50:21.895843	0.00000000000000000	0.00000000000000000
85	---\n- - 800\n  - 2373\n- - 1021\n  - 2408\n- - 1203\n  - 3544\n- - 745\n  - 3194\n	points	#ff0032	80	2		right bottom	57	47	2017-12-31 04:51:01.202179	2017-12-31 04:51:01.202179	0.00000000000000000	0.00000000000000000
86	---\n- - 4118\n  - 1915\n- - 4654\n  - 1878\n- - 4720\n  - 3063\n- - 4194\n  - 3081\n	points	#ff0032	80	2		right bottom	57	58	2017-12-31 04:53:04.046522	2017-12-31 04:53:04.046522	0.00000000000000000	0.00000000000000000
87	---\n- - 754\n  - 2472\n- - 793\n  - 2465\n- - 794\n  - 2546\n- - 757\n  - 2557\n	points	#ff0032	80	2		right bottom	58	59	2017-12-31 04:54:30.858852	2017-12-31 04:54:30.858852	0.00000000000000000	0.00000000000000000
88	---\n- - 2931\n  - 2466\n- - 2974\n  - 2462\n- - 2976\n  - 2533\n- - 2938\n  - 2537\n	points	#ff0032	80	2		right bottom	59	58	2017-12-31 04:54:57.856322	2017-12-31 04:54:57.856322	0.00000000000000000	0.00000000000000000
89	---\n- - 831\n  - 1931\n- - 1106\n  - 1964\n- - 1187\n  - 2979\n- - 937\n  - 3156\n	points	#ff0032	80	2		right bottom	58	57	2017-12-31 04:55:15.005974	2017-12-31 04:55:15.005974	0.00000000000000000	0.00000000000000000
90	---\n- - 3188\n  - 1635\n- - 3812\n  - 1784\n- - 3899\n  - 3380\n- - 3199\n  - 3789\n	points	#ff0032	80	2		right bottom	57	60	2017-12-31 04:57:03.22257	2017-12-31 04:57:03.22257	0.00000000000000000	0.00000000000000000
91	---\n- - 2291\n  - 2508\n- - 2308\n  - 2523\n- - 2293\n  - 2535\n- - 2276\n  - 2520\n	points	#ff0032	80	2		right bottom	60	61	2017-12-31 04:58:55.599376	2017-12-31 04:58:55.599376	0.00000000000000000	0.00000000000000000
92	---\n- - 147\n  - 1671\n- - 2022\n  - 1749\n- - 1877\n  - 3606\n- - 102\n  - 3929\n	points	#ff0032	80	2		right bottom	61	60	2017-12-31 04:59:20.105936	2017-12-31 04:59:20.105936	0.00000000000000000	0.00000000000000000
93	---\n- - 6827\n  - 3006\n- - 6771\n  - 3032\n- - 6802\n  - 3073\n- - 6844\n  - 3045\n	points	#ff0032	80	2		right bottom	61	62	2017-12-31 05:00:47.519427	2017-12-31 05:00:47.519427	0.00000000000000000	0.00000000000000000
94	---\n- - 2906\n  - 1722\n- - 3162\n  - 1728\n- - 3127\n  - 1567\n- - 2893\n  - 1556\n	points	#ff0032	80	2		right bottom	62	63	2017-12-31 05:03:34.364776	2017-12-31 05:03:34.364776	0.00000000000000000	0.00000000000000000
95	---\n- - 12115\n  - 1951\n- - 12056\n  - 1797\n- - 11744\n  - 1794\n- - 11733\n  - 1987\n	points	#ff0032	80	2		right bottom	63	62	2017-12-31 05:03:57.126308	2017-12-31 05:03:57.126308	0.00000000000000000	0.00000000000000000
96	---\n- - 10482\n  - 141\n- - 1056\n  - -2\n- - 1178\n  - 3158\n- - 10357\n  - 3155\n	points	#ff0032	80	2		right bottom	62	61	2017-12-31 05:04:34.324738	2017-12-31 05:04:34.324738	0.00000000000000000	0.00000000000000000
97	---\n- - 872\n  - 1896\n- - 1032\n  - 1960\n- - 1007\n  - 2834\n- - 851\n  - 2993\n	points	#ff0032	80	2		right bottom	60	57	2017-12-31 05:04:58.126327	2017-12-31 05:04:58.126327	0.00000000000000000	0.00000000000000000
98	---\n- - 5721\n  - 1763\n- - 7303\n  - 1515\n- - 7916\n  - 3965\n- - 5768\n  - 3848\n	points	#ff0032	80	2		right bottom	57	64	2017-12-31 05:06:38.982198	2017-12-31 05:06:38.982198	0.00000000000000000	0.00000000000000000
99	---\n- - 7791\n  - 1632\n- - 53\n  - 1662\n- - 24\n  - 3596\n- - 7723\n  - 3635\n	points	#ff0032	80	2		right bottom	64	57	2017-12-31 05:07:03.406972	2017-12-31 05:07:03.406972	0.00000000000000000	0.00000000000000000
100	---\n- - 1633\n  - 2973\n- - 2053\n  - 2743\n- - 2198\n  - 2741\n- - 2232\n  - 3291\n- - 1652\n  - 3174\n	points	#ff0032	80	2		right bottom	47	65	2017-12-31 05:09:27.603221	2017-12-31 05:09:27.603221	0.00000000000000000	0.00000000000000000
101	---\n- - 3254\n  - 1996\n- - 3641\n  - 1971\n- - 3647\n  - 2724\n- - 3240\n  - 2760\n	points	#ff0032	80	2		right bottom	65	47	2017-12-31 05:09:51.594302	2017-12-31 05:09:51.594302	0.00000000000000000	0.00000000000000000
103	---\n- - 1666\n  - 2015\n- - 1796\n  - 2039\n- - 1808\n  - 2912\n- - 1701\n  - 3080\n	points	#ff0032	80	2		right bottom	65	67	2017-12-31 05:13:28.769674	2017-12-31 05:13:28.769674	0.00000000000000000	0.00000000000000000
104	---\n- - 4593\n  - 2864\n- - 4837\n  - 2855\n- - 4864\n  - 3079\n- - 4563\n  - 3084\n	points	#ff0032	80	2		right bottom	67	68	2017-12-31 05:16:40.722024	2017-12-31 05:16:40.722024	0.00000000000000000	0.00000000000000000
105	---\n- - 5464\n  - 3065\n- - 5741\n  - 3029\n- - 5722\n  - 2914\n- - 5443\n  - 2957\n	points	#ff0032	80	2		right bottom	68	67	2017-12-31 05:17:03.142033	2017-12-31 05:17:03.142033	0.00000000000000000	0.00000000000000000
106	---\n- - 1421\n  - 1828\n- - 1973\n  - 1709\n- - 2150\n  - 3681\n- - 1291\n  - 3514\n	points	#ff0032	80	2		right bottom	67	69	2017-12-31 05:19:19.015537	2017-12-31 05:19:19.015537	0.00000000000000000	0.00000000000000000
107	---\n- - 384\n  - 1909\n- - 769\n  - 1957\n- - 644\n  - 2761\n- - 273\n  - 2710\n	points	#ff0032	80	2		right bottom	69	67	2017-12-31 05:19:39.097635	2017-12-31 05:19:39.097635	0.00000000000000000	0.00000000000000000
108	---\n- - 2350\n  - 2764\n- - 2359\n  - 2963\n- - 2722\n  - 2919\n- - 2652\n  - 2715\n	points	#ff0032	80	2		right bottom	69	70	2017-12-31 05:21:38.752578	2017-12-31 05:21:38.752578	0.00000000000000000	0.00000000000000000
109	---\n- - 4153\n  - 2693\n- - 4572\n  - 2696\n- - 4542\n  - 2600\n- - 4192\n  - 2594\n	points	#ff0032	80	2		right bottom	70	69	2017-12-31 05:21:54.424047	2017-12-31 05:21:54.424047	0.00000000000000000	0.00000000000000000
110	---\n- - 4971\n  - 1957\n- - 5446\n  - 1789\n- - 5459\n  - 3691\n- - 4970\n  - 3397\n	points	#ff0032	80	2		right bottom	70	71	2017-12-31 05:23:25.437466	2017-12-31 05:23:25.437466	0.00000000000000000	0.00000000000000000
111	---\n- - 1081\n  - 1980\n- - 1600\n  - 1978\n- - 1623\n  - 3079\n- - 1134\n  - 3082\n	points	#ff0032	80	2		right bottom	71	70	2017-12-31 05:23:49.375731	2017-12-31 05:23:49.375731	0.00000000000000000	0.00000000000000000
112	---\n- - 2122\n  - 1980\n- - 2517\n  - 2000\n- - 2494\n  - 2890\n- - 2075\n  - 2867\n	points	#ff0032	80	2		right bottom	70	72	2017-12-31 05:25:40.162361	2017-12-31 05:25:40.162361	0.00000000000000000	0.00000000000000000
113	---\n- - 422\n  - 1828\n- - 385\n  - 2014\n- - 345\n  - 2009\n- - 305\n  - 2084\n- - 261\n  - 2097\n- - 243\n  - 2050\n- - 177\n  - 2066\n- - 179\n  - 2410\n- - 429\n  - 2410\n	points	#ff0032	80	2		right bottom	72	70	2017-12-31 05:26:17.352039	2017-12-31 05:26:17.352039	0.00000000000000000	0.00000000000000000
114	---\n- - 4296\n  - 1730\n- - 3284\n  - 1909\n- - 3281\n  - 2749\n- - 4298\n  - 3181\n	points	#ff0032	80	2		right bottom	72	35	2017-12-31 05:26:42.787401	2017-12-31 05:26:42.787401	0.00000000000000000	0.00000000000000000
115	---\n- - 5407\n  - 1969\n- - 5212\n  - 2049\n- - 5285\n  - 2061\n- - 5299\n  - 2102\n- - 5346\n  - 2119\n- - 5441\n  - 2120\n- - 5617\n  - 2203\n- - 5627\n  - 2509\n- - 5149\n  - 2662\n- - 5143\n  - 1958\n	points	#ff0032	80	2		right bottom	35	72	2017-12-31 05:27:19.1422	2017-12-31 05:27:19.1422	0.00000000000000000	0.00000000000000000
116	---\n- - 6053\n  - 1665\n- - 7307\n  - 1704\n- - 7264\n  - 3746\n- - 6061\n  - 3767\n	points	#ff0032	80	2		right bottom	70	73	2017-12-31 05:29:02.816378	2017-12-31 05:29:02.816378	0.00000000000000000	0.00000000000000000
117	---\n- - 1954\n  - 2011\n- - 2140\n  - 2039\n- - 2103\n  - 2753\n- - 1935\n  - 2870\n	points	#ff0032	80	2		right bottom	73	70	2017-12-31 05:29:30.058873	2017-12-31 05:29:30.058873	0.00000000000000000	0.00000000000000000
118	---\n- - 4383\n  - 3134\n- - 4893\n  - 3139\n- - 5028\n  - 3562\n- - 4086\n  - 3525\n	points	#ff0032	80	2		right bottom	69	47	2017-12-31 05:30:02.734975	2017-12-31 05:30:02.734975	0.00000000000000000	0.00000000000000000
119	---\n- - 3605\n  - 2003\n- - 4119\n  - 1864\n- - 4212\n  - 3329\n- - 3607\n  - 3123\n	points	#ff0032	80	2		right bottom	47	70	2017-12-31 05:30:24.600752	2017-12-31 05:30:24.600752	0.00000000000000000	0.00000000000000000
120	---\n- - 4433\n  - 2005\n- - 4789\n  - 2030\n- - 4725\n  - 2746\n- - 4414\n  - 2715\n	points	#ff0032	80	2		right bottom	69	44	2017-12-31 05:30:45.595558	2017-12-31 05:30:45.595558	0.00000000000000000	0.00000000000000000
121	---\n- - 1914\n  - 1950\n- - 2116\n  - 1917\n- - 2119\n  - 2503\n- - 1948\n  - 2461\n	points	#ff0032	80	2		right bottom	48	70	2017-12-31 05:31:26.68598	2017-12-31 05:31:26.68598	0.00000000000000000	0.00000000000000000
122	---\n- - 1370\n  - 2685\n- - 1493\n  - 2577\n- - 1372\n  - 2554\n	points	#ff0032	80	2		right bottom	48	65	2017-12-31 05:31:41.138099	2017-12-31 05:31:41.138099	0.00000000000000000	0.00000000000000000
123	---\n- - 4714\n  - 2037\n- - 4717\n  - 2157\n- - 4850\n  - 2152\n- - 4850\n  - 2041\n- - 4914\n  - 2029\n- - 4785\n  - 1931\n- - 4669\n  - 2014\n	points	#ff0032	80	2		right bottom	40	74	2017-12-31 05:35:24.587567	2017-12-31 05:35:24.587567	0.00000000000000000	0.00000000000000000
124	---\n- - 5140\n  - 2024\n- - 5310\n  - 2013\n- - 5309\n  - 1928\n- - 5128\n  - 1928\n	points	#ff0032	80	2		right bottom	74	65	2017-12-31 05:35:47.215789	2017-12-31 05:35:47.215789	0.00000000000000000	0.00000000000000000
125	---\n- - 5996\n  - 1908\n- - 6182\n  - 1916\n- - 6179\n  - 2255\n- - 5964\n  - 2262\n	points	#ff0032	80	2		right bottom	74	35	2017-12-31 05:36:02.598613	2017-12-31 05:36:02.598613	0.00000000000000000	0.00000000000000000
126	---\n- - 7056\n  - 1995\n- - 7054\n  - 2201\n- - 7311\n  - 2207\n- - 7303\n  - 1998\n	points	#ff0032	80	2		right bottom	74	39	2017-12-31 05:36:13.628856	2017-12-31 05:36:13.628856	0.00000000000000000	0.00000000000000000
127	---\n- - 4110\n  - 2325\n- - 4058\n  - 2418\n- - 4230\n  - 2448\n- - 4272\n  - 2336\n- - 4346\n  - 2332\n- - 4327\n  - 2245\n- - 4058\n  - 2294\n	points	#ff0032	80	2		right bottom	74	40	2017-12-31 05:36:59.092035	2017-12-31 05:36:59.092035	0.00000000000000000	0.00000000000000000
128	---\n- - 5911\n  - 2401\n- - 5910\n  - 2468\n- - 6001\n  - 2468\n- - 5997\n  - 2380\n	points	#ff0032	80	2		right bottom	65	74	2017-12-31 05:37:20.553433	2017-12-31 05:37:20.553433	0.00000000000000000	0.00000000000000000
129	---\n- - 7208\n  - 2337\n- - 7207\n  - 2394\n- - 7286\n  - 2391\n- - 7278\n  - 2330\n	points	#ff0032	80	2		right bottom	51	40	2017-12-31 05:38:51.894128	2017-12-31 05:38:51.894128	0.00000000000000000	0.00000000000000000
130	---\n- - 4788\n  - 1911\n- - 4929\n  - 1899\n- - 4927\n  - 1993\n- - 4786\n  - 2001\n	points	#ff0032	80	2		right bottom	74	68	2017-12-31 05:42:31.155289	2017-12-31 05:42:31.155289	0.00000000000000000	0.00000000000000000
132	---\n- - 4305\n  - 1420\n- - 4456\n  - 1419\n- - 4458\n  - 1504\n- - 4303\n  - 1504\n	points	#ff0032	80	2		right bottom	35	63	2018-01-04 06:29:59.806459	2018-01-04 06:29:59.806459	0.00000000000000000	0.00000000000000000
133	---\n- - 6189\n  - 1105\n- - 6436\n  - 1077\n- - 6630\n  - 1068\n- - 6733\n  - 1086\n- - 6730\n  - 1431\n- - 6188\n  - 1448\n	points	#ff0032	80	2		right bottom	63	35	2018-01-04 06:31:17.211073	2018-01-04 06:31:17.211073	0.00000000000000000	0.00000000000000000
137	---\n- - 3070\n  - 1873\n- - 3511\n  - 1977\n- - 3471\n  - 3307\n- - 3073\n  - 3564\n	points	#ff0032	80	2	\N	right bottom	67	65	2018-01-05 22:10:52.91758	2018-01-05 22:10:52.91758	0.00000000000000000	0.00000000000000000
157	---\n- - 10951\n  - 828\n- - -1478\n  - 818\n- - -1255\n  - 3300\n- - 10674\n  - 3304\n	points	#ff0032	80	2	\N	right bottom	5	4	2018-01-23 20:44:51.967446	2018-01-23 20:44:51.967446	0.00000000000000000	0.00000000000000000
161	---\n- - 2913\n  - 1696\n- - 2939\n  - 1695\n- - 2964\n  - 1700\n- - 2964\n  - 1708\n- - 2955\n  - 1714\n- - 2935\n  - 1720\n- - 2914\n  - 1724\n- - 2898\n  - 1721\n- - 2889\n  - 1718\n- - 2883\n  - 1711\n- - 2886\n  - 1700\n- - 2897\n  - 1693\n	points	#ff0032	80	2	Go to Tenaya Lake	right bottom	32	117	2018-01-24 03:55:51.441325	2018-01-24 03:55:51.441325	0.00000000000000000	0.00000000000000000
162	---\n- - 4965\n  - 1838\n- - 4989\n  - 1830\n- - 5003\n  - 1830\n- - 5017\n  - 1824\n- - 5027\n  - 1834\n- - 5035\n  - 1838\n- - 5044\n  - 1841\n- - 5052\n  - 1846\n- - 5060\n  - 1853\n- - 5066\n  - 1857\n- - 5060\n  - 1863\n- - 5051\n  - 1862\n- - 5040\n  - 1862\n- - 5015\n  - 1861\n	points	#ff0032	80	2	Go to the mountain top	right bottom	117	32	2018-01-24 03:56:45.754554	2018-01-24 03:56:45.754554	0.00000000000000000	0.00000000000000000
165	---\n- - 974\n  - 688\n- - 1072\n  - 690\n- - 1077\n  - 831\n- - 984\n  - 851\n	points	#ff0032	80	2	Go to the marina	right bottom	121	122	2018-01-24 20:42:33.583413	2018-01-24 20:42:33.583413	0.00000000000000000	0.00000000000000000
166	---\n- - 8313\n  - 1017\n- - 8407\n  - 1020\n- - 8488\n  - 935\n- - 8707\n  - 898\n- - 9034\n  - 896\n- - 9271\n  - 1003\n- - 9439\n  - 1061\n- - 9627\n  - 1154\n- - 9921\n  - 1272\n- - 10144\n  - 1358\n- - 9790\n  - 2024\n- - 8526\n  - 1661\n- - 8286\n  - 1453\n- - 8262\n  - 1107\n	points	#ff0032	80	2	Go to the kitchen	right bottom	122	121	2018-01-24 20:43:19.943718	2018-01-24 20:43:19.943718	0.00000000000000000	0.00000000000000000
167	---\n- - 1968\n  - 1113\n- - 2069\n  - 1124\n- - 2061\n  - 1263\n- - 1953\n  - 1253\n	points	#ff0032	80	2	ok	right bottom	123	124	2018-01-25 02:47:14.538792	2018-01-25 02:47:14.538792	0.00000000000000000	0.00000000000000000
168	---\n- - 1031\n  - 310\n- - 1038\n  - 387\n- - 1235\n  - 365\n- - 1070\n  - 294\n	points	#ff0032	80	2	onem	right bottom	124	123	2018-01-25 02:48:27.913612	2018-01-25 02:48:27.913612	0.00000000000000000	0.00000000000000000
169	---\n- - 1513\n  - 1028\n- - 2069\n  - 986\n- - 2071\n  - 1747\n- - 2023\n  - 1752\n- - 2028\n  - 1828\n- - 2039\n  - 1852\n- - 2045\n  - 2180\n- - 1483\n  - 2112\n	points	#ff0032	80	2	Go to the livingroom	right bottom	131	133	2018-01-25 20:41:00.083773	2018-01-25 20:41:00.083773	0.00000000000000000	0.00000000000000000
170	---\n- - 516\n  - 1257\n- - 665\n  - 1257\n- - 677\n  - 1594\n- - 536\n  - 1601\n	points	#ff0032	80	2	Go to the backyard	right bottom	131	138	2018-01-25 20:41:36.764676	2018-01-25 20:41:36.764676	0.00000000000000000	0.00000000000000000
171	---\n- - 5183\n  - 1337\n- - 14\n  - 1390\n- - 10\n  - 1590\n- - 5189\n  - 1565\n	points	#ff0032	80	2	Go inside Dad's shed	right bottom	138	139	2018-01-25 20:42:13.855371	2018-01-25 20:42:13.855371	0.00000000000000000	0.00000000000000000
172	---\n- - 2920\n  - 1161\n- - 2906\n  - 2078\n- - 2157\n  - 1951\n	points	#ff0032	80	2	Go back outside	right bottom	139	138	2018-01-25 20:46:31.060987	2018-01-25 20:46:31.060987	0.00000000000000000	0.00000000000000000
173	---\n- - 3036\n  - 1333\n- - 3036\n  - 1300\n- - 3086\n  - 1340\n- - 3040\n  - 1390\n- - 3034\n  - 1352\n- - 2972\n  - 1354\n- - 2972\n  - 1328\n	points	#ff0032	80	2	Go back inside	right bottom	138	132	2018-01-25 20:47:02.651731	2018-01-25 20:47:02.651731	0.00000000000000000	0.00000000000000000
174	---\n- - 5031\n  - 1163\n- - 5193\n  - 1114\n- - 5188\n  - 1882\n- - 5043\n  - 1779\n	points	#ff0032	80	2	Go into the basement	right bottom	132	134	2018-01-25 20:47:27.996599	2018-01-25 20:47:27.996599	0.00000000000000000	0.00000000000000000
175	---\n- - 1563\n  - 1137\n- - 1793\n  - 1136\n- - 1802\n  - 1991\n- - 1567\n  - 1976\n	points	#ff0032	80	2	Laundry	right bottom	134	135	2018-01-25 20:48:01.114288	2018-01-25 20:48:01.114288	0.00000000000000000	0.00000000000000000
176	---\n- - 1240\n  - 1216\n- - 1512\n  - 1223\n- - 1509\n  - 1813\n- - 1219\n  - 1796\n	points	#ff0032	80	2	\N	right bottom	135	134	2018-01-25 20:48:32.146433	2018-01-25 20:48:32.146433	0.00000000000000000	0.00000000000000000
178	---\n- - 2848\n  - 1282\n- - 2923\n  - 1216\n- - 2922\n  - 1269\n- - 3046\n  - 1262\n- - 3045\n  - 1332\n- - 2922\n  - 1329\n- - 2921\n  - 1380\n	points	#ff0032	80	2	\N	right bottom	134	132	2018-01-25 20:49:31.886247	2018-01-25 20:49:31.886247	0.00000000000000000	0.00000000000000000
179	---\n- - 4803\n  - 1150\n- - 4800\n  - 1221\n- - 4855\n  - 1275\n- - 4904\n  - 1345\n- - 4917\n  - 1390\n- - 4913\n  - 1405\n- - 4945\n  - 1488\n- - 4947\n  - 1557\n- - 4945\n  - 1630\n- - 4951\n  - 1679\n- - 4973\n  - 1738\n- - 5002\n  - 1774\n- - 5008\n  - 1775\n- - 5003\n  - 1164\n	points	#ff0032	80	2	\N	right bottom	132	138	2018-01-25 20:50:28.320807	2018-01-25 20:50:28.320807	0.00000000000000000	0.00000000000000000
180	---\n- - 57\n  - 1140\n- - 262\n  - 1122\n- - 257\n  - 1859\n- - 212\n  - 1855\n- - 176\n  - 1778\n- - 94\n  - 1761\n	points	#ff0032	80	2	\N	right bottom	132	133	2018-01-25 20:50:55.272024	2018-01-25 20:50:55.272024	0.00000000000000000	0.00000000000000000
181	---\n- - 5309\n  - 1095\n- - 349\n  - 1056\n- - 347\n  - 1903\n- - 264\n  - 1912\n- - 265\n  - 2008\n- - 5360\n  - 1951\n	points	#ff0032	80	2	\N	right bottom	133	131	2018-01-25 20:51:23.609088	2018-01-25 20:51:23.609088	0.00000000000000000	0.00000000000000000
182	---\n- - 1236\n  - 1158\n- - 1369\n  - 1192\n- - 1378\n  - 1731\n- - 1263\n  - 1798\n	points	#ff0032	80	2	\N	right bottom	133	132	2018-01-25 20:51:47.641913	2018-01-25 20:51:47.641913	0.00000000000000000	0.00000000000000000
183	---\n- - 1637\n  - 1860\n- - 1703\n  - 1906\n- - 1640\n  - 1908\n- - 1647\n  - 1980\n- - 1584\n  - 1978\n- - 1583\n  - 1914\n- - 1533\n  - 1912\n	points	#ff0032	80	2	\N	right bottom	132	131	2018-01-25 20:52:59.259428	2018-01-25 20:52:59.259428	0.00000000000000000	0.00000000000000000
184	---\n- - 1580\n  - 1171\n- - 1671\n  - 1155\n- - 1667\n  - 1186\n- - 1718\n  - 1214\n- - 1710\n  - 1249\n- - 1638\n  - 1211\n- - 1626\n  - 1245\n	points	#ff0032	80	2	\N	right bottom	133	136	2018-01-25 20:53:47.520952	2018-01-25 20:53:47.520952	0.00000000000000000	0.00000000000000000
185	---\n- - 4588\n  - 1162\n- - 4742\n  - 1105\n- - 4743\n  - 1853\n- - 4615\n  - 1798\n	points	#ff0032	80	2	Robyn's room	right bottom	136	137	2018-01-25 20:54:28.28675	2018-01-25 20:54:28.28675	0.00000000000000000	0.00000000000000000
186	---\n- - 3281\n  - 1108\n- - 3638\n  - 1092\n- - 3618\n  - 1972\n- - 3280\n  - 1920\n	points	#ff0032	80	2	\N	right bottom	137	136	2018-01-25 20:54:53.805194	2018-01-25 20:54:53.805194	0.00000000000000000	0.00000000000000000
187	---\n- - 3912\n  - 1778\n- - 4143\n  - 1790\n- - 4097\n  - 2124\n- - 3880\n  - 2099\n	points	#ff0032	80	2	\N	right bottom	136	133	2018-01-25 20:55:08.350825	2018-01-25 20:55:08.350825	0.00000000000000000	0.00000000000000000
188	---\n- - 393\n  - 1862\n- - 489\n  - 1898\n- - 418\n  - 1919\n- - 469\n  - 2025\n- - 372\n  - 2051\n- - 329\n  - 1932\n- - 273\n  - 1943\n	points	#ff0032	80	2	\N	right bottom	131	132	2018-01-25 20:55:49.97968	2018-01-25 20:55:49.97968	0.00000000000000000	0.00000000000000000
191	---\n- - 3188\n  - 1499\n- - 3340\n  - 1479\n- - 3345\n  - 1846\n- - 3195\n  - 1841\n	points	#ff0032	80	2	\N	right bottom	141	154	2018-02-06 21:41:12.540752	2018-02-06 21:41:12.540752	0.00000000000000000	0.00000000000000000
192	---\n- - 3269\n  - 1173\n- - 3930\n  - 1083\n- - 3953\n  - 2415\n- - 3894\n  - 2422\n- - 3896\n  - 2588\n- - 3351\n  - 2541\n	points	#ff0032	80	2	\N	right bottom	154	155	2018-02-06 21:41:52.207596	2018-02-06 21:41:52.207596	0.00000000000000000	0.00000000000000000
193	---\n- - 5063\n  - 1371\n- - 5199\n  - 1443\n- - 5221\n  - 2130\n- - 5179\n  - 1989\n- - 5144\n  - 2027\n- - 5121\n  - 1931\n- - 5057\n  - 1990\n	points	#ff0032	80	2	\N	right bottom	154	145	2018-02-06 21:42:13.439395	2018-02-06 21:42:13.439395	0.00000000000000000	0.00000000000000000
194	---\n- - 4253\n  - 2369\n- - 4137\n  - 2365\n- - 4307\n  - 2282\n- - 4386\n  - 2360\n- - 4291\n  - 2371\n- - 4287\n  - 2477\n- - 4214\n  - 2471\n	points	#ff0032	80	2	\N	right bottom	145	155	2018-02-06 21:42:44.83064	2018-02-06 21:42:44.83064	0.00000000000000000	0.00000000000000000
195	---\n- - 2131\n  - 2535\n- - 2394\n  - 2515\n- - 2330\n  - 2367\n- - 2103\n  - 2383\n	points	#ff0032	80	2	\N	right bottom	155	145	2018-02-06 21:43:08.890395	2018-02-06 21:43:08.890395	0.00000000000000000	0.00000000000000000
196	---\n- - 3867\n  - 1165\n- - 4471\n  - 1188\n- - 4453\n  - 2505\n- - 3880\n  - 2550\n	points	#ff0032	80	2	\N	right bottom	155	154	2018-02-06 21:43:35.380054	2018-02-06 21:43:35.380054	0.00000000000000000	0.00000000000000000
197	---\n- - 2252\n  - 1531\n- - 2250\n  - 1577\n- - 2295\n  - 1638\n- - 2361\n  - 1753\n- - 2356\n  - 1772\n- - 2376\n  - 1790\n- - 2348\n  - 1807\n- - 2348\n  - 1853\n- - 2322\n  - 1863\n- - 2320\n  - 2052\n- - 2474\n  - 2043\n- - 2460\n  - 2007\n- - 2476\n  - 1986\n- - 2466\n  - 1530\n	points	#ff0032	80	2	\N	right bottom	155	142	2018-02-06 21:44:23.326799	2018-02-06 21:44:23.326799	0.00000000000000000	0.00000000000000000
198	---\n- - 1670\n  - 1435\n- - 1842\n  - 1342\n- - 1847\n  - 2373\n- - 1687\n  - 2235\n	points	#ff0032	80	2	\N	right bottom	145	147	2018-02-06 21:45:08.351969	2018-02-06 21:45:08.351969	0.00000000000000000	0.00000000000000000
199	---\n- - 2231\n  - 1386\n- - 2242\n  - 1865\n- - 2307\n  - 1852\n- - 2339\n  - 2244\n- - 2287\n  - 2294\n- - 2409\n  - 2334\n- - 2400\n  - 1361\n	points	#ff0032	80	2	\N	right bottom	145	154	2018-02-06 21:46:06.485858	2018-02-06 21:46:06.485858	0.00000000000000000	0.00000000000000000
200	---\n- - 3354\n  - 1267\n- - 3714\n  - 1277\n- - 3720\n  - 2438\n- - 3382\n  - 2449\n	points	#ff0032	80	2	\N	right bottom	147	148	2018-02-06 21:46:44.429491	2018-02-06 21:46:44.429491	0.00000000000000000	0.00000000000000000
201	---\n- - 1458\n  - 1454\n- - 1637\n  - 1448\n- - 1695\n  - 1486\n- - 1662\n  - 1530\n- - 1647\n  - 1540\n- - 1652\n  - 1552\n- - 1667\n  - 1557\n- - 1680\n  - 1570\n- - 1699\n  - 1582\n- - 1708\n  - 1586\n- - 1713\n  - 1662\n- - 1658\n  - 1744\n- - 1633\n  - 1772\n- - 1648\n  - 1805\n- - 1581\n  - 2086\n- - 1588\n  - 2141\n- - 1614\n  - 2159\n- - 1634\n  - 2157\n- - 1712\n  - 2164\n- - 1672\n  - 2206\n- - 1435\n  - 2180\n	points	#ff0032	80	2	\N	right bottom	148	147	2018-02-06 21:48:08.608762	2018-02-06 21:48:08.608762	0.00000000000000000	0.00000000000000000
202	---\n- - 5272\n  - 1649\n- - 5183\n  - 1715\n- - 5081\n  - 1570\n- - 5328\n  - 1572\n- - 5287\n  - 1640\n- - 5411\n  - 1709\n- - 5379\n  - 1752\n	points	#ff0032	80	2	\N	right bottom	147	145	2018-02-06 21:59:37.091431	2018-02-06 21:59:37.091431	0.00000000000000000	0.00000000000000000
203	---\n- - 5943\n  - 1503\n- - 5920\n  - 1561\n- - 5857\n  - 1456\n- - 5980\n  - 1412\n- - 5965\n  - 1472\n- - 6057\n  - 1499\n- - 6040\n  - 1539\n	points	#ff0032	80	2	\N	right bottom	154	149	2018-02-06 22:00:50.399739	2018-02-06 22:00:50.399739	0.00000000000000000	0.00000000000000000
204	---\n- - 3838\n  - 1205\n- - 4171\n  - 1278\n- - 4193\n  - 2360\n- - 3858\n  - 2452\n	points	#ff0032	80	2	\N	right bottom	149	150	2018-02-06 22:01:39.539325	2018-02-06 22:01:39.539325	0.00000000000000000	0.00000000000000000
205	---\n- - 2662\n  - 694\n- - 3100\n  - 1103\n- - 3074\n  - 2621\n- - 2667\n  - 2881\n	points	#ff0032	80	2	\N	right bottom	149	151	2018-02-06 22:01:59.626612	2018-02-06 22:01:59.626612	0.00000000000000000	0.00000000000000000
206	---\n- - 333\n  - 1165\n- - 630\n  - 823\n- - 578\n  - 2833\n- - 334\n  - 2525\n	points	#ff0032	80	2	\N	right bottom	149	152	2018-02-06 22:02:20.5006	2018-02-06 22:02:20.5006	0.00000000000000000	0.00000000000000000
207	---\n- - 6634\n  - 1287\n- - 166\n  - 1296\n- - 162\n  - 2342\n- - 6593\n  - 2327\n	points	#ff0032	80	2	\N	right bottom	149	153	2018-02-06 22:02:30.095061	2018-02-06 22:02:30.095061	0.00000000000000000	0.00000000000000000
208	---\n- - 263\n  - 1131\n- - 794\n  - 1133\n- - 778\n  - 2591\n- - 201\n  - 2584\n	points	#ff0032	80	2	\N	right bottom	153	149	2018-02-06 22:02:55.916266	2018-02-06 22:02:55.916266	0.00000000000000000	0.00000000000000000
209	---\n- - 118\n  - 1282\n- - 560\n  - 1248\n- - 538\n  - 2435\n- - 108\n  - 2377\n	points	#ff0032	80	2	\N	right bottom	152	149	2018-02-06 22:03:17.796128	2018-02-06 22:03:17.796128	0.00000000000000000	0.00000000000000000
210	---\n- - 2548\n  - 940\n- - 2580\n  - 925\n- - 3220\n  - 1123\n- - 3237\n  - 2582\n- - 2629\n  - 2808\n	points	#ff0032	80	2	\N	right bottom	151	149	2018-02-06 22:03:44.665147	2018-02-06 22:03:44.665147	0.00000000000000000	0.00000000000000000
211	---\n- - 5482\n  - 2032\n- - 5357\n  - 2112\n- - 5705\n  - 2154\n- - 5672\n  - 1932\n- - 5555\n  - 1969\n- - 5389\n  - 1817\n- - 5287\n  - 1891\n	points	#ff0032	80	2	\N	right bottom	149	154	2018-02-06 22:04:51.055625	2018-02-06 22:04:51.055625	0.00000000000000000	0.00000000000000000
212	---\n- - 4021\n  - 2034\n- - 3932\n  - 2041\n- - 4025\n  - 1947\n- - 4121\n  - 2016\n- - 4048\n  - 2032\n- - 4060\n  - 2122\n- - 4011\n  - 2124\n	points	#ff0032	80	2	\N	right bottom	141	142	2018-02-06 22:06:59.829411	2018-02-06 22:06:59.829411	0.00000000000000000	0.00000000000000000
214	---\n- - 3407\n  - 1689\n- - 3454\n  - 1632\n- - 3487\n  - 1616\n- - 3529\n  - 1635\n- - 3569\n  - 1676\n- - 3575\n  - 1904\n- - 3398\n  - 1892\n	points	#ff0032	80	2	\N	right bottom	142	141	2018-02-06 22:07:45.837316	2018-02-06 22:07:45.837316	0.00000000000000000	0.00000000000000000
312	---\n- - 2212\n  - 1470\n- - 2225\n  - 1594\n- - 2528\n  - 1524\n- - 2474\n  - 1424\n	points	#ff0032	80	2	\N	right bottom	220	222	2021-11-27 23:13:42.051361	2021-11-27 23:13:42.051361	0.00000000000000000	0.00000000000000000
215	---\n- - 3782\n  - 1676\n- - 3782\n  - 1634\n- - 3847\n  - 1679\n- - 3789\n  - 1751\n- - 3777\n  - 1705\n- - 3723\n  - 1713\n- - 3722\n  - 1682\n	points	#ff0032	80	2	\N	right bottom	142	145	2018-02-06 22:08:23.861319	2018-02-06 22:08:23.861319	0.00000000000000000	0.00000000000000000
216	---\n- - 6697\n  - 1656\n- - 71\n  - 1749\n- - 50\n  - 1985\n- - 6775\n  - 1978\n- - 6726\n  - 1940\n- - 6687\n  - 1861\n	points	#ff0032	80	2	\N	right bottom	142	143	2018-02-06 22:23:50.403362	2018-02-06 22:23:50.403362	0.00000000000000000	0.00000000000000000
217	---\n- - 691\n  - 2359\n- - 956\n  - 2343\n- - 1030\n  - 2572\n- - 727\n  - 2577\n	points	#ff0032	80	2	\N	right bottom	143	144	2018-02-06 22:24:07.956676	2018-02-06 22:24:07.956676	0.00000000000000000	0.00000000000000000
218	---\n- - 4569\n  - 1267\n- - 3672\n  - 1486\n- - 3682\n  - 2456\n- - 4659\n  - 2507\n	points	#ff0032	80	2	\N	right bottom	143	142	2018-02-06 22:24:25.335249	2018-02-06 22:24:25.335249	0.00000000000000000	0.00000000000000000
219	---\n- - 4866\n  - 2247\n- - 5070\n  - 2258\n- - 5066\n  - 2416\n- - 4818\n  - 2405\n	points	#ff0032	80	2	\N	right bottom	144	143	2018-02-06 22:24:41.233756	2018-02-06 22:24:41.233756	0.00000000000000000	0.00000000000000000
221	---\n- - 1195\n  - 1810\n- - 1131\n  - 1807\n- - 1215\n  - 1741\n- - 1298\n  - 1811\n- - 1233\n  - 1814\n- - 1238\n  - 1890\n- - 1195\n  - 1883\n	points	#ff0032	80	2	\N	right bottom	156	158	2018-02-09 08:48:44.89362	2018-02-09 08:48:44.89362	0.00000000000000000	0.00000000000000000
222	---\n- - 6481\n  - 1796\n- - 6420\n  - 1798\n- - 6516\n  - 1740\n- - 6552\n  - 1797\n- - 6508\n  - 1800\n- - 6497\n  - 1855\n- - 6445\n  - 1845\n	points	#ff0032	80	2	\N	right bottom	157	156	2018-02-09 08:49:20.743551	2018-02-09 08:49:20.743551	0.00000000000000000	0.00000000000000000
223	---\n- - 4657\n  - 1732\n- - 4627\n  - 1733\n- - 4659\n  - 1700\n- - 4691\n  - 1728\n- - 4667\n  - 1733\n- - 4671\n  - 1760\n- - 4649\n  - 1760\n	points	#ff0032	80	2	\N	right bottom	158	156	2018-02-09 08:49:56.204695	2018-02-09 08:49:56.204695	0.00000000000000000	0.00000000000000000
224	---\n- - 438\n  - 1814\n- - 366\n  - 1817\n- - 451\n  - 1722\n- - 511\n  - 1810\n- - 457\n  - 1823\n- - 459\n  - 1906\n- - 406\n  - 1904\n	points	#ff0032	80	2	\N	right bottom	156	157	2018-02-09 08:50:21.891661	2018-02-09 08:50:21.891661	0.00000000000000000	0.00000000000000000
225	---\n- - 2750\n  - 2050\n- - 2994\n  - 2031\n- - 2999\n  - 2522\n- - 2768\n  - 2595\n	points	#ff0032	80	2	\N	right bottom	51	52	2018-03-05 09:50:43.084091	2018-03-05 09:50:43.084091	0.00000000000000000	0.00000000000000000
227	---\n- - 463\n  - 1804\n- - 833\n  - 1818\n- - 924\n  - 2419\n- - 398\n  - 2437\n	points	#ff0032	80	2	To the park!	right bottom	163	164	2018-03-18 06:20:10.19047	2018-03-18 06:20:10.19047	0.00000000000000000	0.00000000000000000
229	---\n- - 3840\n  - 1990\n- - 3865\n  - 1985\n- - 3884\n  - 1981\n- - 3893\n  - 1992\n- - 3896\n  - 2003\n- - 3898\n  - 2026\n- - 3893\n  - 2037\n- - 3880\n  - 2042\n- - 3870\n  - 2044\n- - 3855\n  - 2043\n- - 3845\n  - 2027\n- - 3838\n  - 2017\n- - 3836\n  - 2003\n	points	#ff0032	80	2	Onwards	right bottom	164	165	2018-03-18 06:21:50.028771	2018-03-18 06:21:50.028771	0.00000000000000000	0.00000000000000000
231	---\n- - 6908\n  - 2190\n- - 6827\n  - 2191\n- - 16\n  - 2057\n- - 122\n  - 2167\n- - 41\n  - 2186\n- - 69\n  - 2278\n- - 6906\n  - 2284\n	points	#ff0032	80	2	Get a little closer to those sisters	right bottom	165	166	2018-03-18 06:23:03.402116	2018-03-18 06:23:03.402116	0.00000000000000000	0.00000000000000000
233	---\n- - 1397\n  - 2052\n- - 1308\n  - 2063\n- - 1459\n  - 2174\n- - 1506\n  - 2044\n- - 1438\n  - 2041\n- - 1418\n  - 1962\n- - 1370\n  - 1968\n	points	#ff0032	80	2	Goin' Down!	right bottom	166	168	2018-03-18 06:35:08.783115	2018-03-18 06:35:08.783115	0.00000000000000000	0.00000000000000000
235	---\n- - 269\n  - 2490\n- - 161\n  - 2508\n- - 369\n  - 2584\n- - 398\n  - 2460\n- - 310\n  - 2464\n- - 269\n  - 2383\n- - 210\n  - 2393\n	points	#ff0032	80	2	Go down moar	right bottom	168	169	2018-03-18 06:40:38.164331	2018-03-18 06:40:38.164331	0.00000000000000000	0.00000000000000000
236	---\n- - 5426\n  - 2659\n- - 5305\n  - 2585\n- - 5737\n  - 2447\n- - 5804\n  - 2540\n	points	#ff0032	80	2	Throwin' Duces	right bottom	169	170	2018-03-18 06:42:56.347826	2018-03-18 06:42:56.347826	0.00000000000000000	0.00000000000000000
237	---\n- - 2835\n  - 1932\n- - 2674\n  - 1931\n- - 2909\n  - 2149\n- - 3094\n  - 1932\n- - 2932\n  - 1910\n- - 2914\n  - 1731\n- - 2825\n  - 1734\n	points	#ff0032	80	2	Go down MORE	right bottom	170	171	2018-03-18 06:43:45.05313	2018-03-18 06:43:45.05313	0.00000000000000000	0.00000000000000000
238	---\n- - 6239\n  - 2918\n- - 5827\n  - 2920\n- - 6580\n  - 3154\n- - 6674\n  - 2841\n- - 6349\n  - 2866\n- - 6260\n  - 2626\n- - 6088\n  - 2647\n	points	#ff0032	80	2	Go into the JUNGLE	right bottom	171	172	2018-03-18 06:44:31.287213	2018-03-18 06:44:31.287213	0.00000000000000000	0.00000000000000000
239	---\n- - 1687\n  - 2004\n- - 1515\n  - 2012\n- - 1711\n  - 1865\n- - 1893\n  - 1970\n- - 1773\n  - 1993\n- - 1791\n  - 2202\n- - 1702\n  - 2216\n	points	#ff0032	80	2	Onward	right bottom	172	173	2018-03-18 06:47:31.77802	2018-03-18 06:47:31.77802	0.00000000000000000	0.00000000000000000
240	---\n- - 5743\n  - 1916\n- - 5634\n  - 1918\n- - 5835\n  - 1750\n- - 5932\n  - 1911\n- - 5818\n  - 1923\n- - 5818\n  - 2052\n- - 5736\n  - 2038\n	points	#ff0032	80	2	Onward to the WATERFALL	right bottom	173	174	2018-03-18 06:48:49.292651	2018-03-18 06:48:49.292651	0.00000000000000000	0.00000000000000000
241	---\n- - 2793\n  - 1815\n- - 2656\n  - 1823\n- - 2802\n  - 1599\n- - 3008\n  - 1793\n- - 2850\n  - 1829\n- - 2868\n  - 1980\n- - 2762\n  - 1986\n	points	#ff0032	80	2	Go to the pools	right bottom	174	176	2018-03-18 06:52:00.075867	2018-03-18 06:52:00.075867	0.00000000000000000	0.00000000000000000
242	---\n- - 4871\n  - 1361\n- - 4699\n  - 1365\n- - 4889\n  - 1147\n- - 5058\n  - 1353\n- - 4931\n  - 1357\n- - 4951\n  - 1516\n- - 4835\n  - 1512\n	points	#ff0032	80	2	WORLDS STEEPEST RAILWAY	right bottom	174	175	2018-03-18 06:52:39.048893	2018-03-18 06:52:39.048893	0.00000000000000000	0.00000000000000000
243	---\n- - 2021\n  - 2027\n- - 1893\n  - 2024\n- - 2086\n  - 1840\n- - 2160\n  - 2023\n- - 2075\n  - 2041\n- - 2063\n  - 2204\n- - 1966\n  - 2196\n	points	#ff0032	80	2	Back	right bottom	176	174	2018-03-18 06:53:35.643713	2018-03-18 06:53:35.643713	0.00000000000000000	0.00000000000000000
244	---\n- - 1955\n  - 2088\n- - 1864\n  - 2099\n- - 1935\n  - 1931\n- - 2089\n  - 2062\n- - 2003\n  - 2084\n- - 2039\n  - 2169\n- - 1977\n  - 2174\n	points	#ff0032	80	2	Mineshaft!	right bottom	175	179	2018-03-18 06:59:43.336597	2018-03-18 06:59:43.336597	0.00000000000000000	0.00000000000000000
245	---\n- - 1716\n  - 2085\n- - 1573\n  - 2077\n- - 1771\n  - 1894\n- - 1918\n  - 2062\n- - 1806\n  - 2091\n- - 1805\n  - 2246\n- - 1701\n  - 2231\n	points	#ff0032	80	2	Kissing Trees	right bottom	179	180	2018-03-18 07:00:25.590184	2018-03-18 07:00:25.590184	0.00000000000000000	0.00000000000000000
246	---\n- - 1854\n  - 2150\n- - 1705\n  - 2165\n- - 1868\n  - 1936\n- - 2044\n  - 2103\n- - 1932\n  - 2137\n- - 1948\n  - 2272\n- - 1887\n  - 2281\n	points	#ff0032	80	2	Onwards	right bottom	180	177	2018-03-18 07:02:50.789062	2018-03-18 07:02:50.789062	0.00000000000000000	0.00000000000000000
247	---\n- - 5973\n  - 1363\n- - 5901\n  - 1278\n- - 6177\n  - 1226\n- - 6053\n  - 1477\n- - 5979\n  - 1408\n- - 5864\n  - 1489\n- - 5824\n  - 1434\n	points	#ff0032	80	2	Take off	right bottom	177	178	2018-03-18 07:03:39.710197	2018-03-18 07:03:39.710197	0.00000000000000000	0.00000000000000000
248	---\n- - 21\n  - 1311\n- - 6777\n  - 1324\n- - 51\n  - 1183\n- - 186\n  - 1308\n- - 65\n  - 1314\n- - 78\n  - 1463\n- - 9\n  - 1459\n	points	#ff0032	80	2	Back to the train!	right bottom	178	163	2018-03-18 07:04:34.220553	2018-03-18 07:04:34.220553	0.00000000000000000	0.00000000000000000
254	---\n- - 2483\n  - 1827\n- - 2222\n  - 1835\n- - 2506\n  - 2203\n- - 2817\n  - 1820\n- - 2602\n  - 1801\n- - 2580\n  - 1538\n- - 2417\n  - 1540\n	points	#ff0032	80	2	\N	right bottom	188	189	2018-04-03 12:11:45.418823	2018-04-03 12:11:45.418823	0.00000000000000000	0.00000000000000000
255	---\n- - 234\n  - 2357\n- - 87\n  - 2352\n- - 282\n  - 2580\n- - 436\n  - 2345\n- - 305\n  - 2337\n- - 288\n  - 2193\n- - 200\n  - 2197\n	points	#ff0032	80	2	\N	right bottom	189	192	2018-04-03 12:14:37.450931	2018-04-03 12:14:37.450931	0.00000000000000000	0.00000000000000000
256	---\n- - 6586\n  - 2311\n- - 6349\n  - 2298\n- - 6687\n  - 2549\n- - 6863\n  - 2278\n- - 6646\n  - 2266\n- - 6634\n  - 2081\n- - 6513\n  - 2078\n	points	#ff0032	80	2	\N	right bottom	192	191	2018-04-03 12:15:15.521999	2018-04-03 12:15:15.521999	0.00000000000000000	0.00000000000000000
257	---\n- - 4221\n  - 2279\n- - 4098\n  - 2284\n- - 4303\n  - 2490\n- - 4401\n  - 2256\n- - 4281\n  - 2252\n- - 4240\n  - 2108\n- - 4173\n  - 2111\n	points	#ff0032	80	2	\N	right bottom	191	189	2018-04-03 12:16:25.997946	2018-04-03 12:16:25.997946	0.00000000000000000	0.00000000000000000
262	---\n- - 3287\n  - 1822\n- - 3164\n  - 1823\n- - 3358\n  - 1691\n- - 3428\n  - 1816\n- - 3345\n  - 1826\n- - 3318\n  - 1940\n- - 3252\n  - 1935\n	points	#ff0032	80	2	Onwards!	right bottom	195	196	2018-04-03 12:28:25.065587	2018-04-03 12:28:25.065587	0.00000000000000000	0.00000000000000000
263	---\n- - 4342\n  - 1973\n- - 4227\n  - 1978\n- - 4369\n  - 1748\n- - 4543\n  - 1943\n- - 4444\n  - 1972\n- - 4473\n  - 2119\n- - 4362\n  - 2135\n	points	#ff0032	80	2	Explore the Ruins	right bottom	196	197	2018-04-03 12:29:46.381516	2018-04-03 12:29:46.381516	0.00000000000000000	0.00000000000000000
264	---\n- - 2881\n  - 2061\n- - 2801\n  - 2071\n- - 2910\n  - 1908\n- - 3023\n  - 2037\n- - 2937\n  - 2056\n- - 2937\n  - 2056\n- - 2958\n  - 2150\n- - 2892\n  - 2153\n	points	#ff0032	80	2	Explore the stream	right bottom	196	198	2018-04-03 12:30:09.368128	2018-04-03 12:30:09.368128	0.00000000000000000	0.00000000000000000
265	---\n- - 882\n  - 1940\n- - 782\n  - 1943\n- - 855\n  - 1766\n- - 1006\n  - 1919\n- - 934\n  - 1938\n- - 966\n  - 2053\n- - 893\n  - 2058\n	points	#ff0032	80	2	Explore the coke furnaces	right bottom	196	193	2018-04-03 12:30:29.37616	2018-04-03 12:30:29.37616	0.00000000000000000	0.00000000000000000
267	---\n- - 712\n  - 1981\n- - 552\n  - 1994\n- - 722\n  - 1740\n- - 866\n  - 1961\n- - 763\n  - 1986\n- - 772\n  - 2122\n- - 686\n  - 2127\n	points	#ff0032	80	2	Back to the crossroads	right bottom	197	196	2018-04-03 12:31:41.785241	2018-04-03 12:31:41.785241	0.00000000000000000	0.00000000000000000
268	---\n- - 4257\n  - 1831\n- - 4185\n  - 1836\n- - 4201\n  - 1714\n- - 4376\n  - 1817\n- - 4294\n  - 1835\n- - 4319\n  - 1907\n- - 4276\n  - 1910\n	points	#ff0032	80	2	Back to the cross roads	right bottom	198	196	2018-04-03 12:32:41.035715	2018-04-03 12:32:41.035715	0.00000000000000000	0.00000000000000000
269	---\n- - 5881\n  - 1985\n- - 5900\n  - 1857\n- - 5958\n  - 1814\n- - 6040\n  - 1793\n- - 6118\n  - 1817\n- - 6163\n  - 1840\n- - 6197\n  - 1862\n- - 6197\n  - 1877\n- - 6198\n  - 1920\n- - 6182\n  - 1938\n- - 6151\n  - 1946\n- - 6139\n  - 1956\n- - 6126\n  - 1968\n- - 6115\n  - 1979\n- - 6110\n  - 1996\n	points	#ff0032	80	2	Go inside!	right bottom	193	194	2018-04-03 12:34:36.549315	2018-04-03 12:34:36.549315	0.00000000000000000	0.00000000000000000
271	---\n- - 4074\n  - 2230\n- - 3944\n  - 2261\n- - 4036\n  - 2030\n- - 4180\n  - 2190\n- - 4111\n  - 2230\n- - 4141\n  - 2357\n- - 4068\n  - 2379\n	points	#ff0032	80	2	Out!	right bottom	194	193	2018-04-03 12:35:27.362141	2018-04-03 12:35:27.362141	0.00000000000000000	0.00000000000000000
272	---\n- - 4529\n  - 1912\n- - 4419\n  - 1911\n- - 4614\n  - 1740\n- - 4683\n  - 1911\n- - 4586\n  - 1925\n- - 4573\n  - 2062\n- - 4476\n  - 2046\n	points	#ff0032	80	2	Back to the crossroads	right bottom	193	196	2018-04-03 12:36:04.651564	2018-04-03 12:36:04.651564	0.00000000000000000	0.00000000000000000
273	---\n- - 5417\n  - 2041\n- - 5332\n  - 2037\n- - 5443\n  - 1900\n- - 5533\n  - 2042\n- - 5454\n  - 2047\n- - 5453\n  - 2117\n- - 5405\n  - 2113\n	points	#ff0032	80	2	\N	right bottom	189	199	2018-04-03 12:39:47.153079	2018-04-03 12:39:47.153079	0.00000000000000000	0.00000000000000000
274	---\n- - 3549\n  - 1916\n- - 3487\n  - 1920\n- - 3496\n  - 1788\n- - 3638\n  - 1879\n- - 3591\n  - 1903\n- - 3622\n  - 1969\n- - 3567\n  - 1981\n	points	#ff0032	80	2	Back to the campsite	right bottom	199	189	2018-04-03 12:40:56.937613	2018-04-03 12:40:56.937613	0.00000000000000000	0.00000000000000000
275	---\n- - 26\n  - 1920\n- - 6868\n  - 1920\n- - 45\n  - 1804\n- - 106\n  - 1919\n- - 51\n  - 1927\n- - 51\n  - 1988\n- - 4\n  - 1986\n	points	#ff0032	80	2	Onwards!	right bottom	199	195	2018-04-03 12:41:25.895886	2018-04-03 12:41:25.895886	0.00000000000000000	0.00000000000000000
276	---\n- - 6723\n  - 1893\n- - 6694\n  - 1891\n- - 6767\n  - 1824\n- - 6804\n  - 1895\n- - 6761\n  - 1904\n- - 6756\n  - 1949\n- - 6726\n  - 1946\n	points	#ff0032	80	2	Go back!	right bottom	195	199	2018-04-03 12:41:50.11001	2018-04-03 12:41:50.11001	0.00000000000000000	0.00000000000000000
277	---\n- - 5547\n  - 1973\n- - 5444\n  - 1968\n- - 5621\n  - 1809\n- - 5737\n  - 1970\n- - 5626\n  - 1986\n- - 5619\n  - 2099\n- - 5530\n  - 2097\n	points	#ff0032	80	2	Back!	right bottom	196	195	2018-04-03 12:42:18.049765	2018-04-03 12:42:18.049765	0.00000000000000000	0.00000000000000000
279	---\n- - 4655\n  - 1484\n- - 4782\n  - 1503\n- - 4807\n  - 1752\n- - 4665\n  - 1764\n- - 4553\n  - 1724\n- - 4523\n  - 1571\n- - 4568\n  - 1423\n- - 4384\n  - 1521\n- - 4406\n  - 1771\n- - 4670\n  - 1898\n- - 4953\n  - 1626\n- - 4862\n  - 1540\n	points	#ff0032	80	2	\N	right bottom	141	151	2018-10-03 07:21:10.328988	2018-10-03 07:21:10.328988	0.00000000000000000	0.00000000000000000
281	---\n- - 6857\n  - 1868\n- - 6759\n  - 1739\n- - 6895\n  - 1598\n- - 143\n  - 1654\n- - 186\n  - 1855\n	points	#ff0032	80	2	\N	right bottom	188	197	2019-01-23 06:30:55.926022	2019-01-23 06:30:55.926022	0.00000000000000000	0.00000000000000000
284	---\n- - 4870\n  - 2579\n- - 4896\n  - 2557\n- - 4937\n  - 2561\n- - 4950\n  - 2597\n- - 4942\n  - 2617\n- - 4921\n  - 2625\n- - 4899\n  - 2627\n- - 4873\n  - 2604\n	points	#ff0032	80	2	\N	right bottom	200	202	2019-07-05 04:49:23.028434	2019-07-05 04:49:23.028434	0.00000000000000000	0.00000000000000000
290	---\n- - 4910\n  - 1469\n- - 4985\n  - 1572\n- - 4988\n  - 2093\n- - 5180\n  - 2149\n- - 5288\n  - 1484\n	points	#ff0032	80	2	\N	right bottom	225	213	2021-11-27 23:02:59.984465	2021-11-27 23:02:59.984465	0.00000000000000000	0.00000000000000000
291	---\n- - 2455\n  - 1023\n- - 2461\n  - 1967\n- - 2953\n  - 1954\n- - 2943\n  - 1020\n	points	#ff0032	80	2	\N	right bottom	225	226	2021-11-27 23:03:36.587373	2021-11-27 23:03:36.587373	0.00000000000000000	0.00000000000000000
292	---\n- - 9\n  - 735\n- - 49\n  - 1340\n- - 401\n  - 1328\n- - 413\n  - 761\n	points	#ff0032	80	2	\N	right bottom	225	211	2021-11-27 23:04:10.211174	2021-11-27 23:04:10.211174	0.00000000000000000	0.00000000000000000
293	---\n- - 3245\n  - 1185\n- - 3245\n  - 1685\n- - 3661\n  - 1679\n- - 3623\n  - 1206\n	points	#ff0032	80	2	\N	right bottom	213	214	2021-11-27 23:04:41.639677	2021-11-27 23:04:41.639677	0.00000000000000000	0.00000000000000000
294	---\n- - 3025\n  - 934\n- - 3032\n  - 1801\n- - 3182\n  - 1986\n- - 3176\n  - 824\n	points	#ff0032	80	2	\N	right bottom	214	224	2021-11-27 23:05:07.88476	2021-11-27 23:05:07.88476	0.00000000000000000	0.00000000000000000
295	---\n- - 4465\n  - 1020\n- - 4467\n  - 1675\n- - 4575\n  - 1758\n- - 4595\n  - 934\n	points	#ff0032	80	2	\N	right bottom	214	217	2021-11-27 23:05:26.165973	2021-11-27 23:05:26.165973	0.00000000000000000	0.00000000000000000
296	---\n- - 5167\n  - 754\n- - 5178\n  - 1910\n- - 374\n  - 1818\n- - 405\n  - 792\n	points	#ff0032	80	2	\N	right bottom	214	216	2021-11-27 23:05:44.774359	2021-11-27 23:05:44.774359	0.00000000000000000	0.00000000000000000
297	---\n- - 613\n  - 773\n- - 604\n  - 1842\n- - 1081\n  - 1748\n- - 1086\n  - 760\n	points	#ff0032	80	2	\N	right bottom	214	215	2021-11-27 23:06:05.790427	2021-11-27 23:06:05.790427	0.00000000000000000	0.00000000000000000
298	---\n- - 3481\n  - 969\n- - 3476\n  - 1791\n- - 3799\n  - 1830\n- - 3807\n  - 921\n	points	#ff0032	80	2	\N	right bottom	217	214	2021-11-27 23:06:49.488578	2021-11-27 23:06:49.488578	0.00000000000000000	0.00000000000000000
299	---\n- - 5133\n  - 896\n- - 5137\n  - 1847\n- - 214\n  - 1845\n- - 212\n  - 898\n	points	#ff0032	80	2	\N	right bottom	216	214	2021-11-27 23:07:27.915298	2021-11-27 23:07:27.915298	0.00000000000000000	0.00000000000000000
301	---\n- - 2091\n  - 955\n- - 2098\n  - 1792\n- - 2182\n  - 1825\n- - 2193\n  - 936\n	points	#ff0032	80	2	\N	right bottom	215	214	2021-11-27 23:08:16.456296	2021-11-27 23:08:16.456296	0.00000000000000000	0.00000000000000000
302	---\n- - 4702\n  - 1076\n- - 4701\n  - 1606\n- - 4841\n  - 1647\n- - 4841\n  - 1053\n	points	#ff0032	80	2	\N	right bottom	224	214	2021-11-27 23:08:53.992221	2021-11-27 23:08:53.992221	0.00000000000000000	0.00000000000000000
303	---\n- - 4090\n  - 1178\n- - 4087\n  - 1518\n- - 4251\n  - 1504\n- - 4236\n  - 1172\n	points	#ff0032	80	2	\N	right bottom	214	218	2021-11-27 23:09:14.942952	2021-11-27 23:09:14.942952	0.00000000000000000	0.00000000000000000
304	---\n- - 543\n  - 1168\n- - 541\n  - 1312\n- - 608\n  - 1312\n- - 607\n  - 1155\n	points	#ff0032	80	2	\N	right bottom	218	214	2021-11-27 23:09:44.931723	2021-11-27 23:09:44.931723	0.00000000000000000	0.00000000000000000
305	---\n- - 1756\n  - 1343\n- - 1769\n  - 1398\n- - 1819\n  - 1375\n- - 1811\n  - 1341\n	points	#ff0032	80	2	\N	right bottom	218	219	2021-11-27 23:10:43.727454	2021-11-27 23:10:43.727454	0.00000000000000000	0.00000000000000000
306	---\n- - 4276\n  - 1330\n- - 4283\n  - 1415\n- - 4423\n  - 1410\n- - 4406\n  - 1329\n	points	#ff0032	80	2	\N	right bottom	219	218	2021-11-27 23:11:08.131933	2021-11-27 23:11:08.131933	0.00000000000000000	0.00000000000000000
307	---\n- - 174\n  - 1159\n- - 166\n  - 1419\n- - 262\n  - 1430\n- - 262\n  - 1140\n	points	#ff0032	80	2	\N	right bottom	219	227	2021-11-27 23:11:24.078743	2021-11-27 23:11:24.078743	0.00000000000000000	0.00000000000000000
309	---\n- - 897\n  - 1020\n- - 897\n  - 1245\n- - 1036\n  - 1241\n- - 1050\n  - 1018\n	points	#ff0032	80	2	\N	right bottom	227	220	2021-11-27 23:12:21.261407	2021-11-27 23:12:21.261407	0.00000000000000000	0.00000000000000000
310	---\n- - 4378\n  - 1532\n- - 4390\n  - 1930\n- - 4605\n  - 1956\n- - 4765\n  - 1539\n	points	#ff0032	80	2	\N	right bottom	220	227	2021-11-27 23:12:50.951974	2021-11-27 23:12:50.951974	0.00000000000000000	0.00000000000000000
311	---\n- - 3490\n  - 1149\n- - 3486\n  - 1583\n- - 3655\n  - 1563\n- - 3657\n  - 1154\n	points	#ff0032	80	2	\N	right bottom	220	232	2021-11-27 23:13:05.979088	2021-11-27 23:13:05.979088	0.00000000000000000	0.00000000000000000
313	---\n- - 525\n  - 1339\n- - 529\n  - 1515\n- - 673\n  - 1498\n- - 682\n  - 1353\n	points	#ff0032	80	2	\N	right bottom	222	220	2021-11-27 23:14:07.398481	2021-11-27 23:14:07.398481	0.00000000000000000	0.00000000000000000
314	---\n- - 93\n  - 1233\n- - 94\n  - 1556\n- - 145\n  - 1496\n- - 145\n  - 1214\n	points	#ff0032	80	2	\N	right bottom	222	232	2021-11-27 23:14:19.852438	2021-11-27 23:14:19.852438	0.00000000000000000	0.00000000000000000
315	---\n- - 2216\n  - 1231\n- - 2179\n  - 1658\n- - 2376\n  - 1696\n- - 2392\n  - 1229\n	points	#ff0032	80	2	\N	right bottom	232	233	2021-11-27 23:16:05.280523	2021-11-27 23:16:05.280523	0.00000000000000000	0.00000000000000000
316	---\n- - 1403\n  - 1432\n- - 1405\n  - 1486\n- - 1799\n  - 1466\n- - 1735\n  - 1426\n	points	#ff0032	80	2	\N	right bottom	232	208	2021-11-27 23:16:17.262216	2021-11-27 23:16:17.262216	0.00000000000000000	0.00000000000000000
317	---\n- - 1932\n  - 1173\n- - 1936\n  - 1215\n- - 2175\n  - 1201\n- - 2165\n  - 1160\n	points	#ff0032	80	2	\N	right bottom	232	211	2021-11-27 23:16:36.425084	2021-11-27 23:16:36.425084	0.00000000000000000	0.00000000000000000
318	---\n- - 2459\n  - 1453\n- - 2661\n  - 1514\n- - 2883\n  - 1441\n- - 2691\n  - 1410\n	points	#ff0032	80	2	\N	right bottom	208	232	2021-11-27 23:16:59.703028	2021-11-27 23:16:59.703028	0.00000000000000000	0.00000000000000000
319	---\n- - 877\n  - 1048\n- - 899\n  - 1862\n- - 1338\n  - 1792\n- - 1341\n  - 1029\n	points	#ff0032	80	2	\N	right bottom	208	233	2021-11-27 23:17:13.012523	2021-11-27 23:17:13.012523	0.00000000000000000	0.00000000000000000
320	---\n- - 423\n  - 945\n- - 437\n  - 1098\n- - 818\n  - 1071\n- - 806\n  - 922\n	points	#ff0032	80	2	\N	right bottom	208	211	2021-11-27 23:17:32.194108	2021-11-27 23:17:32.194108	0.00000000000000000	0.00000000000000000
321	---\n- - 2314\n  - 1520\n- - 2327\n  - 1786\n- - 2626\n  - 1819\n- - 2637\n  - 1504\n	points	#ff0032	80	2	\N	right bottom	233	229	2021-11-27 23:18:07.483379	2021-11-27 23:18:07.483379	0.00000000000000000	0.00000000000000000
322	---\n- - 170\n  - 1448\n- - 167\n  - 1527\n- - 269\n  - 1528\n- - 268\n  - 1455\n	points	#ff0032	80	2	\N	right bottom	229	230	2021-11-27 23:18:46.455026	2021-11-27 23:18:46.455026	0.00000000000000000	0.00000000000000000
323	---\n- - 5041\n  - 1197\n- - 5034\n  - 1337\n- - 5233\n  - 1349\n- - 5241\n  - 1197\n	points	#ff0032	80	2	\N	right bottom	229	233	2021-11-27 23:18:56.963007	2021-11-27 23:18:56.963007	0.00000000000000000	0.00000000000000000
324	---\n- - 527\n  - 1067\n- - 591\n  - 1842\n- - 830\n  - 1751\n- - 796\n  - 1058\n	points	#ff0032	80	2	\N	right bottom	233	208	2021-11-27 23:19:21.888366	2021-11-27 23:19:21.888366	0.00000000000000000	0.00000000000000000
325	---\n- - 1308\n  - 1241\n- - 1321\n  - 1498\n- - 1376\n  - 1453\n- - 1367\n  - 1252\n	points	#ff0032	80	2	\N	right bottom	233	210	2021-11-27 23:20:02.754871	2021-11-27 23:20:02.754871	0.00000000000000000	0.00000000000000000
326	---\n- - 1394\n  - 1256\n- - 1404\n  - 1451\n- - 1446\n  - 1459\n- - 1449\n  - 1267\n	points	#ff0032	80	2	\N	right bottom	233	209	2021-11-27 23:20:12.228246	2021-11-27 23:20:12.228246	0.00000000000000000	0.00000000000000000
327	---\n- - 370\n  - 1113\n- - 372\n  - 1642\n- - 562\n  - 1606\n- - 566\n  - 1140\n	points	#ff0032	80	2	\N	right bottom	210	233	2021-11-27 23:20:36.033632	2021-11-27 23:20:36.033632	0.00000000000000000	0.00000000000000000
328	---\n- - 4419\n  - 882\n- - 4458\n  - 1703\n- - 4676\n  - 1650\n- - 4672\n  - 954\n	points	#ff0032	80	2	\N	right bottom	209	233	2021-11-27 23:21:04.107832	2021-11-27 23:21:04.107832	0.00000000000000000	0.00000000000000000
329	---\n- - 1659\n  - 1405\n- - 1648\n  - 1576\n- - 1716\n  - 1614\n- - 1732\n  - 1405\n	points	#ff0032	80	2	\N	right bottom	233	225	2021-11-27 23:21:22.775923	2021-11-27 23:21:22.775923	0.00000000000000000	0.00000000000000000
330	---\n- - 2665\n  - 1750\n- - 2663\n  - 1920\n- - 2866\n  - 1876\n- - 2875\n  - 1749\n	points	#ff0032	80	2	\N	right bottom	211	229	2021-11-27 23:21:52.142899	2021-11-27 23:21:52.142899	0.00000000000000000	0.00000000000000000
331	---\n- - 3352\n  - 1764\n- - 2981\n  - 1996\n- - 3402\n  - 2160\n- - 3606\n  - 1796\n	points	#ff0032	80	2	\N	right bottom	211	233	2021-11-27 23:22:03.275881	2021-11-27 23:22:03.275881	0.00000000000000000	0.00000000000000000
332	---\n- - 4690\n  - 1605\n- - 4613\n  - 1678\n- - 4777\n  - 1712\n- - 4839\n  - 1643\n	points	#ff0032	80	2	\N	right bottom	211	232	2021-11-27 23:22:14.679343	2021-11-27 23:22:14.679343	0.00000000000000000	0.00000000000000000
333	---\n- - 1143\n  - 1390\n- - 1140\n  - 1482\n- - 1217\n  - 1484\n- - 1218\n  - 1388\n	points	#ff0032	80	2	\N	right bottom	211	209	2021-11-27 23:22:29.611211	2021-11-27 23:22:29.611211	0.00000000000000000	0.00000000000000000
334	---\n- - 2139\n  - 1596\n- - 2136\n  - 1810\n- - 2256\n  - 1824\n- - 2274\n  - 1605\n	points	#ff0032	80	2	\N	right bottom	211	225	2021-11-27 23:22:43.254163	2021-11-27 23:22:43.254163	0.00000000000000000	0.00000000000000000
335	---\n- - 2555\n  - 1106\n- - 2562\n  - 1320\n- - 2694\n  - 1310\n- - 2691\n  - 1112\n	points	#ff0032	80	2	\N	right bottom	226	225	2021-11-27 23:23:55.257526	2021-11-27 23:23:55.257526	0.00000000000000000	0.00000000000000000
336	---\n- - 1867\n  - 1274\n- - 1858\n  - 1387\n- - 2015\n  - 1388\n- - 2017\n  - 1256\n	points	#ff0032	80	2	\N	right bottom	226	227	2021-11-27 23:24:09.752738	2021-11-27 23:24:09.752738	0.00000000000000000	0.00000000000000000
337	---\n- - 292\n  - 1528\n- - 287\n  - 1613\n- - 413\n  - 1612\n- - 402\n  - 1531\n	points	#ff0032	80	2	\N	right bottom	227	219	2021-11-27 23:24:53.017205	2021-11-27 23:24:53.017205	0.00000000000000000	0.00000000000000000
338	---\n- - 1447\n  - 1467\n- - 1401\n  - 1765\n- - 1678\n  - 1840\n- - 1700\n  - 1467\n	points	#ff0032	80	2	\N	right bottom	213	212	2021-11-27 23:25:22.317912	2021-11-27 23:25:22.317912	0.00000000000000000	0.00000000000000000
339	---\n- - 5080\n  - 1135\n- - 5118\n  - 1273\n- - 5155\n  - 1272\n- - 5147\n  - 1131\n	points	#ff0032	80	2	\N	right bottom	212	225	2021-11-27 23:25:44.433021	2021-11-27 23:25:44.433021	0.00000000000000000	0.00000000000000000
340	---\n- - 4796\n  - 1166\n- - 4805\n  - 1500\n- - 4903\n  - 1486\n- - 4919\n  - 1135\n	points	#ff0032	80	2	\N	right bottom	212	213	2021-11-27 23:25:56.962617	2021-11-27 23:25:56.962617	0.00000000000000000	0.00000000000000000
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."schema_migrations" ("version") FROM stdin;
20161019205033
20161105234806
20161106214313
20170113230451
20170122213950
20170122231027
20170123193321
20170125220141
20170128054526
20170412031849
20170415010245
20170415011912
20170415175333
20170430212918
20170430214558
20170430230323
20171229183743
20171231025639
20171231030248
20171225014751
20171231180543
20180121224714
\.


--
-- Data for Name: sound_contexts; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."sound_contexts" ("id", "context_type", "context_id", "sound_id") FROM stdin;
1	Memory	2	1
2	Sphere	6	2
3	Memory	1	3
\.


--
-- Data for Name: sounds; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."sounds" ("id", "volume", "name", "file", "loops", "created_at", "updated_at") FROM stdin;
1	30	sail	sail.mp3	100	2017-06-05 07:16:05.467453	2017-06-05 07:16:05.467453
2	30	as_you_found_me	as_you_found_me.mp3	100	2017-06-05 07:16:06.358973	2017-06-05 07:16:06.358973
3	30	banjo	banjo.mp3	100	2017-06-05 07:16:06.862627	2017-06-05 07:16:06.862627
\.


--
-- Data for Name: spheres; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."spheres" ("id", "panorama", "caption", "memory_id", "created_at", "updated_at", "default_zoom", "guid", "panorama_processing", "panorama_tmp") FROM stdin;
1	livingroom.jpg	living room!	1	2017-06-05 07:15:46.076078	2017-06-05 07:15:46.076078	50	\N	f	\N
4	boat_livingroom.jpg	Boat Livingroom	2	2017-06-05 07:15:55.976359	2017-06-05 07:15:55.976359	31	\N	f	\N
5	boat_bed.jpg	Boat Bedroom	2	2017-06-05 07:15:59.617597	2017-06-05 07:15:59.617597	0	\N	f	\N
6	boat_night.jpg	night time	2	2017-06-05 07:16:04.04708	2017-06-05 07:16:04.04708	43	\N	f	\N
29	PANO_20170624_191915.jpg	Kitchen 2	1	2017-07-04 04:15:12.709683	2017-07-04 04:15:12.709683	50	\N	f	\N
30	PANO_20170624_191550.jpg	Basement	1	2017-07-04 04:17:18.518738	2017-07-04 04:17:18.518738	50	\N	f	\N
31	PANO_20170724_160855.jpg	Mountain 1	11	2017-07-27 23:05:23.107803	2017-07-27 23:05:23.107803	50	\N	f	\N
32	PANO_20170724_163038.jpg	Mountain 2	11	2017-07-27 23:05:27.347008	2017-07-27 23:05:27.347008	50	\N	f	\N
25	PANO_20150928_085633.jpg	island view	2	2017-06-11 20:04:30.084501	2017-06-11 20:05:04.328288	44	\N	f	\N
26	PANO_20160511_200955.jpg	Boat backyard	2	2017-06-11 20:18:18.78791	2017-06-11 20:18:18.78791	50	\N	f	\N
27	PANO_20160521_125420.jpg	Boat frontyard	2	2017-06-11 20:21:52.628113	2017-06-11 20:21:52.628113	50	\N	f	\N
2	kitchen.jpg	kitchen!	1	2017-06-05 07:15:47.474176	2017-12-02 01:34:02.016368	23	\N	f	\N
39	PANO_20171228_115020.jpg	Barn	14	2017-12-29 18:24:48.117811	2017-12-29 18:24:48.117811	50	\N	f	\N
40	PANO_20171228_115152.jpg	Back Yard 1	14	2017-12-29 18:29:07.375779	2017-12-29 18:29:07.375779	50	\N	f	\N
23	PANO_20150828_070600.jpg	treasure island	2	2017-06-11 19:50:36.549308	2017-12-30 02:17:53.746876	74	\N	f	\N
44	PANO_20171227_140426.jpg	Second front entrance	14	2017-12-31 02:49:19.386193	2017-12-31 02:49:20.883774	50	86fe5eb6978081082df88cdc9b0d6e66	f	\N
147	IMG_20180206_155645.jpg	Basement	41	2018-02-06 21:33:52.937944	2018-02-06 21:34:06.16138	50	cb167b3ff80760de215afed32888afd7	f	\N
59	PANO_20171226_230012.jpg	Joanne's room night	14	2017-12-31 04:53:47.812085	2017-12-31 04:54:39.546649	8	65950abaaa03266cef7094243806237c	f	\N
47	PANO_20171228_110005.jpg	Foyer	14	2017-12-31 04:10:24.939196	2017-12-31 04:12:25.528381	26	cf384c888d295148b7fd86666f7267bf	f	\N
48	PANO_20171227_133017.jpg	Livingroom	14	2017-12-31 04:13:34.632379	2017-12-31 04:14:41.608124	50	ddeb77b957c2e068992ff98c13d0fa44	f	\N
49	PANO_20171227_134515.jpg	Basement Foyer	14	2017-12-31 04:16:41.455964	2017-12-31 04:19:31.435929	0	5dd517426dc839059ee016c86baf3981	f	\N
60	PANO_20171228_110650.jpg	C & C's room	14	2017-12-31 04:56:14.043142	2017-12-31 04:56:42.660879	50	b12da2026e3695b19999f2a925e7f8fd	f	\N
50	PANO_20171227_134653.jpg	Sauna	14	2017-12-31 04:20:24.026445	2017-12-31 04:22:20.794275	13	81bf64eba9bc3bc8aac20db79b60d9fb	f	\N
51	PANO_20171227_133805.jpg	Basement livingroom	14	2017-12-31 04:24:02.217096	2017-12-31 04:25:26.563731	50	0c53b867191910f6f37987eac324c92c	f	\N
52	PANO_20171227_134015.jpg	Basement fireplace	14	2017-12-31 04:34:47.565309	2017-12-31 04:36:56.260816	5	9688b3936e5d77fee7fe2000175e34fb	f	\N
61	PANO_20171228_110942.jpg	Closet	14	2017-12-31 04:58:02.632269	2017-12-31 04:58:34.057325	50	d2b88b8d7cf8d242c38c1e062a0cfaa8	f	\N
68	PANO_20171228_112755.jpg	Kitchen 2	14	2017-12-31 05:14:19.734472	2017-12-31 05:15:00.789283	50	1c20ba0270d1810cc7a4b3c137f24f36	f	\N
55	PANO_20171227_135511.jpg	Basement bathroom	14	2017-12-31 04:44:11.870982	2017-12-31 04:45:39.929999	0	94246702484e7653d1986639b5a969dc	f	\N
56	PANO_20171227_140010.jpg	Basement furnace room	14	2017-12-31 04:46:45.941792	2017-12-31 04:47:12.997673	50	a7bf1b0f272a7ec83c52ee0127e7a91d	f	\N
57	PANO_20171228_110153.jpg	Upstairs Foyer	14	2017-12-31 04:49:33.9622	2017-12-31 04:50:03.54886	50	6d77b8f9b38f91fb281c636a6ffd4e24	f	\N
58	PANO_20171228_111353.jpg	Joanne's room	14	2017-12-31 04:51:59.893001	2017-12-31 04:52:38.45025	50	e948c98f6dbc19af19213a8933313eae	f	\N
69	PANO_20171228_104017.jpg	Side Hallway	14	2017-12-31 05:17:52.959551	2017-12-31 05:18:34.302487	50	bf1ca85b666b2fd1ad1ec983e75ef0e2	f	\N
62	PANO_20171228_111058.jpg	Attic 1	14	2017-12-31 05:00:10.794316	2017-12-31 05:00:55.719695	0	6a59e3779ff5870d283115465eb2e207	f	\N
63	PANO_20171228_111220.jpg	Attic 2	14	2017-12-31 05:02:43.616964	2017-12-31 05:03:44.002439	37	7f818b618c91c9def36f6951609a02d1	f	\N
64	PANO_20171228_111749.jpg	Upstairs bathroom	14	2017-12-31 05:05:53.77125	2017-12-31 05:06:24.633527	50	d8032bfe6809b61545cc6af6d360fcfe	f	\N
65	PANO_20171228_103506.jpg	Dining Room	14	2017-12-31 05:08:43.991614	2017-12-31 05:09:14.990759	50	2da34af486bf865889f2c24d2f7a57da	f	\N
70	PANO_20171228_104158.jpg	Foyer 2	14	2017-12-31 05:20:42.747855	2017-12-31 05:21:14.722439	50	050b51e2d826c68b8dd3c3f8d5a558fd	f	\N
67	PANO_20171228_103210.jpg	Kitchen 1	14	2017-12-31 05:12:40.272995	2017-12-31 05:13:43.87344	31	3a7d4b4f461840925e5fdd85718f1ecc	f	\N
54	PANO_20171226_222444.jpg	Basement fireplace night	14	2017-12-31 04:40:58.689319	2017-12-31 05:14:55.095785	0	1a794efd02ffed05128a2c09aa1dd8bd	f	\N
71	PANO_20171228_112334.jpg	Sowing room	14	2017-12-31 05:22:36.643111	2017-12-31 05:23:09.902497	50	39fce5c7fcee104203a9738e658c55b3	f	\N
72	PANO_20171228_113703.jpg	Garage	14	2017-12-31 05:24:47.12698	2017-12-31 05:25:27.927605	50	60be152f62cd9e29b7f16f12d7a46054	f	\N
73	PANO_20171228_104342.jpg	M's room	14	2017-12-31 05:28:20.004658	2017-12-31 05:29:14.614678	0	b83b71bc9d18b7871b9ae3cebeeed16e	f	\N
74	PANO_20171228_115836.jpg	Back Yard 2	14	2017-12-31 05:34:28.758465	2017-12-31 05:34:57.995631	50	9cf21ac6c4cf67b1839317d29a0d0bd2	f	\N
86	1006969-large.jpg	my face	24	2018-01-21 01:17:19.815588	2018-01-21 01:17:22.678127	50	02f6a56a3457c66961493d88fa84961a	f	\N
35	PANO_20171228_114852.jpg	Front Yard	14	2017-12-29 18:07:51.809483	2018-01-21 05:24:39.856214	3	\N	f	\N
41	PANO_20171228_114638.jpg	Front entrance	14	2017-12-30 20:29:58.293562	2018-01-22 04:16:56.668974	1	\N	f	\N
117	tenaya_2.jpg	Tenaya Lake	11	2018-01-24 03:55:32.758719	2018-01-24 03:55:39.903646	50	0abf9c36bdb4200ce334f1ffaac7a873	f	\N
132	R0010007.JPG	Kitchen	40	2018-01-25 20:39:01.526658	2018-01-30 06:57:31.134643	35	a62fbcf67f261546d51d35f8f37a9a0b	f	\N
122	marina.jpg	Marina	35	2018-01-24 20:41:27.754427	2018-01-24 20:44:43.449193	82	a788b266e866f433820da3a5f7215900	f	\N
123	lol.jpg	okok	36	2018-01-25 02:41:27.483254	2018-01-25 02:41:32.167651	50	a3773f9b60170ddaf1f73478a01a1f80	f	\N
121	PANO_20180124_132900.jpg	Kitchen	35	2018-01-24 20:39:49.380552	2018-01-24 20:44:31.360134	34	91d480f21d4e583d58d544fcc1b598a4	f	\N
124	some.jpg	some	36	2018-01-25 02:46:42.841927	2018-01-25 02:48:15.225948	0	dd199295d55fa82675582190c57caf95	f	\N
126	some.jpg	dd	38	2018-01-25 02:48:57.638199	2018-01-25 02:48:59.549666	50	6874991c619c9be4e6ad8a4ba2401f40	f	\N
127	some.jpg	bug	39	2018-01-25 02:50:07.982333	2018-01-25 02:50:10.853839	50	ae9ea7356608814e32d82c026ed2b18b	f	\N
3	marina.jpg	Marina	2	2017-06-05 07:15:50.4061	2018-01-29 19:08:02.473521	61	\N	f	\N
131	R0010006.JPG	Dining room	40	2018-01-25 20:38:40.337637	2018-01-25 20:40:31.939427	0	ff5afcd0bb647571f90b4f0ecb43292f	f	\N
133	R0010008.JPG	Living room	40	2018-01-25 20:39:13.630915	2018-01-25 20:39:19.875975	50	ff0c51d8b0dfa3f7529388c074784f42	f	\N
134	R0010009.JPG	Basement	40	2018-01-25 20:39:24.899558	2018-01-25 20:39:34.013133	50	0449ec77bfee463608ca217c3455a6d8	f	\N
135	R0010010.JPG	Laundry room	40	2018-01-25 20:39:36.747072	2018-01-25 20:39:42.207074	50	36b475d9c207da43ddc90e60612d2631	f	\N
136	R0010011.JPG	Upstairs	40	2018-01-25 20:39:47.462587	2018-01-25 20:39:54.830259	50	1e1cd5839cedec3c212839d5a082ffc1	f	\N
137	R0010012.JPG	Robyn's room	40	2018-01-25 20:40:02.125162	2018-01-25 20:40:07.323349	50	c6e7624980a6b9a0a8d83344af316ef9	f	\N
138	R0010013.JPG	Backyard	40	2018-01-25 20:40:15.678085	2018-01-25 20:40:19.811436	50	26571d9213d91a8f5c9763b712625b28	f	\N
139	R0010014.JPG	Pop's shed	40	2018-01-25 20:40:26.290261	2018-01-25 20:40:32.69031	50	6f9097c21c13a2828f94230d66940fb6	f	\N
141	IMG_20180206_160653.jpg	Outside	41	2018-02-06 21:29:34.416239	2018-02-06 21:29:49.152407	50	a6bbb55f4f7bbf0b8e77233c302164ff	f	\N
142	IMG_20180206_160025.jpg	Backyard	41	2018-02-06 21:29:58.415381	2018-02-06 21:30:08.10433	50	b50f4174668f5f4462c977b25583d747	f	\N
143	IMG_20180206_160442.jpg	Shed 1	41	2018-02-06 21:30:45.790484	2018-02-06 21:30:57.203142	50	d26d0374a4645267f4a808a3a4d713b8	f	\N
144	IMG_20180206_160555.jpg	Shed 2	41	2018-02-06 21:31:02.089019	2018-02-06 21:31:16.447783	50	3767edb65b12458ee09688e3891141fb	f	\N
145	IMG_20180206_154923.jpg	Kitchen	41	2018-02-06 21:31:46.028639	2018-02-06 21:32:03.855041	50	5529d040cf8a3c74a2000f5262d1f6ac	f	\N
150	IMG_20180206_155444.jpg	Bathroom	41	2018-02-06 21:35:40.475333	2018-02-06 21:35:55.884983	50	cf12caa0beb6c4c96b33b7ded85a9cdd	f	\N
151	IMG_20180206_155349.jpg	Mum's Room	41	2018-02-06 21:35:53.466134	2018-02-06 21:36:04.858783	50	f699aa869ba774cd66af828cda5f8d93	f	\N
153	IMG_20180206_155237.jpg	Joe's Room	41	2018-02-06 21:38:06.577284	2018-02-06 21:38:23.775617	50	aa64412af9479a83c704efdb17802cb0	f	\N
154	IMG_20180206_155052.jpg	Livingroom	41	2018-02-06 21:40:26.313866	2018-02-06 21:40:43.134666	50	247786e69231b799342525ebfe501122	f	\N
155	IMG_20180206_155526.jpg	Dining room	41	2018-02-06 21:40:52.461085	2018-02-06 21:41:11.455696	50	da53384a543521e0718c103eefd9c983	f	\N
148	IMG_20180206_155748.jpg	Laundry Room	41	2018-02-06 21:34:10.762582	2018-02-06 21:47:02.773018	0	e0b058f0ae80043f2fafabb7e6c1051a	f	\N
149	IMG_20180206_155204.jpg	Upstairs	41	2018-02-06 21:35:17.185685	2018-02-06 22:01:24.329407	0	391eea817c38511f336b4834ab0bc6d8	f	\N
152	IMG_20180206_155313.jpg	Robyn's Room	41	2018-02-06 21:36:06.524476	2018-02-06 22:34:31.639132	14	e1a94bee2835097e95260c199feba963	f	\N
157	IMG_20180209_181041.jpg	The front	42	2018-02-09 08:41:42.218149	2018-02-09 08:41:47.242743	50	c1f565b92571f61afbbceb602ee27350	f	\N
156	IMG_20180209_175941.jpg	The Back	42	2018-02-09 08:41:36.321324	2018-02-09 08:42:04.01607	0	46c4128c2dd2be0c71246d58a144f57a	f	\N
158	IMG_20180209_170139.JPG	Under the bridge	42	2018-02-09 08:48:26.864694	2018-02-09 08:48:38.787672	50	d46123799e63f979a65e879518f2d8b8	f	\N
194	IMG_20180401_135108.jpg	Inside the furnace	45	2018-04-03 12:14:38.545083	2018-04-03 12:14:59.303031	50	88d412fd9cb0baf21a3a3a8bf880d7b6	f	\N
168	IMG_20180317_112717.jpg	Goin' down!	44	2018-03-18 06:33:25.766766	2018-03-18 06:40:51.476594	0	ef3029d889a9b71a816c3257690e755a	f	\N
177	IMG_20180317_140127.jpg	Cablecar	44	2018-03-18 06:51:56.507941	2018-03-18 07:19:52.604347	0	c8e70396420cb3662e868c69546121bf	f	\N
165	IMG_20180317_110019.jpg	3 Sisters from Afar	44	2018-03-18 06:18:45.273687	2018-03-18 06:18:58.610975	50	561be9efbd49448fdbb0e7f503a4b172	f	\N
166	IMG_20180317_112332.jpg	3 Sisters a little closer	44	2018-03-18 06:20:20.597813	2018-03-18 06:20:32.911586	50	ea1b973c8d792b7a239b78ff791ca9fc	f	\N
169	IMG_20180317_112736.jpg	Photogenic AF	44	2018-03-18 06:33:55.314081	2018-03-18 06:40:55.272987	1	ce18599406a38386764d70853da08be9	f	\N
188	IMG_20180402_113623.jpg	Campsite	45	2018-04-03 11:56:13.189369	2018-04-03 12:11:36.424662	0	1dbc7a3f453b2b91b7970dea43ae48f6	f	\N
171	IMG_20180317_113012.jpg	Go down MORE	44	2018-03-18 06:42:52.129068	2018-03-18 06:44:02.135565	0	502ccc2cd699bc2981ce1f2e8a1d4ac1	f	\N
173	IMG_20180317_121031.jpg	Deeper jungle	44	2018-03-18 06:46:55.767523	2018-03-18 06:48:09.98164	0	658cb100c7b2dbb7b1cbea1e15aca06e	f	\N
174	IMG_20180317_130333.jpg	Waterfall	44	2018-03-18 06:47:57.290895	2018-03-18 06:49:07.544483	0	89a966a47d81d623b3812d8c55005d2f	f	\N
175	IMG_20180317_133756.jpg	Worlds steepest Railway	44	2018-03-18 06:51:13.894544	2018-03-18 06:51:28.836527	50	490401ec69e8a26ea7f8402b90d84e64	f	\N
176	IMG_20180317_131331.jpg	Waterfall pools	44	2018-03-18 06:51:16.603007	2018-03-18 06:51:39.777357	50	7179771e1cfbfcf3111822a3cddabfca	f	\N
179	IMG_20180317_134616.jpg	Mineshaft	44	2018-03-18 06:52:10.581677	2018-03-18 07:00:02.516938	0	bf84f1b25be8b0331e97b8e37e1a5ef6	f	\N
178	IMG_20180317_140823.jpg	Takeoff	44	2018-03-18 06:52:00.825059	2018-03-18 07:04:15.729553	0	a60425838bff35c54f58e2e0d7e4374a	f	\N
164	IMG_20180317_105415.jpg	Bein' Goofy	44	2018-03-18 06:18:18.253366	2018-03-18 07:06:40.536699	100	61806380b33114cfa6f9d8e21cf5dd0f	f	\N
163	IMG_20180317_084728.jpg	The train ride	44	2018-03-18 06:15:34.661241	2018-03-18 07:07:01.380139	30	8d8f0911c7efd42bdb41f70861915eb7	f	\N
170	IMG_20180317_112833.jpg	Throw those duces UP	44	2018-03-18 06:42:07.812813	2018-03-18 07:10:02.394087	0	b995bc14b39227723b9c5f1728050df2	f	\N
172	IMG_20180317_115955.jpg	Crazy wild jungle	44	2018-03-18 06:42:58.28545	2018-03-18 07:13:56.217644	0	4e53af34c89d1ff022704237d69c0a95	f	\N
180	IMG_20180317_134929.jpg	Kissing Trees	44	2018-03-18 06:56:48.350389	2018-03-18 07:19:21.69337	0	06ad46c3c17520bcd0642e17386d6375	f	\N
189	set_up.jpg	Set up!	45	2018-04-03 12:10:11.867753	2018-04-03 13:21:11.834823	25	137b4109bade90ae688f8a14f1bc5e81	f	\N
192	eating.jpg	Eating at Night Yo!	45	2018-04-03 12:13:35.089598	2018-04-03 12:15:00.079953	0	5eeb734055005c0e43cd8701725b2ce6	f	\N
200	PANO_20190103_213947.jpg	Joe's Room	47	2019-01-06 10:08:43.369667	2019-01-06 10:09:10.151485	50	85b13ac36281ae3ba67f2f25b77eb45a	f	\N
193	IMG_20180401_134644.jpg	Coke Furnaces	45	2018-04-03 12:14:03.562583	2018-04-03 12:14:22.919744	50	9af94723a3d5ac83a356721345d3a8a4	f	\N
195	hotel.jpg	Hotel	45	2018-04-03 12:22:56.193788	2018-04-03 12:23:13.720479	50	999fa2af942d3388034fdfef336bcccc	f	\N
196	hike.jpg	Cross roads	45	2018-04-03 12:25:03.183369	2018-04-03 12:25:20.304237	50	587ab03a1133e8f685637f9daed36abb	f	\N
197	ruins.jpg	Ruins	45	2018-04-03 12:25:49.502692	2018-04-03 12:26:17.004828	50	4f67fe4613bce4e25ce650081c097ff6	f	\N
198	stream.jpg	Stream	45	2018-04-03 12:29:38.776181	2018-04-03 12:29:55.800686	50	36ad2234bab1186f1da4a2fcb287b4a7	f	\N
199	valley_2.jpg	Valley	45	2018-04-03 12:38:42.890968	2018-04-03 12:38:56.298097	50	383238efc26e49204def40a0fa943da7	f	\N
191	extra_night.jpg	Extra Nighty	45	2018-04-03 12:13:19.48282	2018-04-03 13:22:05.676877	17	1443101719312da2e3b361a1d7d21712	f	\N
202	PANO_20190530_230129.jpg	Night Time	47	2019-07-05 04:48:10.808196	2019-07-05 04:48:21.887824	50	f34304b7c913b7bde430583f23969da7	f	\N
208	R0010001.JPG	Kitchen Counter	50	2021-11-27 22:47:07.253825	2021-11-27 23:16:44.544775	0	845b831e55bd2947ee6571c87c8c515c	f	\N
212	R0010006.JPG	Basement Living Room	50	2021-11-27 22:48:26.245831	2021-11-27 23:25:29.355991	0	a50af1605a28b9523119425020b12b64	f	\N
209	R0010003.JPG	White Light Studio	50	2021-11-27 22:47:31.073861	2021-11-27 23:20:46.261148	0	712b784522588a22b4cb62b7af457e56	f	\N
211	R0010005.JPG	Top View - Living Room	50	2021-11-27 22:48:09.155525	2021-11-27 22:48:19.030639	50	cf0c60251abe7aa3c1da5e554f8fe628	f	\N
214	R0010009.JPG	Basement Hallway 2	50	2021-11-27 22:49:26.059034	2021-11-27 23:04:58.392778	0	c77682b3b1fbb97e49de919c3ec3c114	f	\N
217	R0010015.JPG	Ashley's Room	50	2021-11-27 22:50:12.491789	2021-11-27 23:06:24.851965	0	6cdb27b8c30c2990b33f2e65e8e528b7	f	\N
213	R0010008.JPG	Basement Hallway	50	2021-11-27 22:49:11.237672	2021-11-27 23:04:21.257865	3	0e75f8a05164c91b1ec5939d5eba0012	f	\N
215	R0010010.JPG	Basement Bathroom	50	2021-11-27 22:49:41.371143	2021-11-27 23:07:43.816659	0	cde5c6df6f7f7f83d8bb7ae606fc02ac	f	\N
216	R0010014.JPG	Laundry Room	50	2021-11-27 22:49:59.104996	2021-11-27 23:07:19.003958	0	792b834dbfdc4e8f58539c89f75496a9	f	\N
210	R0010004.JPG	Master Bedroom	50	2021-11-27 22:47:49.594539	2021-11-27 23:20:20.642544	0	f20a30fdfa9f07a2127113e11088a930	f	\N
218	R0010016.JPG	Backyard	50	2021-11-27 22:50:25.783589	2021-11-27 22:50:34.304003	50	12db41fae21b5911195da5173e6c428a	f	\N
219	R0010017.JPG	Backyard 2	50	2021-11-27 22:50:40.76804	2021-11-27 22:50:50.021783	50	2d8b814b1502b464ecaa2c4af718a2f1	f	\N
220	R0010020.JPG	Top Deck	50	2021-11-27 22:51:05.476477	2021-11-27 23:13:30.811543	0	f2cc31a6f08e051858162f2bff000c7e	f	\N
222	R0010030.JPG	Top Deck 2	50	2021-11-27 22:51:38.545549	2021-11-27 22:51:47.746906	50	9f7d19d44dadc1274e35f4d27886f278	f	\N
223	R0010031.JPG	Top Deck 3	50	2021-11-27 22:51:51.367873	2021-11-27 22:51:57.813115	50	84119b3b21bdba29c1088d38d7b46bf9	f	\N
227	R0010037.JPG	Side of House	50	2021-11-27 22:52:52.619751	2021-11-27 22:52:59.604787	50	de789d7e94f6a41733aaec91c261e2b8	f	\N
228	R0010039.JPG	Top Deck 4	50	2021-11-27 22:53:14.190774	2021-11-27 22:53:19.641669	50	3d9531f6131523f129d82e300e327ae0	f	\N
230	R0010042.JPG	Upstairs Living Room 2	50	2021-11-27 22:53:51.843662	2021-11-27 22:54:00.931009	50	c2cd9171c0230f4ab9d2e15fbd42219b	f	\N
234	R0010048.JPG	Upstairs Living Room 3	50	2021-11-27 22:55:14.58113	2021-11-27 22:55:20.285776	50	07b9d2f2d42891f80766ebe3e09444cc	f	\N
235	R0010050.JPG	Upstairs Bathroom	50	2021-11-27 22:55:29.605684	2021-11-27 22:55:34.795789	50	d6acea5f5b42d79285d5e7501c205ab8	f	\N
236	R0010052.JPG	Master Bedroom 2	50	2021-11-27 22:55:42.776371	2021-11-27 22:55:49.517211	50	c3d76e98c094e6ffede0d1453706bcfa	f	\N
225	R0010033.JPG	Front Door 2	50	2021-11-27 22:52:21.258694	2021-11-27 22:57:05.179681	0	325645e87a08b25c4085bbbd713ac53d	f	\N
224	R0010032.JPG	Spare Bedroom	50	2021-11-27 22:52:08.299141	2021-11-27 23:08:30.264954	0	854d7b83e29da597889f78dc30eb56ae	f	\N
232	R0010045.JPG	Kitchen Dining Room	50	2021-11-27 22:54:41.123511	2021-11-27 23:16:03.733155	0	01e56babec25908e2da8c6ef8d5a440d	f	\N
233	R0010047.JPG	Main Dining Room	50	2021-11-27 22:54:59.692499	2021-11-27 23:17:50.660271	0	8a341250155eaa53942dc2331ca43acf	f	\N
229	R0010040.JPG	Upstairs Living Room	50	2021-11-27 22:53:34.66141	2021-11-27 23:18:24.250253	0	822713d1acc17054c410bfec37de178a	f	\N
231	R0010043.JPG	Side of House 2	50	2021-11-27 22:54:17.458694	2021-11-27 23:23:12.643926	0	8d1fe2ccbeaef8f3d894fc9922301104	f	\N
226	R0010036.JPG	Front Yard	50	2021-11-27 22:52:38.332892	2021-11-27 23:23:36.100517	0	5146b5f2408f506ce71a774e901f232e	f	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: oefunbdfyixopx
--

COPY "public"."users" ("id", "name", "email", "created_at", "updated_at", "admin", "encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "sign_in_count", "current_sign_in_at", "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip", "confirmation_token", "confirmed_at", "confirmation_sent_at", "unconfirmed_email", "failed_attempts", "unlock_token", "locked_at") FROM stdin;
12468	Joe Gaebel	joe.gaebel+testsl@gmail.com	2023-02-21 01:01:37.696458	2023-02-21 01:01:37.696458	f	$2a$11$wTnXEi1smJKBzZnO3ZLR0.WVVJxMvI2VzkluUr9arYHqdEzVaI7si	\N	\N	\N	0	\N	\N	\N	\N	PQYWz8xNu4g957xBKk82	\N	2023-02-21 01:01:37.696582	\N	0	\N	\N
12214	Ashley Linkewich	hello@ashleylinkewich.com	2021-11-27 22:18:26.683831	2022-05-30 23:18:28.371555	f	$2a$11$p/Sdqt1e/0LGA1.11MXVH.7TOy8jzltgAcpoPWKTjWJALwzWFqE2u	\N	\N	\N	3	2022-05-30 23:18:28.369793	2021-11-27 23:00:20.316029	154.5.207.145	14.202.18.51	KeE__knrQFMcr9BMs6KP	2021-11-27 00:00:00	2021-11-27 22:18:26.683928	\N	1	\N	\N
11	TestAccount	ryarmst@gmail.com	2018-01-22 02:40:52.74862	2018-01-22 03:07:44.784967	f	$2a$11$sjqsKjx9dxOzzkV5fjvpceP8BwHtZe.n.1rQhfzb5wDg28JoTDzU.	\N	\N	\N	1	2018-01-22 03:02:45.148041	2018-01-22 03:02:45.148041	192.0.144.55	192.0.144.55	xQuDRbq1hpcXquoX3pVP	2018-01-22 02:45:36.851617	2018-01-22 02:40:52.748831	\N	0	\N	\N
12	Cool	contact.spherelink@gmail.com	2018-01-24 00:25:02.112239	2018-01-24 20:38:37.128577	f	$2a$11$ipGuTA1tn75bBMVAVm4A8eUTdHJHNoQaRNQVx7/QxJmtoFQKIvDem	\N	\N	\N	4	2018-01-24 20:38:37.125401	2018-01-24 19:41:34.562863	174.115.156.69	174.115.156.69	vs8J8xK27nRFheJKFx7b	2018-01-24 00:27:19.868019	2018-01-24 00:25:02.11272	\N	0	\N	\N
14	Dylan Harness	dharness.engineer@gmail.com	2018-01-25 02:32:09.624481	2018-01-25 02:33:26.71021	f	$2a$11$/MmF/MVA5oJq04nsFIClyeXNGmsY/jHW1iNle/KLw0l29CLErL9Wu	\N	\N	\N	1	2018-01-25 02:33:26.703311	2018-01-25 02:33:26.703311	99.108.139.246	99.108.139.246	7pWYrQey9pcWRVzQgDwM	2018-01-25 02:33:18.631348	2018-01-25 02:32:09.624746	\N	0	\N	\N
10	DMH	dylan@kingofthestack.com	2018-01-21 01:10:56.602645	2018-01-21 01:17:01.612008	f	$2a$11$BOrIPiJ02pIwXx.YBdoXMeXput7T8aFyQwG8KWz52akns5BSjYc82	\N	\N	\N	1	2018-01-21 01:17:01.599326	2018-01-21 01:17:01.599326	99.108.139.246	99.108.139.246	8KHR4XQLxrg7irsCno-5	2018-01-21 01:16:24.788969	2018-01-21 01:10:56.602905	\N	0	\N	\N
12469	Bryantep	srcdhfxkez@gmail.com	2023-02-22 10:40:45.924336	2023-02-22 10:40:45.924336	f	$2a$11$rM.aJt5XAFoXD6Dk4oWcZ.C8e3VcjF6AuZz6cUf0d7dG.yM/oiqvW	\N	\N	\N	0	\N	\N	\N	\N	x1yP8Q_ARyimsuoyMFBn	\N	2023-02-22 10:40:45.924529	\N	0	\N	\N
12470	AdrianDaype	klucanovamaria555@gmail.com	2023-03-01 10:50:24.98195	2023-03-01 10:50:24.98195	f	$2a$11$sbKLC1kbbyYa/1WIURKodufNU9usjR2bSRB06KteD/x/A/9daMqhO	\N	\N	\N	0	\N	\N	\N	\N	sw7VMrVzRzWVPtpQ1SQ2	\N	2023-03-01 10:50:24.982342	\N	0	\N	\N
12471	you_cash	elfridabolshakova901892@mail.ru	2023-03-08 02:42:05.14311	2023-03-08 02:42:05.14311	f	$2a$11$vC5Y5KtkhhE7r8E2v4oZIeglM4zKZjhr3VeOHP3AxHkZ7RPEABSwm	\N	\N	\N	0	\N	\N	\N	\N	kB92LKzvsA8ZR8o7y_s4	\N	2023-03-08 02:42:05.143278	\N	0	\N	\N
12527	Kabann	kabann854@gmail.com	2023-05-10 00:33:41.336915	2023-05-10 00:33:41.336915	f	$2a$11$t.0mZ10PYAWZuliZW4rgYu62YglCB/beWUUauL/mrJ3gXMsMdnbcq	\N	\N	\N	0	\N	\N	\N	\N	YY4r5qVyq8xNLcysnGZs	\N	2023-05-10 00:33:41.337003	\N	0	\N	\N
12473	CalvinWem	linki2022@yandex.by	2023-03-15 18:08:24.446326	2023-03-15 18:08:24.446326	f	$2a$11$yx8G1RoujIYSQgsTHdFXi.hUQTWCn6RTRZPsmq9bcSg.URaG.h.7m	\N	\N	\N	0	\N	\N	\N	\N	TYnEtmyepsEL3rNognPP	\N	2023-03-15 18:08:24.446549	\N	0	\N	\N
12474	Henrycex	denwirfskj@gmail.com	2023-03-15 22:19:45.566403	2023-03-15 22:19:45.566403	f	$2a$11$Qu3er0IdLqwMkIqQYYWhYOdJMvQ2LcK90LNmTYdsdBJfPoaxbbTiG	\N	\N	\N	0	\N	\N	\N	\N	pNSd2ozQBMNRWqxQKJW5	\N	2023-03-15 22:19:45.566599	\N	0	\N	\N
12472	CharlesTit	charlesiceve@seoqmail.com	2023-03-14 03:21:21.733404	2023-03-14 03:21:21.733404	f	$2a$11$JXdctA3q021sRp6fEsYR9.qcfiTqtUH9Ua7Ut53y7nlt96myemhlq	\N	\N	\N	0	\N	\N	\N	\N	Zmjcac_LpmiL-1BrxQfN	\N	2023-03-14 03:21:21.733901	\N	4	\N	\N
12475	Thomasunath	meyer.e.s.k.r.i.s.t.e.l@gmail.com	2023-03-16 04:24:30.831999	2023-03-16 04:24:30.831999	f	$2a$11$gvcOMC7cE3Lqt0e7YDDfROsDeIch0ycRc1WhBzdzPWFSbfC9CFS12	\N	\N	\N	0	\N	\N	\N	\N	KVkcRrrAjBD-UNZ-P9Hb	\N	2023-03-16 04:24:30.832245	\N	0	\N	\N
12476	TerryGom	me.l.o.d.eemc.kghe.i.gh@gmail.com	2023-03-19 20:00:01.9694	2023-03-19 20:00:01.9694	f	$2a$11$nkxUqpdKSciefQPssqGTru9hod7EBj0l.xm9fXSbjJhw8cXuEUAgG	\N	\N	\N	0	\N	\N	\N	\N	3_a7LfZMhnpxSDw6fbeS	\N	2023-03-19 20:00:01.96958	\N	0	\N	\N
12477	Thomasnaf	hutigese@gmail.com	2023-03-21 01:25:24.200748	2023-03-21 01:25:24.200748	f	$2a$11$bUP40aZNsGbbI3odjGj7oO4C9LgjHrC4s7uSkPQlGZcnkfjCjvPei	\N	\N	\N	0	\N	\N	\N	\N	8WkKQqsBvasLxy3bYnr3	\N	2023-03-21 01:25:24.200916	\N	0	\N	\N
12478	Brucerew	nihatdemirov7288@gmail.com	2023-03-25 22:55:44.294517	2023-03-25 22:55:44.294517	f	$2a$11$tisGgPFl7iTvCODXdA.4yudmCNAi/ArF.1r02z6mQKPKrChnZg.uO	\N	\N	\N	0	\N	\N	\N	\N	yzaYCcs1GVLfJ84JvcUT	\N	2023-03-25 22:55:44.294707	\N	0	\N	\N
12479	Frankvak	armaanamalkhan485@gmail.com	2023-03-31 05:50:40.599424	2023-03-31 05:50:40.599424	f	$2a$11$BRTBdicHnZ9kypybLsTUuu.Wq0.v85kKNsslIjTijxr8vTzPUMxM2	\N	\N	\N	0	\N	\N	\N	\N	hdEZvS2sNTi3_DFPRg7Q	\N	2023-03-31 05:50:40.599589	\N	0	\N	\N
12512	Rogercog	piter_norton@gmail.com	2023-04-10 19:01:58.521755	2023-04-10 19:01:58.521755	f	$2a$11$eQE0cPuU1i6vZfBx8LsGEOOWrwOMi44gME0E4mdAYQt0sy.5PlvCy	\N	\N	\N	0	\N	\N	\N	\N	h1jB-SonLAtZg12e9KEh	\N	2023-04-10 19:01:58.521921	\N	0	\N	\N
12513	EddieNoice	9sr1kk3twupk@softdisc.site	2023-04-11 17:26:23.599101	2023-04-11 17:26:23.599101	f	$2a$11$cqVuDqJHK2Snb2f5hjydWuW2juoWpflZzBD.G0hi3rh7t7yq.QdyS	\N	\N	\N	0	\N	\N	\N	\N	6sFg1hg8zkdezhD_eWwp	\N	2023-04-11 17:26:23.599574	\N	0	\N	\N
12514	MatthewHenue	giuliomazzan94@gmail.com	2023-04-13 00:49:09.046278	2023-04-13 00:49:09.046278	f	$2a$11$t1u2AF9YEbz0ynT7voef5OIutyBYG4/nT1WU4cCkmDWn8fUMwIjX6	\N	\N	\N	0	\N	\N	\N	\N	YkrpRwLcibLKzg-yq6aw	\N	2023-04-13 00:49:09.046412	\N	0	\N	\N
12517	Shannonnek	svtowu9g9jlk@softdisc.site	2023-04-17 06:38:30.577129	2023-04-17 06:38:30.577129	f	$2a$11$ekqTHhI2yunBTnFYuG.RY.Ae4WC..rJt47oKX.EbBiSrSDYGWhC2S	\N	\N	\N	0	\N	\N	\N	\N	gLWoxffcGgSi5iiwkTpQ	\N	2023-04-17 06:38:30.579146	\N	0	\N	\N
12518	Joshuabrern	doughann200@gmail.com	2023-04-17 19:02:31.302257	2023-04-17 19:02:31.302257	f	$2a$11$9wwAbeO.fHX3IkfLjK0Sm.2.Mm7dOmjxNjftlsKWlaSKE1McxzYeO	\N	\N	\N	0	\N	\N	\N	\N	iZoNyFforkbm4KjPqPkE	\N	2023-04-17 19:02:31.302403	\N	0	\N	\N
12519	Rolandoraf	kturyiet@gmail.com	2023-04-19 11:26:05.187824	2023-04-19 11:26:05.187824	f	$2a$11$fnrt68Dp1OcP3zyAje2vcOdWtOYARJnNIZFYN8d0yCdIpkEnw2AAe	\N	\N	\N	0	\N	\N	\N	\N	yjEzuKGCHFTZwNyx-fGE	\N	2023-04-19 11:26:05.188937	\N	0	\N	\N
12520	Arthurpug	kari_norton@gmail.com	2023-04-19 17:09:32.345086	2023-04-19 17:09:32.345086	f	$2a$11$HqL7.9pw0OQOUqIdzMuuVuOBygzofW425kvjZcyW5EwVwBSyOfUYq	\N	\N	\N	0	\N	\N	\N	\N	tHkf-H9qnM4uSv7nfQtL	\N	2023-04-19 17:09:32.345175	\N	0	\N	\N
12516	Ernastcig	charlesiceve@gseomail.com	2023-04-15 10:36:02.156108	2023-04-15 10:36:02.156108	f	$2a$11$Vug.B79spTN5MXRVfv9ZduRhDmGk29/xd2lHwLJxB2/yPNw1hR1U2	\N	\N	\N	0	\N	\N	\N	\N	z6WbZz5AysW7ob6JdXud	\N	2023-04-15 10:36:02.156268	\N	2	\N	\N
12521	Arthurpug	truman19861@rambler.ru	2023-04-21 00:15:40.353829	2023-04-21 00:15:40.353829	f	$2a$11$6RHnmMhfFNWkxrJx/2f0MO.OX1lqSVKqkvb9tjXxk78spusMOEKBa	\N	\N	\N	0	\N	\N	\N	\N	CPxqNa_KgPhxqeHP7-Ev	\N	2023-04-21 00:15:40.353974	\N	1	\N	\N
12529	Michaelwat	bo1fjbixmbut@softdisc.site	2023-05-16 11:10:22.924881	2023-05-16 11:10:22.924881	f	$2a$11$wuRIk0Bap4K3zRnIUZC/l.FPSr8EjJkoiRwp8DSMnMWdCJjmIQ1Aq	\N	\N	\N	0	\N	\N	\N	\N	5pssHhTFqYzVD4DzEq5K	\N	2023-05-16 11:10:22.92502	\N	0	\N	\N
12522	Darwinher	walshedmond409@gmail.com	2023-04-23 03:24:42.923811	2023-04-23 03:24:42.923811	f	$2a$11$hObYtI.DqF8pKMBEXEkTxOdGlBIYRxFNHMfpR32bon3pFo13uCv3y	\N	\N	\N	0	\N	\N	\N	\N	Avhdq5JT9v3hGy4fsEZ5	\N	2023-04-23 03:24:42.923944	\N	0	\N	\N
12528	Rolandoraf	krinzgov85@gmail.com	2023-05-13 07:29:57.04145	2023-05-13 07:29:57.04145	f	$2a$11$VPq9Ah.wcWE/x2rZUBbTJOR.tcZNT6mBSm7CLTiC/Ixe4uhrM7RfS	\N	\N	\N	0	\N	\N	\N	\N	A4qS_2PN9vhucQq7xiWx	\N	2023-05-13 07:29:57.04159	\N	3	\N	\N
12515	HyctorSwons	hectortit@gseomail.com	2023-04-14 10:43:30.184694	2023-04-14 10:43:30.184694	f	$2a$11$cjrFhYKirsqzng0NpiGFvuBF5f3yhosji30Unr.mdTcMOroXr5Ram	\N	\N	\N	0	\N	\N	\N	\N	pQegs2yQzWfL8fsQM8Yi	\N	2023-04-14 10:43:30.184836	\N	3	\N	\N
12523	GeraldTobrE	marchelltheovedeangel@gmail.com	2023-04-28 19:35:00.448661	2023-04-28 19:35:00.448661	f	$2a$11$IwH7oOItc04nKKTRTQJSAO53pEGBLQjNm92cwPOleCnH.h1s7LbGy	\N	\N	\N	0	\N	\N	\N	\N	Hkuyiwek-7yZVfNLW1CD	\N	2023-04-28 19:35:00.448798	\N	0	\N	\N
12524	DavidFrori	beruorenburg@ya.ru	2023-05-08 05:55:03.658447	2023-05-08 05:55:03.658447	f	$2a$11$rnw3Mzoq2JI7avt3TrWiTOSS6heuY5mSONTjESVbCc3nCGaAQHXj6	\N	\N	\N	0	\N	\N	\N	\N	SHjB3MMzi4jPfqwsGUSx	\N	2023-05-08 05:55:03.658601	\N	0	\N	\N
12525	Michaelwat	1xkt9u6s395c@softdisc.site	2023-05-09 12:09:31.178955	2023-05-09 12:09:31.178955	f	$2a$11$MpDbFX/o47UFPbn6LaCOCejWcJ7FyGXJcUl1v40EZPp5xAuDKaoYa	\N	\N	\N	0	\N	\N	\N	\N	o_ksF8tk1y2MquSyy9td	\N	2023-05-09 12:09:31.179086	\N	0	\N	\N
12526	DavidChold	gprof@free-private-mail.com	2023-05-09 23:32:51.012875	2023-05-09 23:32:51.012875	f	$2a$11$TqZHxLpCV4.ImzJ4DwYUWOQr8RpZbFmeAKEUSSzgkof8Z7mo/hxUu	\N	\N	\N	0	\N	\N	\N	\N	TThERwDQmsNWymZoyzvM	\N	2023-05-09 23:32:51.013027	\N	0	\N	\N
12530	StevenDot	jasonynicholelittl@gmail.com	2023-05-18 17:19:34.967617	2023-05-18 17:19:34.967617	f	$2a$11$3U3AQGvHLFzAW71tpyyEIOTsQCEhj0BJfr393/.e3T5nPzD.bGcqi	\N	\N	\N	0	\N	\N	\N	\N	xBK5qzGy6zV9xhEQRTnG	\N	2023-05-18 17:19:34.96775	\N	0	\N	\N
1	Joe	joe.gaebel@hotmail.com	2017-06-05 07:15:45.064779	2022-05-30 23:17:31.322838	t	$2a$11$gdrFi3oiZQXES/a04dpoduDaA2NGKHyyENTAHFz4fg9FbGDiIk4Bm	\N	\N	\N	127	2022-05-30 23:17:31.31932	2022-04-27 05:38:44.312524	154.5.207.145	118.210.112.113	uBj_AGyLvGKsmD7u5JjZ	2018-01-03 20:17:13.376547	2018-01-03 20:15:36.086283	\N	0	\N	\N
\.


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."delayed_jobs_id_seq"', 263, true);


--
-- Name: markers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."markers_id_seq"', 111, true);


--
-- Name: memories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."memories_id_seq"', 50, true);


--
-- Name: microposts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."microposts_id_seq"', 1, false);


--
-- Name: portals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."portals_id_seq"', 340, true);


--
-- Name: sound_contexts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."sound_contexts_id_seq"', 3, true);


--
-- Name: sounds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."sounds_id_seq"', 3, true);


--
-- Name: spheres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."spheres_id_seq"', 236, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oefunbdfyixopx
--

SELECT pg_catalog.setval('"public"."users_id_seq"', 12530, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."ar_internal_metadata"
    ADD CONSTRAINT "ar_internal_metadata_pkey" PRIMARY KEY ("key");


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."delayed_jobs"
    ADD CONSTRAINT "delayed_jobs_pkey" PRIMARY KEY ("id");


--
-- Name: markers markers_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."markers"
    ADD CONSTRAINT "markers_pkey" PRIMARY KEY ("id");


--
-- Name: memories memories_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."memories"
    ADD CONSTRAINT "memories_pkey" PRIMARY KEY ("id");


--
-- Name: microposts microposts_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."microposts"
    ADD CONSTRAINT "microposts_pkey" PRIMARY KEY ("id");


--
-- Name: portals portals_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."portals"
    ADD CONSTRAINT "portals_pkey" PRIMARY KEY ("id");


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."schema_migrations"
    ADD CONSTRAINT "schema_migrations_pkey" PRIMARY KEY ("version");


--
-- Name: sound_contexts sound_contexts_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."sound_contexts"
    ADD CONSTRAINT "sound_contexts_pkey" PRIMARY KEY ("id");


--
-- Name: sounds sounds_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."sounds"
    ADD CONSTRAINT "sounds_pkey" PRIMARY KEY ("id");


--
-- Name: spheres spheres_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."spheres"
    ADD CONSTRAINT "spheres_pkey" PRIMARY KEY ("id");


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "delayed_jobs_priority" ON "public"."delayed_jobs" USING "btree" ("priority", "run_at");


--
-- Name: index_markers_on_guid; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_markers_on_guid" ON "public"."markers" USING "btree" ("guid");


--
-- Name: index_markers_on_sphere_id; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_markers_on_sphere_id" ON "public"."markers" USING "btree" ("sphere_id");


--
-- Name: index_memories_on_user_id; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_memories_on_user_id" ON "public"."memories" USING "btree" ("user_id");


--
-- Name: index_microposts_on_user_id; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_microposts_on_user_id" ON "public"."microposts" USING "btree" ("user_id");


--
-- Name: index_microposts_on_user_id_and_created_at; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_microposts_on_user_id_and_created_at" ON "public"."microposts" USING "btree" ("user_id", "created_at");


--
-- Name: index_sound_contexts_on_context_type_and_context_id; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_sound_contexts_on_context_type_and_context_id" ON "public"."sound_contexts" USING "btree" ("context_type", "context_id");


--
-- Name: index_sound_contexts_on_sound_id; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_sound_contexts_on_sound_id" ON "public"."sound_contexts" USING "btree" ("sound_id");


--
-- Name: index_spheres_on_guid; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_spheres_on_guid" ON "public"."spheres" USING "btree" ("guid");


--
-- Name: index_spheres_on_memory_id; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE INDEX "index_spheres_on_memory_id" ON "public"."spheres" USING "btree" ("memory_id");


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE UNIQUE INDEX "index_users_on_confirmation_token" ON "public"."users" USING "btree" ("confirmation_token");


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE UNIQUE INDEX "index_users_on_email" ON "public"."users" USING "btree" ("email");


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "public"."users" USING "btree" ("reset_password_token");


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: oefunbdfyixopx
--

CREATE UNIQUE INDEX "index_users_on_unlock_token" ON "public"."users" USING "btree" ("unlock_token");


--
-- Name: microposts fk_rails_558c81314b; Type: FK CONSTRAINT; Schema: public; Owner: oefunbdfyixopx
--

ALTER TABLE ONLY "public"."microposts"
    ADD CONSTRAINT "fk_rails_558c81314b" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

