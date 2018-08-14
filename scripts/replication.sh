# -----------------------------------------------------------
# Set up PostgreSQL database replication from Master to Slave
# -----------------------------------------------------------

#----------------------#
#------- Master -------#
#----------------------#

# Add this to /etc/postgresql/9.3/main/pg_hba.conf:
host	replication		all     159.203.37.171/32	md5

# Edit /etc/postgresql/9.3/main/postgresql.conf
wal_level = hot_standby
max_wal_senders = 3
wal_keep_segments = 32

# Restart postgresql
sudo service postgresql restart

#---------------------#
#------- Slave -------#
#---------------------#
#Stop postgres
service postgresql stop

# Edit /etc/postgresql/9.3/main/postgresql.conf
hot_standby = on

#Empty the data folder
sudo -i rm -rf /var/lib/postgresql/9.3/main/*

#Create base backup and copy o to the slave
su postgres -c 'pg_basebackup -h 61.28.227.65 -U postgres -D /var/lib/postgresql/9.3/main/ --xlog-method=stream -P -v'

#Create /var/lib/postgresql/9.3/main/recovery.conf
standby_mode = 'on'
primary_conninfo = 'host=61.28.227.65'
trigger_file = '/var/lib/postgresql/9.3/main/TAKEOVER'

# Start postgres
service postgresql start

# Check if it works
ps auxf | grep postgre

# Has to be in the output:
postgres  4359  0.0  0.3 295304  7128 ?        Ss   21:05   0:00  \_ postgres: startup process   recovering 0000000100000001000000D1
postgres  4363  0.1  0.5 306208 10952 ?        Ss   21:05   0:00  \_ postgres: wal receiver process   streaming 1/D1051088

# -----------------------------------------------------------
# Disaster recovery. All on Slave
# -----------------------------------------------------------
touch /var/lib/postgresql/9.3/main/TAKEOVER