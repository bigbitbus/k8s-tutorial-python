# WARNING - the subnet IDs should be matched to your EKS k8s ids.
resource "aws_db_subnet_group" "dbsub" {
  name       = "main"
  subnet_ids = ["subnet-0db4edb1085a4ba22","subnet-05ed91388c9d676d7"]

  tags {
    Name = "My DB subnet group"
  }
}

# WARNING - a couple of magic strings sg ids and db name - read in via a variables preferably.
# the vpc_security_group_ids are from the EKS k8s setup.
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  instance_class       = "db.t2.micro"
  name                 = "kubernetes101db"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  vpc_security_group_ids = ["sg-03dade87817c9c30f"] # aws_security_group_rule.kube-node-ingress-self
  db_subnet_group_name   = "${aws_db_subnet_group.dbsub.id}"
}
