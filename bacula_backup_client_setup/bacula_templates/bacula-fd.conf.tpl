Director {
  Name = ${backup_server_hostname}-dir
  Password = "${bacula_backup_pass}"
}

Director {
  Name = ${backup_server_hostname}-mon
  Password = "${bacula_backup_pass}"
  Monitor = yes
}

FileDaemon {
  Name = ${bacula_backup_client_hostname}-fd
  FDport = 9102
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 50
  Plugin Directory = /usr/lib/bacula
  FDAddress = ${bacula_backup_client_ip}
}

Messages {
  Name = Standard
  director = ${backup_server_hostname}-dir = all, !skipped, !restored
}
