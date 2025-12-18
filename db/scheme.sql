BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "edu_plan" (
	"spec_id"	INTEGER,
	"spec_name"	TEXT NOT NULL,
	"subject"	TEXT NOT NULL,
	"semester"	INTEGER NOT NULL CHECK("semester" IN (1, 2)),
	"plan_hours"	INTEGER NOT NULL,
	"exam"	TEXT NOT NULL CHECK("exam" IN ('Зачет', 'Экзамен')),
	PRIMARY KEY("spec_id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "journal" (
	"j_id"	INTEGER,
	"semester"	INTEGER NOT NULL CHECK("semester" IN (1, 2)),
	"year"	TEXT,
	"student_id"	INTEGER,
	"spec_id"	INTEGER,
	"grade"	INTEGER CHECK("grade" IN (1, 2, 3, 4, 5)),
	PRIMARY KEY("j_id" AUTOINCREMENT),
	FOREIGN KEY("spec_id") REFERENCES "edu_plan"("spec_id"),
	FOREIGN KEY("student_id") REFERENCES "students"("student_id")
);
CREATE TABLE IF NOT EXISTS "students" (
	"student_id"	INTEGER,
	"f_name"	TEXT NOT NULL,
	"s_name"	TEXT NOT NULL,
	"p_name"	TEXT,
	"date_entry"	TEXT NOT NULL,
	"format"	TEXT NOT NULL CHECK("format" IN ('Дневная', 'Заочная', 'Вечерняя')),
	"group_num"	INTEGER NOT NULL,
	PRIMARY KEY("student_id" AUTOINCREMENT)
);
INSERT INTO "edu_plan" VALUES (1,'Кибербезопасность','DevOps',1,56,'Зачет');
INSERT INTO "edu_plan" VALUES (2,'Биг дата','Мат. стат',2,128,'Экзамен');
INSERT INTO "edu_plan" VALUES (3,'САПР','Коммункации в IT',1,48,'Зачет');
INSERT INTO "edu_plan" VALUES (4,'Информационная безопасность','Веб-технологии',2,72,'Экзамен');
INSERT INTO "edu_plan" VALUES (5,'Дизайн','ui/ux-дизайн',1,35,'Зачет');
INSERT INTO "edu_plan" VALUES (6,'Биг дата','Мат. стат',2,128,'Экзамен');
INSERT INTO "journal" VALUES (1,1,'2023',1,1,5);
INSERT INTO "journal" VALUES (2,2,'2023',2,2,3);
INSERT INTO "journal" VALUES (3,1,'2025',3,3,5);
INSERT INTO "journal" VALUES (4,2,'2025',4,4,5);
INSERT INTO "journal" VALUES (5,2,'2025',5,4,4);
INSERT INTO "journal" VALUES (6,2,'2025',5,5,3);
INSERT INTO "journal" VALUES (17,2,'2023',11,2,3);
INSERT INTO "students" VALUES (1,'Альберт','Альбертов','Альбертович','01-09-2023','Дневная',231);
INSERT INTO "students" VALUES (2,'Тест','Тестов',NULL,'01-09-2023','Вечерняя',143);
INSERT INTO "students" VALUES (3,'Антон','Антонов','Антонович','05-01-2025','Заочная',125);
INSERT INTO "students" VALUES (4,'Андрей','Курбатов','Кирилович','01-09-2025','Дневная',225);
INSERT INTO "students" VALUES (5,'Михаил','Курбатов','Кирилович','01-09-2025','Дневная',225);
INSERT INTO "students" VALUES (11,'Олег','Лобанов',NULL,'01-09-2023','Вечерняя',143);
COMMIT;
