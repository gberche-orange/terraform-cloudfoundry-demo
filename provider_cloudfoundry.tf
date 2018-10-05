provider "cloudfoundry" {
  api_url             = "https://api.run.pivotal.io"
  user                = "${var.tf_cf_login}"
  password            = "${var.tf_cf_password}"
  skip_ssl_validation = true
}

//variable "tf_cf_password" {
//  default="redacted"
//}
//variable "tf_cf_login" {
//  default="bercheg@redacted.com"
//}


data "cloudfoundry_org" "my_org" {
  name = "bercheg-org"
}

resource "cloudfoundry_space" "demo-basel" {
  name = "demo-basel"
  org = "${data.cloudfoundry_org.my_org.id}"
  developers = [
    //PWS does not allow to lookup users by email, even ourselves
    //"${data.cloudfoundry_user.myself.id}",

    //Refering to an existing user by its guid
    "526cc2f7-3d07-4e04-85b2-e3c96282541c"
    //workaround is to fetch guid from CF CLI:
    //CF_TRACE=true cf org-users bercheg-org | grep -B10 '"username": "bercheg"' | grep '"guid"'

    // PWS does not allow for users creation using CC API, requires webui UX
    //    "${cloudfoundry_user.demo-user.id}",

  ]
}

data "cloudfoundry_service" "elephantsql" {
  name = "elephantsql"
}

resource "cloudfoundry_service_instance" "my_mysql" {
  name = "my_mysql"
  service_plan = "${data.cloudfoundry_service.elephantsql.service_plans["turtle"]}"
  space = "${cloudfoundry_space.demo-basel.id}"
}

data "cloudfoundry_domain" "default_domain" {
  name = "cfapps.io"
}

resource "cloudfoundry_route" "dora-tf-demo" {
  domain = "${data.cloudfoundry_domain.default_domain.id}"
  space = "${cloudfoundry_space.demo-basel.id}"
  hostname = "dora-tf-demo"
}

resource "cloudfoundry_app" "dora" {
  name = "dora"
  space = "${cloudfoundry_space.demo-basel.id}"
  route {
    default_route = "${cloudfoundry_route.dora-tf-demo.id}"
  }

  #app is vendored in the repo, alternative to fetch it remotely
  url = "file://./dora"
  service_binding {
    service_instance = "${cloudfoundry_service_instance.my_mysql.id}"
  }
}



// PWS does not allow for users creation using CC API, requires webui flow for this
//resource "cloudfoundry_user" "demo-user" {
//  name = "demo@mydomain.com"
//  password = "this-account-wont-last-long"
//}
