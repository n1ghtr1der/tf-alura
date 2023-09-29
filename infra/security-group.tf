resource "aws_security_group" "tf-security-group" {
    name = "tf-security-group-${var.sg_name}"
    ingress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    egress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "tf-access-${var.sg_name}"
    }
}