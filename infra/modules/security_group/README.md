# Modular Security Groups Module

This module creates focused, single-purpose security groups instead of one monolithic security group with all rules. This approach follows the principle of least privilege and allows you to attach only the security groups you need to each instance.

## Security Groups Available

### SSH Security Group (`ssh`)
- **Port**: 22 (SSH)
- **Use Case**: Basic SSH access for administration
- **When to use**: For any instance that needs SSH access

### HTTP Security Group (`http`)
- **Port**: 80 (HTTP)
- **Use Case**: Web server access
- **When to use**: For web servers, load balancers, etc.

### HTTPS Security Group (`https`)
- **Port**: 443 (HTTPS)
- **Use Case**: Secure web server access
- **When to use**: For web servers with SSL/TLS

### Jenkins Security Group (`jenkins`)
- **Port**: 8080 (Jenkins web interface)
- **Use Case**: Jenkins web interface access
- **When to use**: For Jenkins master instances only

### Legacy Security Group (`legacy`)
- **Ports**: 22, 80, 443, 8080 (all rules combined)
- **Use Case**: Backward compatibility
- **When to use**: **NOT RECOMMENDED** - use specific security groups instead

## Usage Example

```hcl
module "sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  name_prefix = "myapp"
  
  # Create only the security groups you need
  create_ssh_sg = true
  create_jenkins_sg = true
  create_http_sg = false
  create_https_sg = false
  create_legacy_sg = false
  
  # CIDR blocks for each security group
  allowed_ssh_cidr = "10.0.0.0/8"
  allowed_jenkins_cidr = "0.0.0.0/0"
}

# Attach only needed security groups to instances
resource "aws_instance" "jenkins_master" {
  # ... other configuration ...
  vpc_security_group_ids = [
    module.sg.ssh_sg_id,
    module.sg.jenkins_sg_id
  ]
}

resource "aws_instance" "jenkins_slave" {
  # ... other configuration ...
  vpc_security_group_ids = [
    module.sg.ssh_sg_id  # Only SSH access needed
  ]
}
```

## Benefits

1. **Principle of Least Privilege**: Each instance only gets the access it needs
2. **Better Security**: Easier to audit and manage access controls
3. **Flexibility**: Mix and match security groups as needed
4. **Cost Optimization**: No unnecessary security group rules
5. **Maintainability**: Easier to update specific access patterns

## Migration from Legacy Approach

If you're migrating from the old monolithic security group:

1. Set `create_legacy_sg = true` temporarily
2. Update your instances to use specific security groups
3. Remove the legacy security group attachment
4. Set `create_legacy_sg = false`

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `vpc_id` | string | - | VPC ID where security groups will be created |
| `name_prefix` | string | "jenkins" | Prefix for security group names |
| `create_ssh_sg` | bool | false | Whether to create SSH security group |
| `create_http_sg` | bool | false | Whether to create HTTP security group |
| `create_https_sg` | bool | false | Whether to create HTTPS security group |
| `create_jenkins_sg` | bool | false | Whether to create Jenkins security group |
| `create_legacy_sg` | bool | false | Whether to create legacy security group |
| `allowed_ssh_cidr` | string | "0.0.0.0/0" | CIDR block for SSH access |
| `allowed_http_cidr` | string | "0.0.0.0/0" | CIDR block for HTTP access |
| `allowed_https_cidr` | string | "0.0.0.0/0" | CIDR block for HTTPS access |
| `allowed_jenkins_cidr` | string | "0.0.0.0/0" | CIDR block for Jenkins access |

## Outputs

| Output | Description |
|--------|-------------|
| `ssh_sg_id` | ID of SSH security group |
| `http_sg_id` | ID of HTTP security group |
| `https_sg_id` | ID of HTTPS security group |
| `jenkins_sg_id` | ID of Jenkins security group |
| `legacy_sg_id` | ID of legacy security group |
| `all_sg_ids` | List of all created security group IDs |
| `sg_id` | Legacy output (use specific outputs instead) | 