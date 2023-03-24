// Endpoints & Zones
object Endpoint "${icinga2_client_hostname}" {
     host="${icinga2_client_ip}"
     port="5665"
}

object Zone "${icinga2_client_hostname}" {
     endpoints = [ "${icinga2_client_hostname}" ]
     parent = "master"
}

// Host Objects
object Host "${icinga2_client_hostname}" {
    check_command = "hostalive"
    address = "${icinga2_client_ip}"
    vars.client_endpoint = name
    vars.os = "${icinga2_client_os}"
    vars.os_name = "${icinga2_client_os_name}"
    vars.os_version = "${icinga2_client_os_version}"
    vars.service_var = "${icinga2_client_service_var}"
    vars.notify = "true"
}

