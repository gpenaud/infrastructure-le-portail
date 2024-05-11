
database-restore:
	scp backups/backup.sql gpenaud@new-alterconso.leportail.org:/tmp/
	# EXECUTE ON VPS : docker cp /tmp/backup.sql $$(docker compose ps -q alterconso-mysql):/backup.sql ; docker compose exec alterconso-mysql sh -c "mysql -u docker -pdocker db  < backup.sql