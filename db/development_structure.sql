CREATE TABLE "bdrb_job_queues" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "args" text, "worker_name" varchar(255), "worker_method" varchar(255), "job_key" varchar(255), "taken" integer, "finished" integer, "timeout" integer, "priority" integer, "submitted_at" datetime, "started_at" datetime, "finished_at" datetime, "archived_at" datetime, "tag" varchar(255), "submitter_info" varchar(255), "runner_info" varchar(255), "worker_key" varchar(255), "scheduled_at" datetime);
CREATE TABLE "genres" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "genres_video_contents" ("video_content_id" integer, "genre_id" integer);
CREATE TABLE "media_folders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "location" varchar(255), "scan" boolean, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "tv_episodes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "plot" varchar(255), "series" integer, "episode" integer, "date" date, "video_file_reference_id" integer, "created_at" datetime, "updated_at" datetime, "tv_show_id" integer);
CREATE TABLE "user_sessions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" varchar(255) NOT NULL, "data" text, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime, "updated_at" datetime, "login" varchar(255) NOT NULL, "crypted_password" varchar(255) NOT NULL, "password_salt" varchar(255) NOT NULL, "persistence_token" varchar(255) NOT NULL, "login_count" integer DEFAULT 0 NOT NULL, "last_request_at" datetime, "last_login_at" datetime, "current_login_at" datetime, "last_login_ip" varchar(255), "current_login_ip" varchar(255));
CREATE TABLE "video_contents" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "year" integer, "plot" varchar(255), "state" varchar(255), "imdb_id" varchar(255), "language" varchar(255), "tag_line" varchar(255), "runtime" integer, "release_date" date, "director" varchar(255), "type" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "video_file_properties" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "value" varchar(255), "order" integer, "video_file_reference_id" integer, "created_at" datetime, "updated_at" datetime, "group" varchar(255));
CREATE TABLE "video_file_references" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "raw_name" varchar(255), "location" varchar(255), "on_disk" boolean, "media_folder_id" integer, "video_content_id" integer, "created_at" datetime, "updated_at" datetime, "size" integer, "format" varchar(255));
CREATE TABLE "video_posters" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "size" varchar(255), "location" varchar(255), "height" integer, "width" integer, "video_content_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "watches" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "video_content_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_genres_video_contents_on_genre_id" ON "genres_video_contents" ("genre_id");
CREATE INDEX "index_genres_video_contents_on_video_content_id" ON "genres_video_contents" ("video_content_id");
CREATE INDEX "index_user_sessions_on_session_id" ON "user_sessions" ("session_id");
CREATE INDEX "index_user_sessions_on_updated_at" ON "user_sessions" ("updated_at");
CREATE INDEX "index_users_on_last_request_at" ON "users" ("last_request_at");
CREATE INDEX "index_users_on_login" ON "users" ("login");
CREATE INDEX "index_users_on_persistence_token" ON "users" ("persistence_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20100417042758');

INSERT INTO schema_migrations (version) VALUES ('20100205232136');

INSERT INTO schema_migrations (version) VALUES ('20100205232427');

INSERT INTO schema_migrations (version) VALUES ('20100205232617');

INSERT INTO schema_migrations (version) VALUES ('20100205232757');

INSERT INTO schema_migrations (version) VALUES ('20100216083451');

INSERT INTO schema_migrations (version) VALUES ('20100225084545');

INSERT INTO schema_migrations (version) VALUES ('20100225084617');

INSERT INTO schema_migrations (version) VALUES ('20100225085439');

INSERT INTO schema_migrations (version) VALUES ('20100225085958');

INSERT INTO schema_migrations (version) VALUES ('20100301084706');

INSERT INTO schema_migrations (version) VALUES ('20100316091637');

INSERT INTO schema_migrations (version) VALUES ('20100316092511');

INSERT INTO schema_migrations (version) VALUES ('20100322053618');

INSERT INTO schema_migrations (version) VALUES ('20100414103921');

INSERT INTO schema_migrations (version) VALUES ('20100415090150');