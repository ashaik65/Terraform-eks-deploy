resource "aws_launch_template" "eksLaunchTemplate" {
  name_prefix            = "${var.project}-${var.env}-nodegroup"
  image_id               = data.aws_ami.selected_eks_optimized_ami.id
  update_default_version = true
  key_name               = var.key_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = var.ebs_volume_type
      delete_on_termination = true
    }
  }
  vpc_security_group_ids = concat([aws_security_group.this.id], )
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      { "Name" = format("${var.project}-${var.env}-workerNode", ) },
    var.additional_tags, )
  }
  monitoring {
    enabled = true
  }
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    cluster_name = "${var.eks_cluster_name}",
  }))
  depends_on = [
    aws_security_group.this
  ]
}

resource "aws_eks_node_group" "eksNodeGroup" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.project}-${var.env}-nodegroup"
  node_role_arn   = data.aws_ssm_parameter.WorkerNodeGroupRole.value
  subnet_ids      = [data.aws_subnet.pvt1.id, data.aws_subnet.pvt2.id, data.aws_subnet.pvt3.id]
  scaling_config {
    desired_size = var.desired_capacity
    min_size     = var.min_size
    max_size     = var.max_size
  }
  capacity_type  = var.capacityType
  instance_types = var.capacityType == "SPOT" ? var.spotInstanceType : var.onDemandInstanceType
  # ami_type = "AL2_x86_64"

  launch_template {
    id      = aws_launch_template.eksLaunchTemplate.id
    version = aws_launch_template.eksLaunchTemplate.latest_version
  }
  tags = merge(
  { "Name" = format("${var.project}-${var.env}-NodeGroup", ) }, var.additional_tags, )
  depends_on = [aws_launch_template.eksLaunchTemplate]
}