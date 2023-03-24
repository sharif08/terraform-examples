Client {
  Name = ${bacula_backup_client_hostname}-fd
  Address = ${bacula_backup_client_ip}
  FDPort = 9102
  Catalog = MyCatalog
  Password = "${bacula_backup_pass}"
  File Retention = 30 days
  Job Retention = 6 months
  AutoPrune = yes
}

JobDefs {
  Name = "${bacula_backup_client_hostname}-job"
  Type = Backup
  Level = Differential
  Client = ${bacula_backup_client_hostname}-fd
  FileSet = "${bacula_backup_client_hostname}-fileset"
  Schedule = "WeeklyCycle"
  Storage = File1
  Messages = Standard
  Pool = ${bacula_backup_client_hostname}-pool
  Priority = 10
  Write Bootstrap = "/etc/bacula/bootstrap/${bacula_backup_client_hostname}.bsr"
}

Job {
  Name = "${bacula_backup_client_hostname}-Backup"
  Client = ${bacula_backup_client_hostname}-fd
  JobDefs = "${bacula_backup_client_hostname}-job"
}

Job {
  Name = "${bacula_backup_client_hostname}-Restore"
  Type = Restore
  Client= ${bacula_backup_client_hostname}-fd
  FileSet= "${bacula_backup_client_hostname}-fileset"
  Storage = File1
  Pool = ${bacula_backup_client_hostname}-pool
  Messages = Standard
  Where = ${bacula_backup_restore_dir}/${bacula_backup_client_hostname}
  Write Bootstrap = "/etc/bacula/bootstrap/${bacula_backup_client_hostname}.bsr"
}

Pool {
  Name = ${bacula_backup_client_hostname}-pool
  Pool Type = Backup
  Recycle = yes
  Label Format = Vol-${bacula_backup_client_hostname}-
  AutoPrune = yes
  Volume Retention = 99 days
  Maximum Volume Bytes = 50G
  Maximum Volume Jobs = 100
  Maximum Volumes = 100
  Volume Use Duration = 23h
}

FileSet {
  Name = "${bacula_backup_client_hostname}-fileset"
  Include {
    File = /etc
    File = /home
    Options {
      signature = MD5
      compression=gzip
    }
  }
  Exclude {
  }
}
