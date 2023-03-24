object Endpoint "${icinga2_server_container_name}" {
}

object Zone "master" {
	endpoints = [ "${icinga2_server_container_name}" ]
}

// Endpoints & Zones
object Endpoint "${icinga2_client_hostname}" {
     host="${icinga2_client_ip}"
     port="5665"

}


object Zone "${icinga2_client_hostname}" {
     endpoints = [ "${icinga2_client_hostname}" ]
     parent = "master"
}
