#! /bin/bash

mysqldump -u root -proot --hex-blob --single-transaction --ignore-table={db.Session,db.Error,db.BufferedMail,db.File} --databases db --result-file=main.sql
mysqldump -u root -proot --routines --triggers --events --hex-blob --skip-extended-insert --complete-insert --single-transaction --max_allowed_packet=1G --result-file=files.sql db File
mysqldump -u root -proot --hex-blob --single-transaction --no-data --result-file=error.sql db Error
mysqldump -u root -proot --hex-blob --single-transaction --no-data --result-file=session.sql db Session
mysqldump -u root -proot --hex-blob --single-transaction --no-data --result-file=buffered_mail.sql db BufferedMail

cat main.sql error.sql files.sql session.sql buffered_mail.sql > backup.sql
rm main.sql error.sql files.sql session.sql buffered_mail.sql

exit 0
