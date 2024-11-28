terraform { 
  cloud { 
    organization = "stone-sre-devops-challange"
    workspaces { 
      name = "production" 
    } 
  } 
}