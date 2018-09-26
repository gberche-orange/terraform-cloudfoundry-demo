provider "cloudfoundry" {
  api_url             = "https://api.run.pivotal.io"
  user                = "${var.tf_cf_login}"
  password            = "${var.tf_cf_password}"
  skip_ssl_validation = true
}

data "cloudfoundry_org" "my_org" {
  name = "bercheg-org"
}

resource "cloudfoundry_user" "demo-user" {
  name = "demo@mydomain.com"
  password = "this-account-wont-last-long"
}

resource "cloudfoundry_space" "my_space" {
  name = "demo-basel"
  org = "${data.cloudfoundry_org.my_org.id}"
  developers = [
    "${cloudfoundry_user.demo-user.id}",
    //PWS does not allow to lookup users by email, even ourselves
    //"${data.cloudfoundry_user.myself.id}",
    "526cc2f7-3d07-4e04-85b2-e3c96282541c"
     //workaround is to fetch guid from CF CLI:
     //CF_TRACE=true cf org-users bercheg-org | grep -B10 '"username": "bercheg@gmail.com"' | grep '"guid"'
  ]
}

//data "cloudfoundry_user" "myself" {
//  name = "bercheg@gmail.com"
//}


data "cloudfoundry_service" "elephantsql" {
  name = "elephantsql"
}

resource "cloudfoundry_service_instance" "my_mysql" {
  name = "my_mysql"
  service_plan = "${data.cloudfoundry_service.elephantsql.service_plans["turtle"]}"
  space = "${cloudfoundry_space.my_space.id}"
}

