output "vpcId" {
  value = aws_vpc.vpc.id
}
output "vpcCidr" {
  value = aws_vpc.vpc.cidr_block
}
output "netEip" {
  value = aws_eip.nat.address
}
output "netId" {
  value = aws_nat_gateway.ngw.id
}
output "publicRtb" {
  value = aws_route_table.routetablepublic.id
}
output "privateRtb" {
  value = aws_route_table.routetableprivate.id
}
output "privateSubnet1" {
  value = aws_subnet.prisub1.id
}
output "privateSubnet2" {
  value = aws_subnet.prisub2.id
}
output "privateSubnet3" {
  value = aws_subnet.prisub3.id
}
output "publicSubnet1" {
  value = aws_subnet.pubsub1.id
}
output "publicSubnet2" {
  value = aws_subnet.pubsub2.id
}
output "publicSubnet3" {
  value = aws_subnet.pubsub3.id
}