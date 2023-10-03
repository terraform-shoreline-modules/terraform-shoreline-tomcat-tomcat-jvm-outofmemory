resource "shoreline_notebook" "tomcat_jvm_outofmemory_incident" {
  name       = "tomcat_jvm_outofmemory_incident"
  data       = file("${path.module}/data/tomcat_jvm_outofmemory_incident.json")
  depends_on = [shoreline_action.invoke_tomcat_memory_leak_detection,shoreline_action.invoke_memory_tomcat_restart]
}

resource "shoreline_file" "tomcat_memory_leak_detection" {
  name             = "tomcat_memory_leak_detection"
  input_file       = "${path.module}/data/tomcat_memory_leak_detection.sh"
  md5              = filemd5("${path.module}/data/tomcat_memory_leak_detection.sh")
  description      = "Memory Leak: One of the possible reasons for the Tomcat JVM OutOfMemory incident could be a memory leak in the application causing it to consume all available memory."
  destination_path = "/agent/scripts/tomcat_memory_leak_detection.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "memory_tomcat_restart" {
  name             = "memory_tomcat_restart"
  input_file       = "${path.module}/data/memory_tomcat_restart.sh"
  md5              = filemd5("${path.module}/data/memory_tomcat_restart.sh")
  description      = "Increase the memory allocation for the Tomcat server by modifying its configuration files."
  destination_path = "/agent/scripts/memory_tomcat_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_tomcat_memory_leak_detection" {
  name        = "invoke_tomcat_memory_leak_detection"
  description = "Memory Leak: One of the possible reasons for the Tomcat JVM OutOfMemory incident could be a memory leak in the application causing it to consume all available memory."
  command     = "`chmod +x /agent/scripts/tomcat_memory_leak_detection.sh && /agent/scripts/tomcat_memory_leak_detection.sh`"
  params      = ["THRESHOLD"]
  file_deps   = ["tomcat_memory_leak_detection"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_memory_leak_detection]
}

resource "shoreline_action" "invoke_memory_tomcat_restart" {
  name        = "invoke_memory_tomcat_restart"
  description = "Increase the memory allocation for the Tomcat server by modifying its configuration files."
  command     = "`chmod +x /agent/scripts/memory_tomcat_restart.sh && /agent/scripts/memory_tomcat_restart.sh`"
  params      = []
  file_deps   = ["memory_tomcat_restart"]
  enabled     = true
  depends_on  = [shoreline_file.memory_tomcat_restart]
}

